#!/usr/bin/env bash

THIS_DIR=$(dirname $(readlink -f $0))

source ${THIS_DIR}/common-util.sh

DISTRO_DIR="${THIS_DIR}/distro"
CONFIG_DIR="${THIS_DIR}/config"

usage() {
  colorf "$CIAN" "usage: run.sh <distro> [target]\n"
  echo ""
  echo "Install packages/configs etc"
  echo ""
  colorf "$YELLOW" "positional arguments:\n"
  echo ""
  colorf "$YELLOW" "optional arguments:\n"
  echo ""
  colorf "$CIAN" "  -d, --distro: specify a distro\n"
  echo "    Supported distro:"
  echo "      ubuntu22.04"
  echo ""
  colorf "$CIAN" "  -t, --target: specify a target to run\n"
  echo "    If specifying multiple targets, please separate each target with \",\" like the following."
  echo "      e.g. ) -t apt,devbox"
  echo ""
  echo "    Supported targets:"
  echo "      all [default]"
  echo "      apt"
  echo "      devbox"
  echo "      cargo"
  echo "      config"
  echo "      nvm"

  exit 2
}

SEL_OPT_DISTRO=false
OPT_DISTRO=""
DISTRO=""

SEL_OPT_TARGET=false
OPT_TARGET=""

while (( $# > 0 )); do
OPT="$1"
case "$OPT" in
  "-h" | "--help" )
    usage
    ;;
  "-t" | "--target" )
    $SEL_OPT_TARGET && \
      err_exit "-t, --target cannot be multiply specified"
    shift 1
    OPT_TARGET="$1"
    [ "$OPT_TARGET" ] || \
      err_exit "-t, --target requires one argument"
    SEL_OPT_TARGET=true
    ;;
  "-d" | "--distro" )
    $SEL_OPT_DISTRO && \
      err_exit "-d, --distro cannot be multiply specified"
    shift 1
    OPT_DISTRO="$1"
    [ "$OPT_DISTRO" ] || \
      err_exit "-d, --distro requires one argument"
    SEL_OPT_DISTRO=true
    ;;
  * )
    err "Found invalid args, $OPT"
    usage
    ;;
esac
shift
done

case "${OPT_DISTRO}" in
  "" | "ubuntu22.04" )
    # OK
    DISTRO="ubuntu22.04"
    ;;
  * )
    err "Unknown distro ${OPT_DISTRO} specified."
    usage 1
esac

if $SEL_OPT_TARGET; then
  RUN_TARGET=""
  for target in `echo $OPT_TARGET | sed "s|,| |g"`; do
    case "${target}" in
      "all" )
        RUN_TARGET="apt devbox cargo config nvm"
        break
        ;;
      "apt" | "devbox" | "cargo" | "config" | "nvm" )
        RUN_TARGET="${target}"
        ;;
      * )
        err "Unknown target ${target} specified."
        usage 1
    esac
  done
else
  # all
  RUN_TARGET="apt devbox cargo config nvm"
fi

. ${DISTRO_DIR}/default.sh
[ -f ${DISTRO_DIR}/${DISTRO}.sh ] || {
  err_exit "Not Found distro script ${DISTRO}.sh"
  exit 1
}
. ${DISTRO_DIR}/${DISTRO}.sh

for target in $RUN_TARGET; do
  run_target_${target} ${CONFIG_DIR}
done
