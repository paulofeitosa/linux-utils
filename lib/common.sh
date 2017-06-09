#!/usr/bin/env bash
#
# Library of common functions.
#
# by Paulo Feitosa <coding.paulo.feitosa@gmail.com>
# v1.0.0 2017-06-09
#

# `date` command path.
export CMD_DATE=/usr/bin/date

# Prints, to STDOUT, the timestamp then a message.
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
