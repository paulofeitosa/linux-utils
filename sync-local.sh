#!/usr/bin/env bash
#
# Uses `rsync` incremental backup to sync a local dir.
#
# by Paulo Feitosa <coding.paulo.feitosa@gmail.com>
# v1.0.0 2017-06-13
#

readonly SCRIPT_NAME="$(readlink -f ${BASH_SOURCE[0]})"
readonly SCRIPT_PATH="$(dirname ${SCRIPT_NAME})"
# shellcheck source=lib/stdout.sh
. "${SCRIPT_PATH}/lib/stdout.sh"

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

usage() {
  printf "\r%s\n" "Usage: $0 -h"
  printf "\r%s\n" "   or: $0 SRC DST"
  printf "\r%s\n" "Syncs SRC dir to DST. Files in DST that doesn't belong to"
  printf "\r%s\n" "SRC dir are deleted."
}

main() {
  while getopts "h" OPT; do
    case "${OPT}" in
      h|?)
        usage
        return
        ;;
    esac
  done
  shift $((OPTIND-1))

  [ "$#" -ge 2 ] || throw "Invalid number of parameters" 1
  [ -r "$1" ] || throw "$1 not readable" 2
  [ -d "$1" ] || throw "$1 not a dir" 3
  [ -w "$2" ] || throw "$2 not writable" 4
  [ -d "$2" ] || throw "$2 not a dir" 5
  [ ! "$1" -ef "$2" ] || throw "SRC and DST are the same" 6

  msg "Starting to sync $1 to $2..."
  /usr/bin/rsync -a --delete --partial --backup \
    --backup-dir="$(dirname $2)/.history/$(/usr/bin/date +%A)" "$1" "$2"
  msg "Sync complete" "${COLOR_BLUE}"

  return
}

main "$@"
exit
