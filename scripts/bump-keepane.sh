#!/usr/bin/env bash
# Point Formula/keepane.rb at the latest published keepane release: its
# version line, and the sha256 after each of its three urls, from the
# .sha256 files the release publishes next to each archive.
# Prints "changed=true|false" (and the version) to $GITHUB_OUTPUT when set.
set -euo pipefail

formula="Formula/keepane.rb"
tag=$(gh release view --repo newdee/keepane --json tagName --jq .tagName)
version="${tag#v}"
current=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$formula")
out="${GITHUB_OUTPUT:-/dev/null}"

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

# The sha256 that follows each url is that archive's.
awk -v v="$version" -v arm="$arm" -v intel="$intel" -v linux="$linux" '
  /^  version "/ { print "  version \"" v "\""; next }
  /url ".*-macos-aarch64\.tar\.gz"/ { want = arm }
  /url ".*-macos-x86_64\.tar\.gz"/ { want = intel }
  /url ".*-linux-x86_64\.tar\.gz"/ { want = linux }
  /^ *sha256 "/ && want != "" { sub(/"[0-9a-f]*"/, "\"" want "\""); want = ""; n++ }
  { print }
  END { if (n != 3) { print "expected 3 sha256 lines, replaced " n > "/dev/stderr"; exit 1 } }
' "$formula" > "$tmp/keepane.rb"
mv "$tmp/keepane.rb" "$formula"

echo "formula $current -> $version"
echo "changed=true" >> "$out"
echo "version=$version" >> "$out"
