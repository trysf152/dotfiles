setopt no_global_rcs #disable path helper on osx


case "$(uname)" in

    Darwin) # OSがMacならば
        export PATH="/usr/sbin:/sbin:/usr/local/bin:$PATH" #add path for homebrew

        if [[ -d /Applications/MacVim.app ]]; then # MacVimが存在するならば
            alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
            alias vi=vim
        fi

        ;;

esac

if [[ -e $HOME/.profile ]]; then
    source $HOME/.profile  # load .profile if exists
fi

# check stack installed and add path
if hash stack 2>/dev/null; then
    STACK_PATH=$(stack path --local-bin)
    if [[ -e $STACK_PATH ]]; then
        export PATH="$STACK_PATH:$PATH"
    fi
fi

# check rust environment
if hash cargo 2>/dev/null; then
    CARGO_PATH="$HOME/.cargo/bin"
    if [[ -e $CARGO_PATH ]]; then
        export PATH="$CARGO_PATH:$PATH"
    fi
fi

# configure pyenv
if hash pyenv 2>/dev/null; then
    export PYENV_ROOT="${HOME}/.pyenv"
    if [[ -d "${PYENV_ROOT}" ]]; then
        export PATH="${PYENV_ROOT}/bin:$PATH"
        eval "$(pyenv init -)"
        # eval "$(pyenv virtualenv-init -)"
    fi
fi

# configure node environment
if hash node 2>/dev/null; then
    export NPM_CONFIG_PREFIX="${HOME}/.npm-global"
fi
