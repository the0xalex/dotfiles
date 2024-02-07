# Use a cached, compiled p10k prompt (for startup speed).
# Init code with console input (e.g. password, [y/n] confirmations)
# must go above this block; everything else may go below.
local cached_prompt="${XDG_CACHE_HOME:-HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
[[ -r "$cached_prompt" ]] && source "$cached_prompt"

export HISTFILE="${XDG_CACHE_HOME:-HOME/.cache}/zsh_history"
LESSHISTFILE=-              # Do not persist Less query data (default pager)
HISTSIZE=1000000            # Size limit (bytes) of the shell history file
SAVEHIST=800000             # (starts rotating at +20%)

# Platform dependent config
case "$(uname -s)" in
    Darwin)
        eval "$(/opt/homebrew/bin/brew shellenv)"
        local bp="$(brew --prefix)"
        local brew_managed_shell_plugins=(
            "$bp/share/powerlevel10k/powerlevel10k.zsh-theme"
            "$bp/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
            "$bp/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
            "$bp/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
            "$bp/opt/fzf/shell/completion.zsh"
            "$bp/opt/fzf/shell/key-bindings.zsh"
        )
        for file in "${brew_managed_shell_plugins[@]}"; do
            [[ -f $file ]] && source "$file"
        done
        ;;

    Linux)
        alias ls="ls --color=auto"
        alias grep="grep --color=auto"
        alias egrep="egrep --color=auto"
        alias fgrep="fgrep --color=auto"
        ;;

    CYGWIN* | MINGW32* | MSYS* | MINGW*)
        # Windows
        ;;
    *)
        # Other OS
        ;;
esac

# Cross platform config
local config_files=(
  "$ZDOTDIR/keys.zsh"           # General keybinds
  "$ZDOTDIR/vim.zsh"            # Terminal VI_MODE config
  "$ZDOTDIR/completions.zsh"    # ZSH Completions
  "$ZDOTDIR/exports.zsh"        # General settings
  "$ZDOTDIR/aliases.zsh"        # General aliases
  "$ZDOTDIR/git-alias.zsh"      # Some Git aliases
  "$ZDOTDIR/prompt.zsh"         # Prompt Config
)

# Java was a horrible idea from the very beginning.
# Should be after other config crap to work right.
[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && \
    config_files+=("$SDKMAN_DIR/bin/sdkman-init.sh")

for file in "${config_files[@]}"; do
    [[ -f $file ]] && source "$file"
done
