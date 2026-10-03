cask "magpie" do
  version "0.5.8"
  sha256 "da26db9cc826f7b6185ee86b6de1da0e2aa5e98842d1ad14382cc3a8ac062b31"

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
