setopt no_global_rcs #disable path helper
typeset -U path PATH

case "$(uname)" in
    Darwin)
        HBREW_DIR="/usr/local/bin"
        path=(/usr/local/bin(N-/) $path /usr/sbin /sbin)

        if [[ -d /Applications/MacVim.app ]]; then
            alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
            alias vi=vim
        fi
        ;;
esac

# check stack installed and add path
if hash stack 2>/dev/null; then
    STACK_PATH=$(stack path --local-bin)
    path=($STACK_PATH(N-/) $path)
fi

# check rust environment
CARGO_PATH="$HOME/.cargo/bin"
path=($CARGO_PATH(N-/) $path)

# configure pyenv
if hash pyenv 2>/dev/null; then
    PYENV_ROOT="${HOME}/.pyenv"
    path=($PYENV_ROOT(N-/) $path)
    export PIPENV_VENV_IN_PROJECT=true
    eval "$(pyenv init -)"
fi

    # configure node environment
if hash node 2>/dev/null; then
    export NPM_CONFIG_PREFIX="${HOME}/.npm-global"
fi
