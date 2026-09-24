cask "magpie" do
  version "0.3.1"
  sha256 "554cf6206e8930ce1a8b74ed3a282209c64ce26733877d3f5c9e1e757133c22f"

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
