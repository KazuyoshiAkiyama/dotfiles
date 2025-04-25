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
  colorf "$CIAN" "  distro: specify a distro\n"
  echo "    ubuntu22.04"
  echo ""
  colorf "$YELLOW" "optional arguments:\n"
  echo ""
  colorf "$CIAN" "  target: specify a target to run\n"
  echo "    all [default]"
  echo "    apt"
  echo "    devbox"
  echo "    cargo"
  echo "    config"
  echo "    nvm"
  exit 2
}

# TODO: Improve argument parse
OPT_DISTRO="${1}"
DISTRO=""

OPT_TARGET="${2}"
TARGET="all"

case "${OPT_DISTRO}" in
  "" | "ubuntu22.04" )
    # OK
    DISTRO="ubuntu22.04"
    ;;
  "-h" | "--help" | "help" )
    usage 2
    ;;
  * )
    err "Unknown distro ${OPT_DISTRO} specified."
    usage 1
esac

case "${OPT_TARGET}" in
  "" | "all" )
    # OK, Skip
    ;;
  "apt" | "devbox" | "cargo" | "config" | "nvm" )
    TARGET="${OPT_TARGET}"
    ;;
  "-h" | "--help" | "help" )
    usage 2
    ;;
  * )
    err "Unknown target ${OPT_TARGET} specified."
    usage 1
esac

. ${DISTRO_DIR}/default.sh
[ -f ${DISTRO_DIR}/${DISTRO}.sh ] || {
  err_exit "Not Found distro script ${DISTRO}.sh"
  exit 1
}
. ${DISTRO_DIR}/${DISTRO}.sh

RUN_TARGET="${TARGET}"
[ "${TARGET}" = "all" ] && RUN_TARGET="apt devbox cargo config nvm"

for target in $RUN_TARGET; do
  run_target_${target} ${CONFIG_DIR}
done
