cask "smep" do
  version "0.1.11"
  sha256 "85445c061a6d0cd156f7096c6229c712afc1c1b3746c61f98ec6ee76385d90ad"

  url "https://github.com/newdee/smep/releases/download/v#{version}/smep-v#{version}-macos-universal.zip"
  name "smep"
  desc "Simple Markdown editor and previewer"
  homepage "https://github.com/newdee/smep"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The formula puts bin/smep there too; brew refuses the second one (a
  # cask cannot name a formula in conflicts_with).
  depends_on macos: :monterey

  # The application for Finder, Spotlight, the Dock and "Open With" (a bare
  # binary, which the formula installs, is a command-line tool to macOS:
  # Finder runs it inside a Terminal window), and its binary as the `smep`
  # command. The universal build runs on Apple Silicon and Intel.
  app "smep.app"
  binary "#{appdir}/smep.app/Contents/MacOS/smep"

  zap trash: [
    "~/Library/Application Support/smep",
    "~/Library/Saved Application State/com.newdee.smep.savedState",
  ]

  caveats <<~EOS
    smep.app is Developer ID signed but not yet notarized, so the first
    start from Finder is refused. Allow it once under System Settings,
    Privacy & Security, Open Anyway; or install with
      brew install --cask --no-quarantine newdee/tap/smep
  EOS
end
