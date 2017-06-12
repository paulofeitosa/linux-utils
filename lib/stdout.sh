#!/usr/bin/env sh
#
# Library of output-related functions.
#
# by Paulo Feitosa <coding.paulo.feitosa@gmail.com>
# v1.0.0 2017-06-12
#

# Colors (http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html)
readonly COLOR_BLACK="\033[0;30m"
readonly COLOR_BLUE="\033[0;34m"
readonly COLOR_BROWN="\033[0;33m"
readonly COLOR_CYAN="\033[0;36m"
readonly COLOR_DARK_GRAY="\033[1;30m"
readonly COLOR_RED="\033[0;31m"
readonly COLOR_LIGHT_BLUE="\033[1;34m"
readonly COLOR_LIGHT_CYAN="\033[1;36m"
readonly COLOR_LIGHT_GRAY="\033[0;37m"
readonly COLOR_LIGHT_GREEN="\033[1;32m"
readonly COLOR_LIGHT_PURPLE="\033[1;35m"
readonly COLOR_LIGHT_RED="\033[1;31m"
readonly COLOR_GREEN="\033[0;32m"
readonly COLOR_PURPLE="\033[0;35m"
readonly COLOR_WHITE="\033[1;37m"
readonly COLOR_YELLOW="\033[1;33m"
readonly NO_COLOR="\033[0m"

# Prints the timestamp then a message.
#
# Parameters:
#   $1  message to print
#   $2  color's ANSI code (optional)
#
msg() {
  printf "\r[%s]\t${2-${NO_COLOR}}%s${NO_COLOR}\n" "$(/usr/bin/date)" "$1"
}

# Throws an error.
#
# Parameters:
#   $1  message to print
#   $2  signal to return
#
throw() {
  msg "$1" "${COLOR_RED}" >&2; exit "$2"
}

# Avoid function override
readonly -f msg
readonly -f throw
