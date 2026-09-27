# newdee/homebrew-tap

## magpie

Homebrew casks for [magpie](https://github.com/newdee/magpie), a Spotlight-style
launcher for GitHub stars, local files, bookmarks and clipboard history.

```sh
brew install --cask newdee/tap/magpie
```

Apple Silicon only, like the release it installs. magpie updates itself (signed,
verified), so `brew upgrade` leaves it alone; `brew upgrade --greedy` still works.
`brew uninstall --cask --zap magpie` also removes its index, settings and logs.

The cask follows magpie's latest release on its own: a scheduled workflow picks
up a new version, installs it on a macOS runner, checks the signature and
notarization, and only then commits it.

## keepane

[keepane](https://github.com/newdee/keepane) is a terminal multiplexer whose
panes keep running after you detach and can pass messages to each other, with
tmux's keys and commands.

```sh
brew install newdee/tap/keepane
```

macOS (Apple Silicon and Intel) and Linux x86_64, from the release's own builds.
`brew upgrade keepane` takes a new version.

The formula follows keepane's latest release on its own: a scheduled workflow
picks up a new version, installs and tests it on macOS and Linux runners, and
only then commits it.

---

## magpie

magpie 的 Homebrew 源。

```sh
brew install --cask newdee/tap/magpie
```

仅支持 Apple Silicon，与发布包一致。magpie 自带签名校验的自动更新，所以
`brew upgrade` 不会动它；需要时可用 `brew upgrade --greedy`。
`brew uninstall --cask --zap magpie` 会连同索引、设置和日志一起删掉。

cask 会自己跟进 magpie 的最新版本：定时工作流发现新版后，先在 macOS runner 上
真装一遍、校验签名和公证，通过了才提交。

## keepane

[keepane](https://github.com/newdee/keepane) 是一个终端复用器：断开之后窗格里的
程序继续运行，窗格之间可以互相发消息，按键和命令与 tmux 相同。

```sh
brew install newdee/tap/keepane
```

支持 macOS（Apple Silicon 与 Intel）和 Linux x86_64，安装的是发布页上编译好的包。
`brew upgrade keepane` 升级到新版本。

formula 会自己跟进 keepane 的最新版本：定时工作流发现新版后，先在 macOS 和
Linux runner 上真装并测试，通过了才提交。
