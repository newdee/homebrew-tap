cask "magpie" do
  version "0.4.1"
  sha256 "5c15076aa8b5abd652829f4ac671b68de068ed690297a1e5a1a4a4153defcfeb"

  url "https://github.com/newdee/magpie/releases/download/v#{version}/magpie_#{version}_aarch64.dmg"
  name "magpie"
  desc "Spotlight-style launcher for GitHub stars, local files, bookmarks and clipboard"
  homepage "https://github.com/newdee/magpie"

  livecheck do
    url :url
    strategy :github_latest
  end

  # the app updates itself (signed, verified), so brew leaves upgrades to it
  auto_updates true
  depends_on arch: :arm64

  app "magpie.app"

  zap trash: [
    "~/Library/Application Support/com.dfine.magpie",
    "~/Library/Caches/com.dfine.magpie",
    "~/Library/LaunchAgents/magpie.plist",
    "~/Library/Logs/com.dfine.magpie",
    "~/Library/Preferences/com.dfine.magpie.plist",
    "~/Library/Saved Application State/com.dfine.magpie.savedState",
    "~/Library/WebKit/com.dfine.magpie",
  ]
end
