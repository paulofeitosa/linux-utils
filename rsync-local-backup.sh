#!/usr/bin/env bash
#
# Backup a local location using `rsync`.
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
  printf "\r\t%s\t%s\n" "-h" "show this message"
  printf "\r\t%s\t%s\n\n" "-i" "incremental backup"
}

main() {
  if [ $# -lt 2 ]; then
    usage
    return 1
  fi

  local incremental=1
  while getopts "hi" OPT; do
    case "${OPT}" in
      h)
        usage
        return 0
        ;;
      i)
        incremental=0
        ;;
    esac
  done
  shift $((OPTIND-1))

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
  local cmd_rm=/usr/bin/rm
  local cmd_rsync=/usr/bin/rsync

  printf "\r[%s] - %s\n" "$(${cmd_date})" "Starting backup"
  if [ "${incremental}" -eq 0 ]; then
    local incremental_dir
    incremental_dir="$2/incr/$(${cmd_date} +%A)"
    if [ -e "${incremental_dir}" ]; then
      "${cmd_rm}" -fr "${incremental_dir}"
    fi
    "${cmd_rsync}" -a --delete --inplace --backup \
      --backup-dir="${incremental_dir}" "$1" "$2"
  else
    "${cmd_rsync}" -a --delete "$1" "$2"
  fi
  printf "\r[%s] - %s\n" "$(${cmd_date})" "Backup finished"

  return
}

main "$@"
exit
