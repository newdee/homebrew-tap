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
      url "https://github.com/newdee/smep/releases/download/v0.1.4/smep-v0.1.4-macos-universal.tar.gz"
      sha256 "eb761c3611bebf0315c6cf1ba53e6dd339cc67045560f1b166d75aecb11d7d6d"
    end
    on_intel do
      url "https://github.com/newdee/smep/releases/download/v0.1.4/smep-v0.1.4-macos-universal.tar.gz"
      sha256 "eb761c3611bebf0315c6cf1ba53e6dd339cc67045560f1b166d75aecb11d7d6d"
    end
  end

  def install
    bin.install "smep"
  end

  test do
    assert_match "smep #{version}", shell_output("#{bin}/smep --version")
  end
end
