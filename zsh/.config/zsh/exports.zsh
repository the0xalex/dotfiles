# Contains random settings I've tried and liked, or am currently trying.

export EDITOR="nvim"          # The one editor to rule them all
export MANPAGER='nvim +Man!'  # is also my man pager
export MANWIDTH=999           # and is fat.

export PAGER="cat"                      # Attempt to stop things from invoking `less`.
export LESSHISTFILE="/dev/null"         # Disable storing history for the "less" util if it gets invoked.
export LESSHISTSIZE=0                   # I hate things writing files to $HOME without permission.

unsetopt BEEP                           # Disable audible beep on error

setopt AUTO_CD                          # Automatically `cd` by typing directory name
setopt CHASE_LINKS                      # Resolve symbolic links to their true values when changing directory
setopt GLOB_DOTS                        # Include hidden files in glob patterns
setopt NOMATCH                          # Error if no files match a glob pattern
setopt MENU_COMPLETE                    # Enable menu selection for completions
setopt EXTENDED_GLOB                    # Use extended pattern matching features
setopt INTERACTIVE_COMMENTS             # Allow comments in interactive shells
setopt APPEND_HISTORY                   # Append to the history file, don't overwrite
setopt BANG_HIST                        # Treat the '!' character specially during expansion.
#setopt INC_APPEND_HISTORY              # Sync write to the hist file, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST           # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS                 # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS             # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS                # Do not display a line previously found.
setopt HIST_IGNORE_SPACE                # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS                # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS               # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY                      # Don't execute immediately upon history expansion.

zle_highlight=('paste:none')  # Disable highlighting for pasted text in ZLE

export DEV_DIR="$HOME/Developer"
[ ! -d "$DEV_DIR" ] && mkdir -p "$DEV_DIR"

# fzf settings https://github.com/junegunn/fzf
#
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always --theme \"Visual Studio Dark+\" {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'eza -T {}'"

# Postgres
export PSQL_HISTORY="${XDG_CACHE_HOME:-HOME/.cache}/psql_history"

# Rust is good (https://doc.rust-lang.org/cargo/reference/environment-variables.html)
export CARGO_HOME="$HOME/.cargo"
export RUSTUP_HOME="$HOME/.rustup"

# Jury is still out on Go.
export GOPATH="$DEV_DIR/go"

# Java is stupid
export SDKMAN_DIR="${XDG_DATA_HOME:-HOME/.local/share}/sdkman"
export GRADLE_USER_HOME="${XDG_CACHE_HOME:-HOME/.cache}/gradle"
export GRADLE_HOME="${XDG_CACHE_HOME:-HOME/.cache}/gradle"
export ANDROID_USER_HOME="${XDG_CONFIG_HOME:-HOME/.config}/android"

# Bun seems like the least awful of the pile of shit that is JS
which bun > /dev/null 2>&1 && \
    local BUN_BIN_DIR="/Users/alex/.cache/.bun/bin"

# Platform specific stuff
case "$(uname -s)" in
    Darwin)
        export HOMEBREW_NO_ANALYTICS=1
        # path variable
        typeset -U path PATH
        path=(
            "$HOME/.local/bin" 
            "$CARGO_HOME/bin"
            "$RUSTUP_HOME/bin"
            "$GOPATH/bin"
            "/usr/local/go/bin"
            "/opt/homebrew/opt/postgresql@16/bin"
            "$BUN_BIN_DIR"
            $path
        )
        ;;

    Linux)
        ;;

    CYGWIN* | MINGW32* | MSYS* | MINGW*)
        # MS Windows
        ;;
    *)
        # Other OS
        ;;
esac

export PATH
