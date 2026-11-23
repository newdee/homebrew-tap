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
      url "https://github.com/newdee/unifyterm/releases/download/v0.3.0/unifyterm-v0.3.0-macos-aarch64.tar.gz"
      sha256 "f76b99299d2a013e2efc7303ea4ddbc43144dc45d5d494e0c31c8699eef82f4d"
    end
    on_intel do
      url "https://github.com/newdee/unifyterm/releases/download/v0.3.0/unifyterm-v0.3.0-macos-x86_64.tar.gz"
      sha256 "562c5bb81e530fc38f2a8edf055bea1615558777a5def37023a0b6a51032b15d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/newdee/unifyterm/releases/download/v0.3.0/unifyterm-v0.3.0-linux-x86_64.tar.gz"
      sha256 "7b83a6576f1842b16587eab716ba547d10fa4d87b0d73d9e34b6110d0eb8e465"
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
