# confirm destructive actions
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# Platform specific
case "$(uname -s)" in
Darwin)
    alias cleardd="rm -rf $HOME/Library/Developer/Xcode/DerivedData/*"
    alias python="python3"
    alias pip="pip3"
    alias vim="nvim"
    alias units="gunits -H ''"
    if which eza > /dev/null 2>&1; then
        alias ls="eza"
        alias l="eza -alo --git --smart-group -s type"
        alias tree="eza -T -L 3"
    fi
    which bat > /dev/null 2>&1 && \
        alias cat="bat -pp --tabs=4 --theme \"Visual Studio Dark+\""
    which rg > /dev/null 2>&1 && \
        alias grep="rg"
    which gsed > /dev/null 2>&1 && \
        alias sed="gsed"
    ;;

Linux)
	alias ls="ls --color=auto"
    alias grep="grep --color=auto"
    alias egrep="egrep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias list_systemctl="systemctl list-unit-files --state=enabled"
	;;

CYGWIN* | MINGW32* | MSYS* | MINGW*)
	# MS Windows
	;;
*)
	# Other OS
	;;
esac
