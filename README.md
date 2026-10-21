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

## smep

[smep](https://github.com/newdee/smep) is a simple Markdown editor and
previewer written in Rust: source, split and rendered views, the rendered
one editable block by block.

```sh
brew install --cask newdee/tap/smep
smep notes.md
```

The cask puts `smep.app` in `/Applications` (Finder, Spotlight, the Dock,
"Open With", the default app for `.md`) and links its binary as the `smep`
command. macOS only (Apple Silicon and Intel, one universal build), from the
release's own build; on Linux use `cargo install smep` or the release tarball.
The app is Developer ID signed but not yet notarized: allow the first start
once under System Settings, Privacy & Security, Open Anyway, or install with
`--no-quarantine`.

`brew install newdee/tap/smep`, the formula, installs the command alone. A bare
binary is a command-line tool to macOS, so Finder and "Open With" run it inside
a Terminal window; take the cask for an application. `brew upgrade` takes a new
version of either.

Both follow smep's latest release on their own, the way keepane's formula does.

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

## smep

[smep](https://github.com/newdee/smep) 是一个 Rust 写的简洁 Markdown 编辑器兼
预览器：源码、分栏、渲染三种视图，渲染视图可以按块直接编辑。

```sh
brew install --cask newdee/tap/smep
smep notes.md
```

cask 把 `smep.app` 装进 `/Applications`（Finder、Spotlight、Dock、"打开方式"、
`.md` 默认应用都能用），并把它的二进制链接成 `smep` 命令。仅 macOS（Apple Silicon
与 Intel，同一个通用构建），安装的是发布页上编译好的包；Linux 用 `cargo install smep`
或发布页的 tarball。应用有 Developer ID 签名但还没公证：第一次启动在"系统设置 >
隐私与安全性"里点一次"仍要打开"，或者装的时候加 `--no-quarantine`。

`brew install newdee/tap/smep`（formula）只装 `smep` 命令。裸二进制在 macOS 眼里是
命令行工具，Finder 和"打开方式"会在终端窗口里运行它；要应用就装 cask。两者都用
`brew upgrade` 升级。

两者都会自己跟进 smep 的最新版本，方式与 keepane 的 formula 相同。
