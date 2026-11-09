cask "magpie" do
  version "0.6.12"
  sha256 "ab667e24bbe0e7097ae5a3cc53724250e2b0435ee24200fb2a33636ed0d5a889"

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
