cask "magpie" do
  version "0.3.0"
  sha256 "4f3402209c997f80e36d5e9cb17260138ef95b3cd3cae3478b00616d3344f62e"

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
