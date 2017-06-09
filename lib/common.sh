#!/usr/bin/env bash
#
# Library of common functions.
#
# by Paulo Feitosa <coding.paulo.feitosa@gmail.com>
# v1.0.0 2017-06-09
#

# `date` command path.
export CMD_DATE=/usr/bin/date

# Prints the timestamp then a message.
#
# Parameters:
#   $1  message to print
#   $2  color's ANSI code (optional)
#
# Returns:
#   Nothing
#
common::print() {
  local color
  local no_color="\033[0m"

  if [ -n "$2" ]; then
    color="$2"
  else
    color="${no_color}"
  fi

  printf "\r[%s]\t${color}%s${no_color}\n" "$(${CMD_DATE})" "$1"
}

# Prints a warning message.
#
# Parameters:
#   $1  message to print
#
# Returns:
#   Nothing
#
common::warn() {
  common::print "$1" "\033[0;33m"
}

# Prints an error message.
#
# Parameters:
#   $1  message to print
#
# Returns:
#   Nothing
#
common::err() {
  common::print "$1" "\033[0;31m" >&2
}

# Validates path for read operations.
#
# Parameters:
#   $1  path
#
# Returns:
#   0   path ok
#   1   path not readable
#
common::validate_read() {
  [ -r "$1" ] || return 1
}

# Validates path for write operations.
#
# Parameters:
#   $1  path
#
# Returns:
#   0   path ok
#   1   path not writable
#
common::validate_write() {
  [ -w "$1" ] || return 1
}
