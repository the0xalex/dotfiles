# Used for setting user environment variables;
# Should not contain commands that produce output or assume the shell is
# attached to a TTY. When exists in `$ZDOTDIR` it will always be read.

# If future Alex is translating bash or feeling too stupid to read the man 
# page, a not-bad cheat sheet is here:
# (https://www.bash2zsh.com/zsh_refcard/refcard.pdf) 

# XDG Base Directory (https://wiki.archlinux.org/title/XDG_Base_Directory)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

SHELL_SESSIONS_DISABLE=1    # Do not persist shell session information

# ZSH Config Dir.
# Defaults to `$HOME` in shell life cycle prior to setting.
export ZDOTDIR="${XDG_CONFIG_HOME:-HOME/.config}/zsh"

# Cargo says to put this in the env file.  Not sure why.
source "${XDG_DATA_HOME:-$HOME/.local/share}/cargo/env"
