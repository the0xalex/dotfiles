case "$(uname -s)" in
    # NOTE: Install Xcode first.
    Darwin)
        defaults write -g InitialKeyRepeat -int 12
        defaults write -g KeyRepeat -int 1
        
        # Homebrew 
        # https://brew.sh
        if ! command -v brew >/dev/null 2>&1; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            if [ $? -ne 0 ]; then
                echo "Homebrew installation failed."
                exit 1
            fi
        fi

        # Source Homebrew
        eval "$(/opt/homebrew/bin/brew shellenv)"

        # Turn off Homebrew analytics
        brew analytics off

        # packages
        local formulae=(
            neovim
            stow
            fzf
            ripgrep
            bat
            eza
            btop
            cloc
            oha
            hyperfine
            k6
            jq
            node
            gh
            gnu-units
            shellcheck
            lazygit
            gnu-sed
            powerlevel10k
            'postgresql@17'
            zsh-autosuggestions
            zsh-syntax-highlighting
            zsh-history-substring-search
        )
        local casks=(
            wezterm
            gitkraken
            linear-linear
            tableplus
            docker
            font-hack-nerd-font
        )
        for formula in "${formulae[@]}"; do
            brew install "$formula"
        done
        for cask in "${casks[@]}"; do
            brew install --cask --no-quarantine "$cask"
        done

        # Install Rust 
        # https://www.rust-lang.org/tools/install
        ! rustc --version >/dev/null 2>&1 && \
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

        # Install Bun
        # https://bun.sh/docs/installation#macos-and-linux
        if ! command -v bun >/dev/null 2>&1; then
            echo "Installing Bun"
            brew tap oven-sh/bun
            brew install bun
        fi

        # Install sdkman 
        # https://sdkman.io/install
        if ! command -v "sdk version" >/dev/null 2>&1; then
            echo "Installing sdkman..."
            SDKMAN_DIR="${XDG_DATA_HOME:-HOME/.local/share}/sdkman" \
                curl -s "https://get.sdkman.io?rcupdate=false" | bash
        fi
	
        # Apply configuration files
        stow git
        stow nvim
        stow btop
        stow wezterm
        stow zsh
        stow bun
        if [ -d $HOME/Library/Developer/Xcode/UserData/ ]; then
           mkdir -p "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
           mkdir -p "$HOME/Library/Developer/Xcode/UserData/KeyBindings"
           stow xcode
        fi
    ;;

    Linux)
    ;;

    CYGWIN* | MINGW32* | MSYS* | MINGW*)
        # Windows
    ;;

    *)
        # Other?
    ;;
esac
