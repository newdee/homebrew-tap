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
      url "https://github.com/newdee/unifyterm/releases/download/v0.5.0/unifyterm-v0.5.0-macos-aarch64.tar.gz"
      sha256 "b6d075581b9eba66cbc0d015c683c7541c47f9ff4f9923959813e243301e691f"
    end
    on_intel do
      url "https://github.com/newdee/unifyterm/releases/download/v0.5.0/unifyterm-v0.5.0-macos-x86_64.tar.gz"
      sha256 "6686d8197f15ce354de3617240bdd71b960c1487c8750238f16072b4f3e604b6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/newdee/unifyterm/releases/download/v0.5.0/unifyterm-v0.5.0-linux-x86_64.tar.gz"
      sha256 "29b32580f3af1c4788da2ea789606b56d18adb5c1c3893c215cad1ef7a5c84cc"
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
