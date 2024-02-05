case "$(uname -s)" in
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
            oha
            gnu-units
            shellcheck
            powerlevel10k
            'postgresql@16'
            zsh-autosuggestions
            zsh-syntax-highlighting
            zsh-history-substring-search
        )
        local casks=(
            #iterm2
            wezterm
            pgadmin4
            gitkraken
            intellij-idea
        )
        for formula in "${formulae[@]}"; do
            brew install "$formula"
        done
        for cask in "${casks[@]}"; do
            brew install --cask --no-quarantine "$cask"
        done
        # special case for this one:
        brew tap homebrew/cask-fonts && brew install --cask font-hack-nerd-font

        # Install Rust 
        # https://www.rust-lang.org/tools/install
        if ! command -v "rustc --version" >/dev/null 2>&1; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        fi

        # Install sdkman 
        # https://sdkman.io/install
        if ! command -v "sdk version" >/dev/null 2>&1; then
            curl -s "https://get.sdkman.io?rcupdate=false" | bash
        fi
	
        # Apply configuration files
	    stow git
        stow nvim
        stow btop
        stow wezterm
        stow zsh
        [ -d $HOME/Library/Developer/Xcode/UserData/FontAndColorThemes ] && \
            [ -d $HOME/Library/Developer/Xcode/UserData/KeyBindings ] && \
                stow xcode
    ;;

    Linux)
        # Get zsh, set as shell
        if ! command -v zsh &> /dev/null; then
            sudo apt update
            sudo apt install -y zsh
        fi
        which zsh | sudo tee -a /etc/shells
        sudo chsh -s $(which zsh) $USER
    ;;

    CYGWIN* | MINGW32* | MSYS* | MINGW*)
        # Windows
    ;;

    *)
        # Other?
    ;;
esac
