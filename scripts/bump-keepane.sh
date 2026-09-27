#!/usr/bin/env bash
# Point Formula/keepane.rb at the latest published keepane release: the
# version in each of its three urls, and the sha256 after each url, from
# the .sha256 files the release publishes next to each archive.
# Prints "changed=true|false" (and the version) to $GITHUB_OUTPUT when set.
set -euo pipefail

formula="Formula/keepane.rb"
tag=$(gh release view --repo newdee/keepane --json tagName --jq .tagName)
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
sha() {
  gh release download "$tag" --repo newdee/keepane -p "keepane-${tag}-$1.tar.gz.sha256" -D "$tmp" --clobber
  cut -d' ' -f1 "$tmp/keepane-${tag}-$1.tar.gz.sha256"
}
arm=$(sha macos-aarch64)
intel=$(sha macos-x86_64)
linux=$(sha linux-x86_64)

# Each url moves to the new version; the sha256 that follows it is that
# archive's.
awk -v old="v${current}" -v new="v${version}" -v arm="$arm" -v intel="$intel" -v linux="$linux" '
  function swap(s,   i, r) {
    r = ""
    while ((i = index(s, old)) > 0) { r = r substr(s, 1, i - 1) new; s = substr(s, i + length(old)) }
    return r s
  }
  /url ".*-macos-aarch64\.tar\.gz"/ { want = arm }
  /url ".*-macos-x86_64\.tar\.gz"/ { want = intel }
  /url ".*-linux-x86_64\.tar\.gz"/ { want = linux }
  /^ *url "/ { $0 = swap($0); u++ }
  /^ *sha256 "/ && want != "" { sub(/"[0-9a-f]*"/, "\"" want "\""); want = ""; n++ }
  { print }
  END { if (u != 3 || n != 3) { print "expected 3 urls and 3 sha256 lines, found " u " and " n > "/dev/stderr"; exit 1 } }
' "$formula" > "$tmp/keepane.rb"
mv "$tmp/keepane.rb" "$formula"

echo "formula $current -> $version"
echo "changed=true" >> "$out"
echo "version=$version" >> "$out"
