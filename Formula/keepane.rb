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
      url "https://github.com/newdee/keepane/releases/download/v0.84.0/keepane-v0.84.0-macos-aarch64.tar.gz"
      sha256 "fca961d9f2e8ed8fd6ea085e11f0287df7bf4dd8215c29cae948b8ae26d53887"
    end
    on_intel do
      url "https://github.com/newdee/keepane/releases/download/v0.84.0/keepane-v0.84.0-macos-x86_64.tar.gz"
      sha256 "86b1e524e26f4e4b328130361150c58cd8dc24c807c01935bd7407808d9d8c35"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/newdee/keepane/releases/download/v0.84.0/keepane-v0.84.0-linux-x86_64.tar.gz"
      sha256 "7f1d72c479389f8a65d619b4af0ca42141b70645be8c751fa083ac8ec7b6b712"
    end
  end

  def install
    bin.install "keepane"
    pkgshare.install "keepane.conf.example"
    doc.install "README.md", "README.zh-CN.md"
    # Tab completion (bash, zsh, fish) and `man keepane`, from the program.
    generate_completions_from_executable(bin/"keepane", "completion")
    (man1/"keepane.1").write Utils.safe_popen_read(bin/"keepane", "man", "--roff")
  end

  def caveats
    <<~EOS
      An example configuration is in:
        #{opt_pkgshare}/keepane.conf.example
      Copy it to ~/.keepane.conf to use it.
    EOS
  end

  test do
    # The server's socket in the test's own directory: Homebrew's sandbox
    # lets a test reach a Unix socket only under it (not /tmp/keepane-UID).
    ENV["KEEPANE_TMPDIR"] = testpath
    assert_match "keepane #{version}", shell_output("#{bin}/keepane -V")
    # A server of its own: a detached session comes up and is listed.
    system bin/"keepane", "-L", "brewtest", "new", "-d", "-s", "t"
    assert_match(/^t: 1 windows/, shell_output("#{bin}/keepane -L brewtest ls"))
    # Completion answers from the running server; the manual is installed.
    assert_match(/^attach-session$/, shell_output("#{bin}/keepane __complete attach-s"))
    assert_match "keepane __complete", (zsh_completion/"_keepane").read
    assert_match ".TH KEEPANE 1", (man1/"keepane.1").read
  ensure
    quiet_system bin/"keepane", "-L", "brewtest", "kill-server"
  end
end
