#!/bin/sh
# Some VI_MODE terminal stuffs.

bindkey -v
export KEYTIMEOUT=25

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins  # init `vi insert` as available keymap
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'                # Use beam cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam cursor for each new prompt.

# emacs-like cursor binds (just in case?)
bindkey -M viins '^A' beginning-of-line 
bindkey -M viins '^E' end-of-line 

# Alex's vim binds not worth changing at this point
bindkey -M viins '^y' end-of-line   # Accept auto-suggestion 
bindkey -v "jk" vi-cmd-mode         # quick escape to normal mode

# Add text objects for quotes and brackets.
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for m in viopp visual; do
  for c in {a,i}{\',\",\`}; do
      bindkey -M $m -- $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
      bindkey -M $m -- $c select-bracketed
  done
done

# Add surround like commands.
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# escape back into normal mode
if [[ -n "${VI_MODE_ESC_INSERT}" ]] then
    bindkey -M viins "${VI_MODE_ESC_INSERT}" vi-cmd-mode
fi

# These are enabled by zsh-history-substring-search plugin
bindkey -M vicmd '^[[Z' history-substring-search-up     # shift-tab
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Restore normal back-space behavior in visual
bindkey -v '^?' backward-delete-char

if [[ -o menucomplete ]]; then 
  # Tab complete menu:
  bindkey -M menuselect '^h' vi-backward-char
  bindkey -M menuselect '^k' vi-up-line-or-history
  bindkey -M menuselect '^l' vi-forward-char
  bindkey -M menuselect '^j' vi-down-line-or-history
  bindkey -M menuselect '^[[Z' vi-up-line-or-history    # shift tab
fi
