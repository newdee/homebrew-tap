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
      url "https://github.com/newdee/unifyterm/releases/download/v0.2.0/unifyterm-v0.2.0-macos-aarch64.tar.gz"
      sha256 "a0c8bebfe153508608603b6fdbb213a2386b675eb2c11661bb8bc7dcefaa88d3"
    end
    on_intel do
      url "https://github.com/newdee/unifyterm/releases/download/v0.2.0/unifyterm-v0.2.0-macos-x86_64.tar.gz"
      sha256 "8e205d8e782d5a42549975e6270b6a1b281bb17f2bf54a42e40c9e98925b7b01"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/newdee/unifyterm/releases/download/v0.2.0/unifyterm-v0.2.0-linux-x86_64.tar.gz"
      sha256 "c272a6d00dde5c60ab0933c3cdb37d120f519496045fd7da2e139dda51a01ea1"
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
