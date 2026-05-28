# ── 基础环境 ───────────────────────────────────────────────
export LANG=en_US.UTF-8
export EDITOR=vim

# ── 补全系统 ───────────────────────────────────────────────
autoload -Uz compinit
compinit -u
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'   # 补全时大小写不敏感

# ── 颜色 ───────────────────────────────────────────────────
autoload -U colors && colors
export CLICOLOR=1

# 主流社区配色：参考 GNU dircolors 默认 + solarized 风格
export LS_COLORS="\
di=1;34:\
ln=1;36:\
so=1;31:\
pi=1;33:\
ex=1;32:\
bd=1;33;40:\
cd=1;33;40:\
su=0;41:\
sg=0;43:\
tw=0;42:\
ow=34;41:\
*.tar=1;31:*.tgz=1;31:*.arc=1;31:*.arj=1;31:*.taz=1;31:\
*.lha=1;31:*.lz4=1;31:*.lzh=1;31:*.lzma=1;31:*.tlz=1;31:\
*.txz=1;31:*.tzo=1;31:*.t7z=1;31:*.zip=1;31:*.ZIP=1;31:\
*.z=1;31:*.dz=1;31:*.gz=1;31:*.lrz=1;31:*.lz=1;31:\
*.lzo=1;31:*.xz=1;31:*.zst=1;31:*.tzst=1;31:*.bz2=1;31:\
*.bz=1;31:*.tbz=1;31:*.tbz2=1;31:*.tz=1;31:*.deb=1;31:\
*.rpm=1;31:*.jar=1;31:*.war=1;31:*.ear=1;31:*.sar=1;31:\
*.rar=1;31:*.alz=1;31:*.ace=1;31:*.7z=1;31:*.iso=1;31:\
*.jpg=1;35:*.JPG=1;35:*.jpeg=1;35:*.JPEG=1;35:\
*.png=1;35:*.PNG=1;35:*.gif=1;35:*.GIF=1;35:\
*.bmp=1;35:*.tiff=1;35:*.tif=1;35:*.svg=1;35:\
*.webp=1;35:*.ico=1;35:*.xpm=1;35:*.heic=1;35:*.avif=1;35:\
*.mp3=36:*.flac=36:*.ogg=36:*.m4a=36:*.wav=36:\
*.opus=36:*.aac=36:*.wma=36:\
*.mp4=36:*.mkv=36:*.avi=36:*.mov=36:\
*.webm=36:*.flv=36:*.wmv=36:*.m4v=36:\
*.pdf=33:*.PDF=33:*.epub=33:*.mobi=33:*.azw3=33:*.djvu=33:\
*.doc=32:*.docx=32:*.xls=32:*.xlsx=32:\
*.ppt=32:*.pptx=32:*.odt=32:*.ods=32:*.odp=32:\
*.txt=37:*.md=37:*.log=37:*.csv=37:\
*.json=37:*.xml=37:*.yml=37:*.yaml=37:\
*.toml=37:*.ini=37:*.cfg=37:*.conf=37:\
*.sh=1;32:*.bash=1;32:*.zsh=1;32:*.fish=1;32:\
*.py=1;33:*.rb=1;31:*.pl=35:\
*.c=36:*.cpp=36:*.h=36:*.hpp=36:\
*.rs=1;31:*.go=36:*.java=33:\
*.js=33:*.ts=34:*.jsx=33:*.tsx=34:\
*.html=33:*.css=34:*.scss=34:*.vue=32:\
*.sql=33:*.db=1;31:"

# ── ls 别名（兼容 macOS / Linux）──────────────────────────
if ls --color=auto /dev/null &>/dev/null; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi

alias ll='ls -lh'
alias la='ls -lAh'
alias lA='ls -lAh'
alias l='ls -lh'
alias open='xdg-open'

# ── 历史记录 ───────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ── zsh 选项 ───────────────────────────────────────────────
setopt AUTO_CD

# ── 插件 ───────────────────────────────────────────────────
[[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# ── 代理（按需启用）───────────────────────────────────────
# export http_proxy="http://127.0.0.1:7897"
# export https_proxy="http://127.0.0.1:7897"
# export all_proxy="socks5://127.0.0.1:7897"
# export no_proxy="localhost,127.0.0.1,::1"

# ── PATH ───────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Prompt（starship）─────────────────────────────────────
eval "$(starship init zsh)"
