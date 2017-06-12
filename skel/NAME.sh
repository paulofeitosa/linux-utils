#!/usr/bin/env sh
#
# SHORT DESCRIPTION.
#
# by Paulo Feitosa <coding.paulo.feitosa@gmail.com>
# v1.0.0 DATE (YYYY-MM-DD)
#

. lib/stdout.sh

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

usage() {
  printf "\r%s\n" "Usage: $0"
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
}

main "$@"
exit
