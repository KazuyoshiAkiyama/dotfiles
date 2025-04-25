#!/usr/bin/env bash

if [ "${DEBUG_SCRIPT}" = "true" ]; then
  QUIET=false
else
  QUIET=true
fi

BLACK='\e[30m'
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CIAN='\e[36m'
WHITE='\e[37m'
BOLD='\e[1m'
END='\e[m'

colorize() {
  COLOR=$1
  echo "${COLOR}$2${END}"
}

colorf() {
  printf "$(colorize "$1" "$2")"
}

colorf_dbg() {
  ${QUIET} && return 0
  colorf "$1" "$2"
}

dbg() {
  ${QUIET} && return 0
  echo "$1"
}

warn() {
  colorf "$YELLOW" "[WARNING] $1\n" 1>&2
  return 0
}

err() {
  colorf "$RED" "[ERROR] $1\n" 1>&2
  return 1
}

success() {
  colorf "$GREEN" "[DONE] $1\n" 1>&2
  return 0
}

info() {
  colorf "$CIAN" "[INFO] $1\n" 1>&2
  return 0
}

err_exit() {
  ERROR_MSG="$1"
  err "$ERROR_MSG"
  exit 1
}

required_file() {
  [ -f ${1} ] || err_exit "Not Found ${1}"
}

required_dir() {
  [ -d ${1} ] || err_exit "Not Found ${1}"
}
