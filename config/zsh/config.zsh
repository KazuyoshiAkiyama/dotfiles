# shell options
# 同時に起動しているzshの間でhistoryを共有する
setopt share_history
# 同じコマンドをhistoryに残さない
setopt hist_ignore_all_dups
# historyに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
# 高機能なワイルドカード展開を使用する
setopt extended_glob
# cd無しでもディレクトリ移動
setopt auto_cd
# コマンドのスペルミスを指摘
setopt correct
# historyの重複を記録しない
setopt hist_ignore_dups
# historyを編集可能
setopt hist_verify
# 補完時にhistoryを自動的に展開
setopt hist_expand
# historyをインクリメンタルに保存
setopt inc_append_history
# ビープ音無効
setopt nobeep
# cd時に自動でpush
setopt autopushd
# 同じディレクトリをpushしない
setopt pushd_ignore_dups
# TABで保管候補切り替え
setopt auto_menu
# --prefix=/usr などの=以降も補完
setopt magic_equal_subst
# カッコの対応などを自動で保管
setopt auto_param_keys
# ディレクトリ名補完で末尾の/を自動的に補完して次の補完に備える
setopt auto_param_slash
# pushd, popdの出力を無効化
setopt pushd_silent
# 引数なしのpushdをpushd $HOMEとして扱う
setopt pushd_to_home

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
