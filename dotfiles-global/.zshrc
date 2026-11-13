# ============================================================
# 🚀 ULTIMATE ZSH CONFIGURATION
# ============================================================

# ------------------------------------------------------------
# 1. SYSTEM BANNER (Fastfetch - Top-level or first pane only)
# ------------------------------------------------------------
if [[ -z "$TMUX" || "$TMUX_PANE" == "%0" || "$TMUX_PANE" == "%1" ]]; then
    if [[ -f ~/.config/fastfetch/config_lightweight_arch.jsonc ]]; then
        fastfetch -c ~/.config/fastfetch/config_lightweight_arch.jsonc
    fi
fi

# ------------------------------------------------------------
# 2. SHELL OPTIONS & DIRECTORY NAVIGATION
# ------------------------------------------------------------
setopt AUTO_PUSHD           # Maintain directory stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicate directories
setopt PUSHD_SILENT         # Silent directory stack operations
setopt INTERACTIVE_COMMENTS # Allow inline comments (#)
setopt NO_BEEP              # Disable terminal beep
setopt EXTENDED_GLOB        # Advanced pattern matching
setopt GLOB_DOTS            # Match hidden files in globbing

# Report Current Working Directory (OSC 7 for Foot terminal & Wayland)
function chpwd() {
    print -Pn "\e]7;file://%m${PWD}\e\\"
}

# ------------------------------------------------------------
# 3. ADVANCED TAB COMPLETION & CACHING
# ------------------------------------------------------------
autoload -Uz compinit
# Regenerate compdump cache only once per day for instant terminal startup
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
else
    compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"

# Process completion (colorized PID and command list for kill/pkill)
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'

# ------------------------------------------------------------
# 4. HISTORY (Shared across Foot & Tmux sessions)
# ------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY          # Real-time history sync across all tabs/panes
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate commands first
setopt HIST_IGNORE_DUPS       # Don't record consecutive duplicate commands
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries
setopt HIST_FIND_NO_DUPS      # Filter duplicates during search
setopt HIST_IGNORE_SPACE      # Commands starting with space are private
setopt HIST_SAVE_NO_DUPS      # Don't save duplicates to file
setopt HIST_REDUCE_BLANKS     # Clean up superfluous whitespace
setopt HIST_VERIFY            # Review history expansions before execution

# ------------------------------------------------------------
# 5. VIM MODE & CURSOR SHAPE (Foot + Tmux compatible)
# ------------------------------------------------------------
bindkey -v
export KEYTIMEOUT=15

# Escape shortcuts: Map 'jk' and 'kj' in insert mode to Vim Normal Mode
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins 'kj' vi-cmd-mode

# ------------------------------------------------------------
# 6. UNIVERSAL KEYMAPS (Foot Terminal & Tmux keycodes)
# ------------------------------------------------------------
# Editing & Deletion
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey -M vicmd '^?' backward-delete-char
bindkey -M viins '^?' backward-delete-char
bindkey '^[[3~' delete-char
bindkey -M vicmd '^[[3~' delete-char

# Navigation (Home, End, Line start/end)
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line

# Word jumping (Ctrl+Left / Ctrl+Right)
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^W' backward-kill-word
bindkey '^U' backward-kill-line

# History Substring Search (Up/Down arrows filter based on input)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search

# ------------------------------------------------------------
# 7. ENVIRONMENT VARIABLES & COLOR
# ------------------------------------------------------------
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export COLORTERM="truecolor"
export ARCHFLAGS="-arch $(uname -m)"

# Editors
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi
export VISUAL='nvim'
export PAGER='less'

# PATH Additions
export PATH="$HOME/.local/bin:$PATH"

# Pyenv Integration

# ------------------------------------------------------------
# 8. PRODUCTIVITY ALIASES & TMUX SHORTCUTS
# ------------------------------------------------------------
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mkdir='mkdir -p'

# Colored file listing
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

# Safety operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -I'

alias reload='source ~/.zshrc && echo "Zsh reloaded successfully!"'

# Include Niri helper script aliases
if [[ -f ~/.config/niri/scripts/aliases.sh ]]; then
    source ~/.config/niri/scripts/aliases.sh
fi

# Utility function: Create dir & cd immediately
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ------------------------------------------------------------
# 9. PROMPT INITIALIZATION (Starship)
# ------------------------------------------------------------
eval "$(starship init zsh)"

# ------------------------------------------------------------
# 10. PLUGINS (Autosuggestions & Syntax Highlighting)
# ------------------------------------------------------------
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'

if [[ -f ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax highlighting MUST remain at the very bottom
if [[ -f ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
