# Contains general keybinds that don't belong somewhere with a specific module.
# To find all keys, probably something like `rg "bindkey" $ZDOTDIR`

bindkey '^?' backward-delete-char                   # Backspace

bindkey '^[[A' history-substring-search-up          # Left arrow
bindkey '^[[B' history-substring-search-down        # Right arrow
