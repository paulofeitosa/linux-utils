#!/usr/bin/env bash
#
# Backup a remote location to local disk using `rsync`.
#
# Signals:
#   0   Success
#   1   Usage error
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
  printf "\n\r%s\n" "Usage: $0 [options] <login@server:source> <destination>"
  printf "\r%s\n\n" "Options:"
  printf "\r\t%s\t%s\n" "-h" "show this message"
  printf "\r\t%s\t%s\n" "-p" "ssh server port (default: 22)"
  printf "\r\t%s\t%s\n\n" "-i" "identity file (optional)"
}

main() {
  if [ $# -lt 2 ]; then
    usage
    return 1
  fi

  local port=22
  local identity_file
  while getopts "hp:i:" OPT; do
    case "${OPT}" in
      h)
        usage
        return 0
        ;;
      p)
        port="${OPTARG}"
        ;;
      i)
        identity_file="${OPTARG}"
        ;;
    esac
  done
  shift $((OPTIND-1))

  if [ ! -w "$2" ]; then
    printf "\r%s\n" "$2 not writable"
    return 3
  fi

  if [ ! -d "$2" ]; then
    printf "\r%s\n" "$2 not a directory"
    return 4
  fi

  local cmd_date=/usr/bin/date
  local cmd_rsync=/usr/bin/rsync
  local cmd_ssh=/usr/bin/ssh

  printf "\r[%s] - %s\n" "$(${cmd_date})" "Starting backup"
  local args
  if [ ! -z "${identity_file}" ]; then
    args="-p ${port} -i ${identity_file}"
  else
    args="-p ${port}"
  fi
  "${cmd_rsync}" -a --delete -e "${cmd_ssh} ${args}" "$1" "$2"
  printf "\r[%s] - %s\n" "$(${cmd_date})" "Backup finished"

  return
}

main "$@"
exit
