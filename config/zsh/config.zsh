# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs
path=(
  /usr/local/{bin,sbin}
  ${DEVBOX_PACKAGES_DIR}/{bin,sbin}
  $path
)

# Less
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

##########################################
# Interactive Shell Only
##########################################

case $- in
  *i* ) ;;
    * ) return;;
esac

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPS='--height 30% -border'

zcompile-all() {
  # Compile the completion dump to increase startup speed.
  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  zcompile "$zcompdump"

  # Compile .zshrc
  zcompile ${ZDOTDIR:-$HOME}/.zshrc
}
