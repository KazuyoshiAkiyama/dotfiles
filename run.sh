#!/usr/bin/env bash

THIS_DIR=$(dirname $(readlink -f $0))

DISTRO_DIR="${THIS_DIR}/distro"
CONFIG_DIR="${THIS_DIR}/config"

usage() {
  echo "usage: run.sh <distro> [target]"
  echo ""
  echo "Install packages/configs etc"
  echo ""
  echo "positional arguments:"
  echo ""
  echo "  distro: specify a distro"
  echo "    ubuntu22.04"
  echo ""
  echo "optional arguments:"
  echo ""
  echo "  target: specify a target to run"
  echo "    all [default]"
  echo "    apt"
  echo "    devbox"
  echo "    cargo"
  echo "    config"
  echo "    nvm"
  exit $1
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
    echo "[ERROR] Unknown distro ${OPT_DISTRO} specified."
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
    echo "[ERROR] Unknown target ${OPT_TARGET} specified."
    usage 1
esac

. ${DISTRO_DIR}/default.sh
[ -f ${DISTRO_DIR}/${DISTRO}.sh ] || {
  echo "[ERROR] Not Found distro script ${DISTRO}.sh"
  exit 1
}
. ${DISTRO_DIR}/${DISTRO}.sh

RUN_TARGET="${TARGET}"
[ "${TARGET}" = "all" ] && RUN_TARGET="apt devbox cargo config nvm"

for target in $RUN_TARGET; do
  run_target_${target} ${CONFIG_DIR}
done
