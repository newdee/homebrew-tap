class Smep < Formula
  desc "Simple Markdown editor and previewer"
  homepage "https://github.com/newdee/smep"
  license any_of: ["MIT", "Apache-2.0"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The release's own build: one universal binary, listed once per
  # architecture because a url may only sit inside on_arm / on_intel.
  # scripts/bump-smep.sh keeps both in step with the latest release (the
  # version in each url and the sha256 after it).
  #
  # macOS only: the Linux release binary is linked against the build
  # machine's system libraries (X11, xkbcommon, Wayland, Vulkan) and glibc,
  # which a Homebrew prefix does not provide; Linux installs with
  # `cargo install smep` or the release tarball.
  on_macos do
    on_arm do
      url "https://github.com/newdee/smep/releases/download/v0.1.2/smep-v0.1.2-macos-universal.tar.gz"
      sha256 "afe373ea20e13f291774f7e4e00d71b7344f7eddda430cc09d58dda54727e233"
    end
    on_intel do
      url "https://github.com/newdee/smep/releases/download/v0.1.2/smep-v0.1.2-macos-universal.tar.gz"
      sha256 "afe373ea20e13f291774f7e4e00d71b7344f7eddda430cc09d58dda54727e233"
    end
  end

  def install
    bin.install "smep"
  end

  test do
    assert_match "smep #{version}", shell_output("#{bin}/smep --version")
  end
end
