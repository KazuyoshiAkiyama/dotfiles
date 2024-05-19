# Editors
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='nvimpager'

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi
if [[ -z "$LANGUAGE" ]]; then
  export LANGUAGE='en_US.UTF-8'
fi
if [[ -z "$TZ" ]]; then
  export TZ='JST-9'
fi

if [ -f /usr/bin/ranger ]; then
  export RANGER_BIN=/usr/bin/ranger
elif [ -f /usr/local/bin/ranger ]; then
  export RANGER_BIN=/usr/local/bin/ranger
else
  export RANGER_BIN="$(which ranger)"
fi

# ---- shell funcs ----
fdrg() {
  suffix="$1"
  keyword="$2"
  fd $suffix | xargs rg $keyword
}

convert_suffix() {
  before_suffix="$1"
  after_suffix="$2"
  fd $before_suffix --exec mv {} {.}$after_suffix \;
}

rgexec() {
  pattern="$1"
  dst_dir="$2"
  func="$3"
  for i in `rg $pattern $dst_dir -l`; do
    $func $i
  done
}

git-search() {
  case "$1" in
    "append" | "A" | "Append" ) FILTER="C";;
    "copy"   | "C" | "Copy"   ) FILTER="C";;
    "delete" | "D" | "Delete" ) FILTER="D";;
    "modify" | "M" | "Modify" ) FILTER="M";;
    "rename" | "R" | "Rename" ) FILTER="R";;
  esac
  SEARCH_DIR=${2}
  [ "$SEARCH_DIR" ] && SEARCH_DIR="--relative=$SEARCH_DIR"
  git log --diff-filter=$FILTER --summary $SEARCH_DIR
}

# PATH

export GOPATH=$HOME/.go
export CARGO_PATH=$HOME/.cargo/bin
export PATH=$HOME/.local/bin:$CARGO_PATH:$GOPATH:$PATH
[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

# Git

export GIT_EDITOR='nvim'

##########################################
# Interactive Shell Only
##########################################

case $- in
  *i* ) ;;
    * ) return;;
esac

# Alias
alias ls='exa'
alias ll='exa -alF'
alias la='exa -a'
alias l='exa -F'
alias tree='exa --tree'
alias cat='bat -p'
alias vim='nvim'
alias v='nvim'
alias ps='procs'
alias pstree='procs --tree'

alias _vim="/usr/bin/vim"
alias _ls="/bin/ls"
alias _cat="/bin/cat"
alias b="cd ./../.."
alias _ps='/bin/ps'

alias tmux="tmux -2"

usage() {
  echo "usage of zsh customization"
  echo ""
  echo "z.lua: fazzy finderの一種"
  echo "  z <検索するパスの要素>"
  echo "  e.g. 検索したいパス /foo/bar"
  echo "       \$ z bar foo"
  echo "       -> /foo/bar"
  echo "shell funcs:"
  echo "fdrg <suffix> <keyboard>: 特定のファイル名のファイルのうちキーワードを持つものを検索"
  echo "convert_suffix <before> <after>: ファイルのsuffixを変更"
  echo "rgexec <pattern> <path> <func>: path配下のpatternのアイテムに対してfuncを実行"
  echo "git-search <pattern> [dir]: git log拡張. dirを指定するとそのdirに関連したlogのみを検索"
  echo "  git-search [A|Append|append] : アイテムがappendされたlogを検索"
  echo "  git-search [C|Copy|copy]     : アイテムがcopy  されたlogを検索"
  echo "  git-search [D|Delete|delete] : アイテムがdeleteされたlogを検索"
  echo "  git-search [M|Modify|modify] : アイテムがmodifyされたlogを検索"
  echo "  git-search [R|Rename|rename] : アイテムがrenameされたlogを検索"
}
