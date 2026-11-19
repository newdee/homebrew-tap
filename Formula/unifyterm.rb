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
      url "https://github.com/newdee/unifyterm/releases/download/v0.2.2/unifyterm-v0.2.2-macos-aarch64.tar.gz"
      sha256 "41984c5c7fdde496e75ebe7840976d17e0338a7b7dbc8d2b3c1f5a2a33fcc3b5"
    end
    on_intel do
      url "https://github.com/newdee/unifyterm/releases/download/v0.2.2/unifyterm-v0.2.2-macos-x86_64.tar.gz"
      sha256 "942ba664e491e7703517dd9fe4b00777062825ce4e4766f0a874e88245096f60"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/newdee/unifyterm/releases/download/v0.2.2/unifyterm-v0.2.2-linux-x86_64.tar.gz"
      sha256 "34f3d03507b75cdce2b5e15d436244f9d8e020d8ef6a5f46711026131ea1496f"
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
