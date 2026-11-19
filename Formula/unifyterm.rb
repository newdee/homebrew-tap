class Unifyterm < Formula
  desc "Terminal for Windows, macOS and Linux with the same Unix commands everywhere"
  homepage "https://github.com/newdee/unifyterm"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The release's own builds; scripts/bump-unifyterm.sh keeps these three
  # in step with it (the version in each url and the sha256 after it).
  on_macos do
    on_arm do
      url "https://github.com/newdee/unifyterm/releases/download/v0.1.1/unifyterm-v0.1.1-macos-aarch64.tar.gz"
      sha256 "9e6f46ae83224eb002abf05b63196ddae19a870891f605e9f3968086ad9dd9f6"
    end
    on_intel do
      url "https://github.com/newdee/unifyterm/releases/download/v0.1.1/unifyterm-v0.1.1-macos-x86_64.tar.gz"
      sha256 "25b10aeb2681a2c3d23a46f30fd7bd04016622c6ceaae2f827dbfcfff5adfbf2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/newdee/unifyterm/releases/download/v0.1.1/unifyterm-v0.1.1-linux-x86_64.tar.gz"
      sha256 "a45650aefc6fbc02be2237b87b8978c91a128410581bfe3ef9e6b285ef1a3c8c"
    end
  end

  def install
    # The terminal and its commands: unifyterm finds ut beside itself.
    bin.install "unifyterm", "ut"
    doc.install "README.md", "THIRD-PARTY-NOTICES"
    prefix.install "UnifyTerm.app" if OS.mac?
  end

  def caveats
    s = <<~EOS
      Start it with `unifyterm`. ut (cat, grep, jq, ... on every system) is on your PATH too.
    EOS
    if OS.mac?
      s += <<~EOS
        For the Dock and Launchpad: ln -sf #{opt_prefix}/UnifyTerm.app ~/Applications/
      EOS
    end
    if OS.linux?
      s += <<~EOS
        The window needs Vulkan and xkbcommon from your system, for one on Debian or Ubuntu:
          sudo apt install mesa-vulkan-drivers libxkbcommon-x11-0
      EOS
    end
    s
  end

  test do
    assert_match "UnifyTerm #{version}", shell_output("#{bin}/unifyterm --version")
    assert_match "ut #{version}", shell_output("#{bin}/ut --version")
    assert_equal "hi\n", pipe_output("#{bin}/ut cat", "hi\n")
  end
end
