class Smep < Formula
  desc "Simple Markdown editor and previewer"
  homepage "https://github.com/newdee/smep"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The release's own builds; scripts/bump-smep.sh keeps these two in step
  # with it (the version in each url and the sha256 after it).
  on_macos do
    url "https://github.com/newdee/smep/releases/download/v0.1.2/smep-v0.1.2-macos-universal.zip"
    sha256 "ba408b31da931bf4a5ab97d0fa301a8e5d4e3eb56692a1375456ea6695028e9c"
  end

  on_linux do
    on_intel do
      url "https://github.com/newdee/smep/releases/download/v0.1.2/smep-v0.1.2-x86_64-linux.tar.gz"
      sha256 "06d68b55968881a927303352862c77282baa7ee17cdd4613e66262a2962e687e"
    end
  end

  def install
    if OS.mac?
      # The release ships an app bundle; the program inside it is a plain
      # (universal) executable, which is what a formula installs.
      bin.install "smep.app/Contents/MacOS/smep"
    else
      bin.install "smep"
      (share/"applications").install "smep.desktop"
    end
  end

  test do
    assert_match "smep #{version}", shell_output("#{bin}/smep --version")
  end
end
