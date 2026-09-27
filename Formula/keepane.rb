class Keepane < Formula
  desc "Terminal multiplexer whose panes keep running and pass messages to each other"
  homepage "https://github.com/newdee/keepane"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # The release's own builds; scripts/bump-keepane.sh keeps these three
  # in step with it (the version in each url and the sha256 after it).
  on_macos do
    on_arm do
      url "https://github.com/newdee/keepane/releases/download/v0.18.0/keepane-v0.18.0-macos-aarch64.tar.gz"
      sha256 "0ac96b2ab897327e8d143dcffaa18f8f3cf392e8d7e462cae5183fefcf339955"
    end
    on_intel do
      url "https://github.com/newdee/keepane/releases/download/v0.18.0/keepane-v0.18.0-macos-x86_64.tar.gz"
      sha256 "47892607001586575958e62e651bb2398c971f9a9c51d6ae982a67410f88da13"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/newdee/keepane/releases/download/v0.18.0/keepane-v0.18.0-linux-x86_64.tar.gz"
      sha256 "00054280137056a262060416b6f56ab5f15946c745bfc36f3a0f74723551f451"
    end
  end

  def install
    bin.install "keepane"
    pkgshare.install "keepane.conf.example"
    doc.install "README.md", "README.zh-CN.md"
  end

  def caveats
    <<~EOS
      An example configuration is in:
        #{opt_pkgshare}/keepane.conf.example
      Copy it to ~/.keepane.conf to use it.
    EOS
  end

  test do
    assert_match "keepane #{version}", shell_output("#{bin}/keepane -V")
    # A server of its own: a detached session comes up and is listed.
    system bin/"keepane", "-L", "brewtest", "new", "-d", "-s", "t"
    assert_match(/^t: 1 windows/, shell_output("#{bin}/keepane -L brewtest ls"))
  ensure
    quiet_system bin/"keepane", "-L", "brewtest", "kill-server"
  end
end
