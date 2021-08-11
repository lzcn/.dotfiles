COLOR_BLUE="\033[1;34m"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_GREEN="\033[1;32m"
COLOR_NONE="\033[0m"
COLOR_PURPLE="\033[0;35m"
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"

title() {
    echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}====================${COLOR_NONE}\n"
}

question() {
    echo -e -n "${COLOR_YELLOW} [?] $1 (y/n): ${COLOR_NONE}"
    read -n 1 -r REPLY
    echo
}

warning() {
    echo -e "${COLOR_YELLOW} [!] $1${COLOR_NONE}"
}

info() {
    echo -e "${COLOR_BLUE} [*] $1${COLOR_NONE}"
}

fail() {
    echo -e "${COLOR_RED} [x] $1${COLOR_NONE}"
}

success() {
    echo -e "${COLOR_GREEN} [+] $1${COLOR_NONE}"
}

symlink() {
    target_file=$1
    source_file=$2
    if [ -e "$target_file" ]; then
        if [ "$(readlink "$target_file")" != "$source_file" ]; then
            question "'$target_file' already exists, do you want to overwrite it?"
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                rm -rf "$target_file"
                info "remove $target_file"
                ln -fs $source_file $target_file
                info "$target_file -> $source_file"
            else
                fail "$target_file -> $source_file"
            fi
        else
            info "Found $target_file -> $source_file"
        fi
    else
        ln -fs $source_file $target_file
        success "Created $target_file -> $source_file"
    fi
}

is_osx() {
    [ $(uname) == "Darwin" ]
}

is_linux() {
    [ $(uname) == "Linux" ]
}

command_exists() {
    local command="$1"
    command -v "$command" &>/dev/null
}
