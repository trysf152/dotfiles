export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME=~/.config
# export LANGUAGE=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
# export LC_CTYPE=en_US.UTF-8
# ------------------------------------------------------------------------------
# define functions

# check given command is available via 'hash
function is_available() { hash "$1" >/dev/null 2>&1; return $?; }

# print os glyph from nerd fonts
function print_os_glyph() {
    case "$(uname)" in
        Darwin)
            if runs_on_macX86_64; then
                printf $'\UF302 \UF129'
            else
                printf $'\UF302'
            fi
            ;;
        Linux*)
            if [[ -e '/etc/os-release' ]]; then
                local distro_id="$(</etc/os-release|grep '^ID=')"
                case ${distro_id#'ID='} in
                    arch) printf $'\UF303' ;;
                    centos) printf $'\UF304' ;;
                    debian) printf $'\UF306' ;;
                    fedora) printf $'\UF30A' ;;
                    manjaro) printf $'\UF312' ;;
                    opensuse) printf $'\UF314' ;;
                    raspbian) printf $'\UF315' ;;
                    sles) printf $'\UF314' ;;
                    ubuntu) printf $'\UF31C' ;;
                    # slackware) printf $'\UF318' ;;
                    # nixos) printf $'\UF313' ;;
                    # mint) printf $'\UF30F' ;;
                    # alpine) printf $'\UF300' ;;
                    # redhat) printf $'\UF316' ;;
                esac
            else
                printf $'\UF83C'
            fi
            ;;
        *)
            printf $'\UF841'
            ;;
    esac
}

# weather from wttr.in
function get_weather() {
    local format=""
    while getopts L:d:l:sf: option
    do
        case ${option} in
            l) local target_loc="${OPTARG}"
                ;;
            d) local days="${OPTARG}"  # TODO: chack value(0-3)
                ;;
            L) local lang_="${OPTARG}"
                ;;
            s) local format='%l:+%c++%t++%w++%p++%P'
                ;;
            f) local format=''"${OPTARG}"
                ;;
        esac
    done

    curl -s "wttr.in/${target_loc}"\?"${days:=1n}qA&lang=${lang_:=ja}&format=${format:=}"
}


# setup path, environment
typeset -U path PATH

case "$(uname)" in
    Darwin)
        setopt no_global_rcs #disable path helper
        path=(${path} '/usr/sbin'(N-/) '/sbin'(N-/)) # init path

        # return true if macOS runs on Arm64
        function runs_on_macARM64() { [[ "$(uname -m)" = 'arm64' ]]; }
        # return true if macOS runs on x86_64 or Rosetta2
        function runs_on_macX86_64() { [[ "$(uname -m)" = 'x86_64' ]]; }

        # path of hoembrew on /opt/homebrew
        BREW_PATH_OPT='/opt/homebrew'
        # path of hoembrew on /usr/local
        BREW_PATH_LOCAL='/usr/local'
        # returns true if hoembrew installed on /opt
        function brew_exists_at_opt() { [[ -d "${BREW_PATH_OPT}/bin" ]]; }
        # returns true if hoembrew installed on /usr/bin
        function brew_exists_at_local() { [[ -d "${BREW_PATH_LOCAL}/bin" ]]; }

        # switch homebrew dir by arch
        if runs_on_macARM64; then
            path=(\
                ${BREW_PATH_OPT}/bin(N-/) ${BREW_PATH_OPT}/sbin(N-/) \
                ${BREW_PATH_LOCAL}/bin(N-/) ${BREW_PATH_LOCAL}/sbin(N-/) \
                ${path})

            if brew_exists_at_opt && brew_exists_at_local; then
                # use local brew dir
                function lbr() { ${BREW_PATH_LOCAL}/bin/$@; }
                # launch on rosetta2
                function x86() { arch -x86_64 $@; }
                # launch on arm (native)
                function arm() { arch -arm64 $@; }
                # launch zsh on local brew
                if [[ -e "${BREW_PATH_LOCAL}/bin/zsh" ]]; then
                    function rzsh() { "${BREW_PATH_LOCAL}/bin/zsh"; }
                fi
            fi
        elif runs_on_macX86_64; then
            path=(\
                ${BREW_PATH_LOCAL}/bin(N-/) ${BREW_PATH_LOCAL}/sbin(N-/) \
                ${BREW_PATH_OPT}/bin(N-/) ${BREW_PATH_OPT}/sbin(N-/) \
                ${path})
        fi

        # if macvim available, alias vim to macvim
        if [[ -d '/Applications/MacVim.app' ]]; then
            alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
            alias vi='vim'
        fi

        # simple timer function for tea preparation
        function ktimer() {
            local wait_min=${1:-'5'}
            local wait_sec=${2:-'00'}
            echo "Timer: count for ${wait_min}:${wait_sec}... (start: $(date +%Y/%m/%d_%H:%M:%S))"
            (sleep $(echo "${wait_min}*60+${wait_sec}"|bc) && \
                 echo "Timer: ${wait_min}:${wait_sec} passed (end: $(date +%Y/%m/%d_%H:%M:%S))" && \
                 say --voice=Victoria "time has passed" \
                ) 2> /dev/null
        }
        ;;
esac

# check stack installed and add path
if is_available 'stack'; then
    path=($(stack path --local-bin)(N-/) ${path})
fi

# check rust environment
path=("${HOME}/.cargo/bin"(N-/) ${path})

# configure pyenv
if is_available 'pyenv'; then
    export PIPENV_VENV_IN_PROJECT=true
    eval "$(pyenv init --path)"
fi

# configure node environment
if is_available 'npm' && [[ -d "${HOME}/.npm-global" ]]; then
    export NPM_CONFIG_PREFIX="${HOME}/.npm-global"
    path=("${NPM_CONFIG_PREFIX}/bin"(N-/) ${path})
fi

# set manpager as bat or nvim if available
if is_available 'bat'; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
elif is_available 'nvim'; then
    export MANPAGER="nvim -c 'set ft=man' -"
fi
