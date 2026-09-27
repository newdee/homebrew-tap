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
      url "https://github.com/newdee/keepane/releases/download/v0.17.0/keepane-v0.17.0-macos-aarch64.tar.gz"
      sha256 "aa623896bdea469fdd93254d33925b43e8d4d8a44dd8db554fab9dd212bb782e"
    end
    on_intel do
      url "https://github.com/newdee/keepane/releases/download/v0.17.0/keepane-v0.17.0-macos-x86_64.tar.gz"
      sha256 "a5426b3f52831861035bda0e96e9e911e1d71abd393907a92e693c603b69ae77"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/newdee/keepane/releases/download/v0.17.0/keepane-v0.17.0-linux-x86_64.tar.gz"
      sha256 "fe431be9015d8d14af37f67bf4f20f496429b3009665c08b536c1d70fb51be31"
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
