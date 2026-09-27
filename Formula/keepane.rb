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
      url "https://github.com/newdee/keepane/releases/download/v0.19.0/keepane-v0.19.0-macos-aarch64.tar.gz"
      sha256 "d68b2fd3d9678f7940779223a1027c99fc9fad2620e9ea1abaaec9377fc42dea"
    end
    on_intel do
      url "https://github.com/newdee/keepane/releases/download/v0.19.0/keepane-v0.19.0-macos-x86_64.tar.gz"
      sha256 "25c6071f3810d02af36c5eb8d1971651806356ff327f02ee5d80e1cb178a5225"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/newdee/keepane/releases/download/v0.19.0/keepane-v0.19.0-linux-x86_64.tar.gz"
      sha256 "4327f5c42bcc57699af87412e6185a8a432b5ab6c514b3ac2da0ae08e9a44948"
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
