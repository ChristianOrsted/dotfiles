# dotfiles

我的 zsh + Starship 终端配置，一键部署到任意 Linux 环境。

## 包含内容

| 组件 | 说明 |
|------|------|
| [zsh](https://www.zsh.org/) | Shell |
| [Starship](https://starship.rs/) | 跨平台终端提示符 |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | 历史命令自动建议 |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | 实时语法高亮 |

## 快速安装

```bash
git clone https://github.com/ChristianOrsted/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

安装脚本会自动：
1. 检测系统包管理器（apt / pacman / dnf / yum / zypper）
2. 安装 zsh、git、curl（若未安装）
3. 克隆 zsh-autosuggestions 和 zsh-syntax-highlighting 到 `~/.zsh/`
4. 通过官方脚本安装 starship 到 `~/.local/bin/`
5. 将配置文件以符号链接方式部署，原有文件自动备份
6. 可选：将默认 Shell 切换为 zsh

## 字体要求

`starship.toml` 使用了 Nerd Font 图标，需要在**本地终端**中设置 Nerd Font 字体，否则会出现乱码。

> **SSH 远程连接无需在服务器上安装字体。** 字体由本地终端模拟器负责渲染，远程机器只传输字符数据。

本配置使用的字体：**[MesloLGS NF](https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf)**（Meslo LGS Nerd Font）

安装后在终端模拟器的设置中将字体切换为 `MesloLGS NF` 即可。

## 代理配置

`.zshrc` 中的代理部分默认注释掉，按需手动启用：

```bash
# ~/.zshrc
export http_proxy="http://127.0.0.1:7897"
export https_proxy="http://127.0.0.1:7897"
export all_proxy="socks5://127.0.0.1:7897"
export no_proxy="localhost,127.0.0.1,::1"
```

## 文件结构

```
dotfiles/
├── install.sh          # 安装脚本
├── configs/
│   ├── .zshrc          # zsh 配置
│   └── starship.toml   # Starship 主题配置
└── README.md
```

## 更新配置

修改 `configs/` 下的文件后，由于使用了符号链接，改动会立即生效，无需重新运行安装脚本。

重新拉取并更新插件：

```bash
git -C ~/.zsh/zsh-autosuggestions pull
git -C ~/.zsh/zsh-syntax-highlighting pull
```
