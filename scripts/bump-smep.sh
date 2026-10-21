#!/usr/bin/env bash
# Point Formula/smep.rb and Casks/smep.rb at the latest published smep
# release. In the formula: the version in each of its two urls (on_arm and
# on_intel name the same universal macOS archive) and the sha256 after
# each, computed from the downloaded archive. In the cask: the version and
# sha256 lines (its url is built from the version), from the .app zip.
# Prints "changed=true|false" (and the version) to $GITHUB_OUTPUT when set.
set -euo pipefail

formula="Formula/smep.rb"
cask="Casks/smep.rb"
tag=$(gh release view --repo newdee/smep --json tagName --jq .tagName)
version="${tag#v}"
# The formula's version is the one in its urls (brew reads it from there).
formula_current=$(sed -n 's|.*/releases/download/v\([^/]*\)/.*|\1|p' "$formula" | sort -u)
cask_current=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$cask")
out="${GITHUB_OUTPUT:-/dev/null}"

if [ "$(printf '%s\n' "$formula_current" | wc -l)" -ne 1 ] || [ -z "$formula_current" ]; then
  echo "expected one version in the formula's urls, found: $formula_current" >&2
  exit 1
fi
if [ -z "$cask_current" ]; then
  echo "no version line in $cask" >&2
  exit 1
fi
if [ "$version" = "$formula_current" ] && [ "$version" = "$cask_current" ]; then
  echo "formula and cask already at $version"
  echo "changed=false" >> "$out"
  exit 0
fi

tmp=$(mktemp -d)
# Downloads a release asset and prints its sha256.
fetch() {
  curl -fsSL --retry 3 "https://github.com/newdee/smep/releases/download/${tag}/$1" -o "$tmp/$1"
  shasum -a 256 "$tmp/$1" | cut -d' ' -f1
}

if [ "$version" != "$formula_current" ]; then
  mac=$(fetch "smep-${tag}-macos-universal.tar.gz")
  # Each url moves to the new version; the sha256 that follows it is the
  # archive's.
  awk -v old="v${formula_current}" -v new="v${version}" -v mac="$mac" '
    function swap(s,   i, r) {
      r = ""
      while ((i = index(s, old)) > 0) { r = r substr(s, 1, i - 1) new; s = substr(s, i + length(old)) }
      return r s
    }
    /url ".*-macos-universal\.tar\.gz"/ { want = mac }
    /^ *url "/ { $0 = swap($0); u++ }
    /^ *sha256 "/ && want != "" { sub(/"[0-9a-f]*"/, "\"" want "\""); want = ""; n++ }
    { print }
    END { if (u != 2 || n != 2) { print "expected 2 urls and 2 sha256 lines, found " u " and " n > "/dev/stderr"; exit 1 } }
  ' "$formula" > "$tmp/smep.rb"
  mv "$tmp/smep.rb" "$formula"
  echo "formula $formula_current -> $version ($mac)"
fi

if [ "$version" != "$cask_current" ]; then
  app=$(fetch "smep-${tag}-macos-universal.zip")
  # BSD and GNU sed disagree on -i; write through a temp file instead
  sed -e "s/^  version \".*\"$/  version \"${version}\"/" \
      -e "s/^  sha256 \".*\"$/  sha256 \"${app}\"/" "$cask" > "$tmp/smep-cask.rb"
  mv "$tmp/smep-cask.rb" "$cask"
  echo "cask $cask_current -> $version ($app)"
fi

echo "changed=true" >> "$out"
echo "version=$version" >> "$out"
