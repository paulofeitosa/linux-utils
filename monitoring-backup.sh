#!/usr/bin/env bash
#
# Backup a location using `tar` and `gzip`.
#
# Signals:
#   0   Success
#   1   Usage error
#   2   Source unreadable
#   3   Destination unwritable
#   4   Destination not a directory
#
# by Paulo Feitosa <coding.paulo.feitosa@gmail.com>
# v1.0.0 2017-06-07
#

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

usage() {
  printf "\n\r%s\n" "Usage: $0 [options] <source> <destination>"
  printf "\r%s\n\n" "Options:"
  printf "\r\t%s\t%s\n\n" "-h" "show this message"
}

main() {
  if [ $# -lt 2 ]; then
    usage
    return 1
  fi

  while getopts "h" OPT; do
    case "${OPT}" in
      h)
        usage
        return 0
        ;;
    esac
  done

  if [ ! -r "$1" ]; then
    printf "\r%s\n" "$1 not readable"
    return 2
  fi

  if [ ! -w "$2" ]; then
    printf "\r%s\n" "$2 not writable"
    return 3
  fi

  if [ ! -d "$2" ]; then
    printf "\r%s\n" "$2 not a directory"
    return 4
  fi

  local cmd_date=/usr/bin/date
  local cmd_du=/usr/bin/du
  local cmd_grep=/usr/bin/grep
  local cmd_gzip=/usr/bin/gzip
  local cmd_pv=/usr/bin/pv
  local cmd_sha256sum=/usr/bin/sha256sum
  local cmd_tar=/usr/bin/tar

  local no_heading="${1/#\//}"
  local no_tailing="${no_heading/%\//}"
  local name="${no_tailing//\//-}"
  local file="${2/%\//}/${name//\//-}.tar.gz"
  local size=0

  printf "\r[%s] - %s\n" "$(${cmd_date})" "Calculating $1 size"
  size="$(${cmd_du} -sk $1 | ${cmd_grep} -Eio '^[0-9]+')"
  printf "\r[%s] - %s\n" "$(${cmd_date})" "Creating ${file}"
  "${cmd_tar}" -cf - "$1" | "${cmd_pv}" -betp -s "${size}k" | \
    "${cmd_gzip}" -c > "${file}"
  printf "\r[%s] - %s\n" "$(${cmd_date})" "Creating ${file}.sha256sum"
  "${cmd_sha256sum}" -b "${file}" > "${file}.sha256sum"
  printf "\r[%s] - %s\n" "$(${cmd_date})" "Backup finished"

  return
}

main "$@"
exit
