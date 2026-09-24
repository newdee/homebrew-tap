#!/usr/bin/env bash
# Point Casks/magpie.rb at the latest published magpie release.
# Prints "changed=true|false" (and the version) to $GITHUB_OUTPUT when set.
set -euo pipefail

cask="Casks/magpie.rb"
tag=$(gh release view --repo newdee/magpie --json tagName --jq .tagName)
version="${tag#v}"
current=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$cask")
out="${GITHUB_OUTPUT:-/dev/null}"

if [ "$version" = "$current" ]; then
  echo "cask already at $current"
  echo "changed=false" >> "$out"
  exit 0
fi

url="https://github.com/newdee/magpie/releases/download/v${version}/magpie_${version}_aarch64.dmg"
tmp=$(mktemp -d)
curl -fsSL --retry 3 "$url" -o "$tmp/magpie.dmg"
sha=$(shasum -a 256 "$tmp/magpie.dmg" | cut -d' ' -f1)

# BSD and GNU sed disagree on -i; write through a temp file instead
sed -e "s/^  version \".*\"$/  version \"${version}\"/" \
    -e "s/^  sha256 \".*\"$/  sha256 \"${sha}\"/" "$cask" > "$tmp/magpie.rb"
mv "$tmp/magpie.rb" "$cask"

echo "cask $current -> $version ($sha)"
echo "changed=true" >> "$out"
echo "version=$version" >> "$out"
