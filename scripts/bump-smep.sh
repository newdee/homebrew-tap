#!/usr/bin/env bash
# Point Formula/smep.rb at the latest published smep release: the version
# in each of its two urls (on_arm and on_intel name the same universal
# macOS archive), and the sha256 after each url, computed from the
# downloaded archive.
# Prints "changed=true|false" (and the version) to $GITHUB_OUTPUT when set.
set -euo pipefail

formula="Formula/smep.rb"
tag=$(gh release view --repo newdee/smep --json tagName --jq .tagName)
version="${tag#v}"
# The formula's version is the one in its urls (brew reads it from there).
current=$(sed -n 's|.*/releases/download/v\([^/]*\)/.*|\1|p' "$formula" | sort -u)
out="${GITHUB_OUTPUT:-/dev/null}"

if [ "$(printf '%s\n' "$current" | wc -l)" -ne 1 ] || [ -z "$current" ]; then
  echo "expected one version in the urls, found: $current" >&2
  exit 1
fi
if [ "$version" = "$current" ]; then
  echo "formula already at $current"
  echo "changed=false" >> "$out"
  exit 0
fi

tmp=$(mktemp -d)
archive="smep-${tag}-macos-universal.tar.gz"
curl -fsSL --retry 3 "https://github.com/newdee/smep/releases/download/${tag}/${archive}" -o "$tmp/$archive"
mac=$(shasum -a 256 "$tmp/$archive" | cut -d' ' -f1)

# Each url moves to the new version; the sha256 that follows it is the
# archive's.
awk -v old="v${current}" -v new="v${version}" -v mac="$mac" '
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

echo "formula $current -> $version ($mac)"
echo "changed=true" >> "$out"
echo "version=$version" >> "$out"
