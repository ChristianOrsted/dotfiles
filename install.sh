#!/usr/bin/env bash
set -euo pipefail

# ── 颜色 ───────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
info() { echo -e "${BLUE}[→]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }
step() { echo -e "\n${BOLD}${BLUE}── $1 ──${NC}"; }

# ── 检测包管理器 ───────────────────────────────────────────
detect_pkg_manager() {
    if   command -v apt-get &>/dev/null; then echo "apt"
    elif command -v pacman  &>/dev/null; then echo "pacman"
    elif command -v dnf     &>/dev/null; then echo "dnf"
    elif command -v yum     &>/dev/null; then echo "yum"
    elif command -v zypper  &>/dev/null; then echo "zypper"
    else err "未找到支持的包管理器（apt/pacman/dnf/yum/zypper）"; fi
}

install_pkg() {
    local pkg="$1"
    local mgr
    mgr=$(detect_pkg_manager)
    info "安装 $pkg（$mgr）..."
    case "$mgr" in
        apt)    sudo apt-get install -y "$pkg" ;;
        pacman) sudo pacman -S --noconfirm "$pkg" ;;
        dnf)    sudo dnf install -y "$pkg" ;;
        yum)    sudo yum install -y "$pkg" ;;
        zypper) sudo zypper install -yn "$pkg" ;;
    esac
}

# ── 安装 zsh ───────────────────────────────────────────────
install_zsh() {
    step "zsh"
    if command -v zsh &>/dev/null; then
        log "zsh 已安装：$(zsh --version)"
        return
    fi
    install_pkg zsh
    log "zsh 安装完成"
}

# ── 安装 zsh-autosuggestions ───────────────────────────────
install_autosuggestions() {
    step "zsh-autosuggestions"
    local target="$HOME/.zsh/zsh-autosuggestions"
    if [[ -d "$target/.git" ]]; then
        info "更新 zsh-autosuggestions..."
        git -C "$target" pull --ff-only
    else
        mkdir -p "$HOME/.zsh"
        git clone --depth=1 \
            https://github.com/zsh-users/zsh-autosuggestions \
            "$target"
    fi
    log "zsh-autosuggestions 就绪"
}

# ── 安装 zsh-syntax-highlighting ──────────────────────────
install_syntax_highlighting() {
    step "zsh-syntax-highlighting"
    local target="$HOME/.zsh/zsh-syntax-highlighting"
    if [[ -d "$target/.git" ]]; then
        info "更新 zsh-syntax-highlighting..."
        git -C "$target" pull --ff-only
    else
        mkdir -p "$HOME/.zsh"
        git clone --depth=1 \
            https://github.com/zsh-users/zsh-syntax-highlighting \
            "$target"
    fi
    log "zsh-syntax-highlighting 就绪"
}

# ── 安装 starship ──────────────────────────────────────────
install_starship() {
    step "starship"
    if command -v starship &>/dev/null; then
        log "starship 已安装：$(starship --version)"
        return
    fi
    info "下载并安装 starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    log "starship 安装完成"
}

# ── 备份并创建符号链接 ─────────────────────────────────────
link_config() {
    local src="$1"
    local dst="$2"

    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        mkdir -p "$BACKUP_DIR"
        warn "备份已有文件：$dst → $BACKUP_DIR/"
        mv "$dst" "$BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    log "链接：$dst → $src"
}

# ── 部署配置文件 ───────────────────────────────────────────
deploy_configs() {
    step "部署配置文件"
    link_config "$DOTFILES_DIR/configs/.zshrc"       "$HOME/.zshrc"
    link_config "$DOTFILES_DIR/configs/starship.toml" "$HOME/.config/starship.toml"
}

# ── 可选：切换默认 Shell ───────────────────────────────────
change_shell() {
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [[ "$SHELL" == "$zsh_path" ]]; then
        log "默认 Shell 已经是 zsh"
        return
    fi

    step "切换默认 Shell"
    read -rp "将默认 Shell 切换为 zsh？[y/N] " reply
    if [[ "$reply" =~ ^[Yy]$ ]]; then
        # 确保 zsh 在 /etc/shells 中
        if ! grep -qxF "$zsh_path" /etc/shells; then
            echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
        fi
        chsh -s "$zsh_path"
        log "默认 Shell 已切换为 zsh"
    else
        info "跳过，保持当前 Shell：$SHELL"
    fi
}

# ── 主流程 ────────────────────────────────────────────────
main() {
    echo -e "${BOLD}dotfiles 安装脚本${NC}"
    echo "工作目录：$DOTFILES_DIR"

    # 前置依赖
    step "前置依赖"
    command -v git  &>/dev/null || install_pkg git
    command -v curl &>/dev/null || install_pkg curl
    log "git 和 curl 就绪"

    install_zsh
    install_autosuggestions
    install_syntax_highlighting
    install_starship
    deploy_configs
    change_shell

    echo -e "\n${GREEN}${BOLD}全部完成！${NC}"
    echo "重启终端或执行以下命令立即生效："
    echo -e "  ${BOLD}exec zsh${NC}"
}

main "$@"
