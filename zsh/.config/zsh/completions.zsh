# Add completion paths
which brew > /dev/null 2>&1 && \
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

autoload -Uz compinit; compinit -C -D
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
_comp_options+=(globdots)  # Include hidden files.

# Clear completion dumps older than 24 hours
for dump in "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"*(N.mh+24); do
  rm -f "$dump"
done

# Init the comps
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
