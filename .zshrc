# ============================================================
# ZSH — Vim-first, Gruvbox, Alacritty-friendly, fast (CORRECT)
# ============================================================
export PATH="$HOME/.local/bin:$PATH"
# ------------------------------
# Safety & performance
# ------------------------------
setopt NO_BEEP
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY
setopt SHARE_HISTORY

export KEYTIMEOUT=1
export ZSH_DISABLE_COMPFIX=true

# ------------------------------
# Vi mode
# ------------------------------
bindkey -v
bindkey -M viins '^[[A' history-beginning-search-backward
bindkey -M viins '^[[B' history-beginning-search-forward

bindkey -M vicmd '^[[A' history-beginning-search-backward
bindkey -M vicmd '^[[B' history-beginning-search-forward
bindkey '^L' clear-screen
bindkey '^U' backward-kill-line

# ------------------------------
# History
# ------------------------------
HISTSIZE=10000
SAVEHIST=10000

# ------------------------------
# fzf history search (Ctrl-R)
# ------------------------------
fzf-history-widget() {
  local selected
  selected=$(fc -rl 1 |
    sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//' |
    fzf --ansi \
        --height=40% \
        --layout=reverse \
        --prompt='History > ' \
        --preview 'echo {}' \
        --preview-window=down:3:wrap)

  if [[ -n "$selected" ]]; then
    LBUFFER="$selected"
  fi
  zle redisplay
}

zle -N fzf-history-widget

# Bind Ctrl-R in both vi insert and normal mode
bindkey -M viins '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget
# ------------------------------
# Homebrew
# ------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# ------------------------------
# Completion system (FAST)
# ------------------------------
autoload -Uz compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*' verbose false
zstyle ':completion:*' menu no

# Cache + speed
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zcompcache

# Reuse dump, skip audit
if [[ -f ~/.zcompdump ]]; then
  compinit -C -d ~/.zcompdump
else
  compinit -d ~/.zcompdump
fi

# ------------------------------
# fzf-tab (plugin)
# ------------------------------
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# ------------------------------
# fzf — Gruvbox Dark
# ------------------------------
export FZF_DEFAULT_OPTS="
--height=40%
--layout=reverse
--border
--ansi
--preview-window=right:60%
--color=bg+:#3c3836,bg:#282828,spinner:#fe8019,hl:#fabd2f
--color=fg:#ebdbb2,header:#83a598,info:#8ec07c,pointer:#fe8019
--color=marker:#fb4934,fg+:#ebdbb2,hl+:#fabd2f
--color=prompt:#b8bb26,query:#ebdbb2
"

# ------------------------------
# fzf-tab behavior (VALID ACTIONS ONLY)
# ------------------------------
zstyle ':fzf-tab:*' switch-group ',' '.'

zstyle ':fzf-tab:*' fzf-bindings \
  'ctrl-j:down' \
  'ctrl-k:up' \
  'ctrl-h:abort' \
  'ctrl-l:execute(
    file=$(echo {} | cut -d: -f1);
    line=$(echo {} | cut -d: -f2);
    nvim +$line $file
  )'

# ------------------------------
# Preview panes
# ------------------------------

# cd preview (git-aware)
zstyle ':fzf-tab:complete:cd:*' fzf-preview '
if [[ -d $realpath/.git ]]; then
  git -C $realpath status --short --branch
else
  ls --color=always $realpath
fi
'

# Smart file preview
zstyle ':fzf-tab:complete:*:*' fzf-preview '
if [[ -d $realpath ]]; then
  ls --color=always $realpath
elif file $realpath | grep -q text; then
  case $realpath in
    *.json)
      jq . $realpath 2>/dev/null | head -300
      ;;
    *.log)
      sed -n "1,300p" $realpath
      ;;
    *)
      bat --style=numbers --color=always --line-range :300 $realpath 2>/dev/null \
      || sed -n "1,300p" $realpath
      ;;
  esac
else
  echo "Binary file"
fi
'

# Git branch preview
zstyle ':fzf-tab:complete:git-(checkout|switch):*' fzf-preview '
git log --oneline --decorate --color=always {1} | head -200
'

# ------------------------------
# Grep / fgrep / rg preview ONLY
# ------------------------------
zstyle ':fzf-tab:complete:(grep|fgrep|rg):*' fzf-preview '
file=$(echo {1} | cut -d: -f1)
line=$(echo {1} | cut -d: -f2)

bat --style=numbers --color=always \
  --highlight-line $line \
  --line-range $((line-10)):$((line+10)) $file 2>/dev/null \
|| sed -n "$((line-10)),$((line+10))p" $file
'

# ------------------------------
# Grep → Neovim quickfix
# ------------------------------
vg() {
  if [[ -z "$1" ]]; then
    echo "usage: vg <pattern> [path]"
    return 1
  fi
  rg --vimgrep "$@" | nvim -q /dev/stdin
}

vf() {
  if [[ -z "$1" ]]; then
    echo "usage: vf <pattern> [path]"
    return 1
  fi

  local pattern="$1"
  shift

  rg --line-number --no-heading --color=always "$pattern" "$@" |
    fzf --ansi \
        --delimiter ':' \
        --preview '
          file=$(printf "%s\n" {} | cut -d: -f1)
          line=$(printf "%s\n" {} | cut -d: -f2)

          if printf "%s\n" "$line" | grep -Eq "^[0-9]+$"; then
            start=$(awk -v l="$line" "BEGIN { s=l-10; if (s<1) s=1; print s }")
            end=$(awk -v l="$line" "BEGIN { print l+10 }")

            bat --style=numbers --color=always \
                --highlight-line "$line" \
                --line-range "$start:$end" "$file" 2>/dev/null \
            || sed -n "${start},${end}p" "$file"
          else
            bat --style=numbers --color=always "$file" 2>/dev/null \
            || sed -n "1,200p" "$file"
          fi
        ' \
        --bind 'enter:execute(nvim +{2} {1})'
}

# ------------------------------
# Aliases
# ------------------------------
alias ll='ls -lah'
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gco='git checkout'
alias gsm='git switch main'
alias gs='git switch'
alias gpl='git pull'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias e='nvim'
alias c='clear'

# ------------------------------
# Starship
# ------------------------------
eval "$(starship init zsh)"

# Added by Windsurf
export PATH="/Users/aidanoneil/.codeium/windsurf/bin:$PATH"

# --- Postgres env shortcuts (pg_service.conf: dev / qa / prod) ---

# psql shortcuts
alias pdev='psql "service=dev"'
alias pqa='psql "service=qa"'
alias pprod='psql "service=prod"'

# quick one-liners: psql -c
pdevc()  { psql "service=dev"  -v ON_ERROR_STOP=1 -X -c "$*"; }
pqac()   { psql "service=qa"   -v ON_ERROR_STOP=1 -X -c "$*"; }
pprodc() { psql "service=prod" -v ON_ERROR_STOP=1 -X -c "$*"; }

# open an interactive session to a specific DB name (overrides dbname in the service)
pdevdb()  { psql "service=dev dbname=$1"; }
pqadb()   { psql "service=qa dbname=$1"; }
pproddb() { psql "service=prod dbname=$1"; }

# Harlequin shortcuts (it will read libpq env via PGSERVICE)
hdev()  { PGSERVICEFILE="$HOME/.pg_service.conf" PGSERVICE=dev  harlequin -a postgres -t gruvbox; }
hqa()   { PGSERVICEFILE="$HOME/.pg_service.conf" PGSERVICE=qa   harlequin -a postgres -t tokyo-night; }
hprod() { PGSERVICEFILE="$HOME/.pg_service.conf" PGSERVICE=prod harlequin -a postgres -t catppuccin-latte; }
export PATH="/Library/TeX/texbin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"

# Added by Antigravity
export PATH="/Users/aidanoneil/.antigravity/antigravity/bin:$PATH"

# Added by Antigravity
export PATH="/Users/aidanoneil/.antigravity/antigravity/bin:$PATH"

# Added by Antigravity
export PATH="/Users/aidanoneil/.antigravity/antigravity/bin:$PATH"


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/aidanoneil/.opam/opam-init/init.zsh' ]] || source '/Users/aidanoneil/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

# sentry
fpath=("/Users/aidanoneil/.local/share/zsh/site-functions" $fpath)
