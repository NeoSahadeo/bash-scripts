#!/usr/bin/env bash

# Description:
# Neo's bash API provides some useful script functions, colors, and tooling
# that makes it easier to develop bash scripts

#############
# CONSTANTS #
#############
CURSOR_UP="\e[A"
CURSOR_DOWN="\e[1B"
RESET="\e[0m"
CLEAR_LINE="\e[2K"

##########
# COLORS #
##########
REG_BLACK="\e[0;30m"
REG_RED="\e[0;31m"
REG_GREEN="\e[0;32m"
REG_YELLOW="\e[0;33m"
REG_BLUE="\e[0;34m"
REG_PURPLE="\e[0;35m"
REG_CYAN="\e[0;36m"
REG_WHITE="\e[0;37m"

BOLD_BLACK="\e[1;30m"
BOLD_RED="\e[1;31m"
BOLD_GREEN="\e[1;32m"
BOLD_YELLOW="\e[1;33m"
BOLD_BLUE="\e[1;34m"
BOLD_PURPLE="\e[1;35m"
BOLD_CYAN="\e[1;36m"
BOLD_WHITE="\e[1;37m"
BOLD_GREY="\e[1;90m"

UNDERLINE_BLACK="\e[4;30m"
UNDERLINE_RED="\e[4;31m"
UNDERLINE_GREEN="\e[4;32m"
UNDERLINE_YELLOW="\e[4;33m"
UNDERLINE_BLUE="\e[4;34m"
UNDERLINE_PURPLE="\e[4;35m"
UNDERLINE_CYAN="\e[4;36m"
UNDERLINE_WHITE="\e[4;37m"

BACKGROUND_BLACK="\e[40m"
BACKGROUND_RED="\e[41m"
BACKGROUND_GREEN="\e[42m"
BACKGROUND_YELLOW="\e[43m"
BACKGROUND_BLUE="\e[44m"
BACKGROUND_PURPLE="\e[45m"
BACKGROUND_CYAN="\e[46m"
BACKGROUND_WHITE="\e[47m"

####################
# Functions & MISC #
####################

replace_default(){
	local v=""
	local varname=${!2}

	printf "$BOLD_GREY$1 %s$RESET" "$varname"
	printf "\r$1 "

	for ((;;)); do
		local input=""
		read -s -N1 input
		printf "\r$1 %*s" ${#varname}
			case $input in
				$'\^?'| $'\x7f'| $'\b')
					printf "$CLEAR_LINE"
					if [[ -z "$v" ]]; then # Reset value if empty
						v="$varname"
					else
						v="${v%?}"
						if [[ -z "$v" ]]; then # ReRender base if empty after return
							printf "\r"
							printf "$BOLD_GREY$1 %s$RESET" "$varname"
							printf "\r$1 "
						fi
					fi
					;;
				$'\n')
					if [[ -z "$v" ]]; then # Handles default option
						v=$varname
					fi
					printf "\r$1 $BOLD_GREEN%s$RESET\n$CLEAR_LINE" "$v"
					break
					;;
				*)
					v="$v$input"
			esac
		printf "\r$1 $BOLD_GREEN%s$RESET" "$v"
	done
	printf -v "$2" '%s' "$v"
}

get_option(){
	local yes="y"
	local no="n"
	local option
	local variable=${!2}

	if $variable; then
		yes="Y"
	else
		no="N"
	fi

	for ((;;)); do
		read -N1 -p "$1 [$yes/$no] " o
		o=${o,,}
		if [[ $o == $'\n' ]]; then
			printf "$CURSOR_UP\n"
			option=$variable
			break;
		elif [[ $o == "y" ]]; then
			printf "\n"
			option=true
			break
		elif [[ $o == "n" ]]; then
			printf "\n"
			option=false
			break
		fi
	done
	printf -v "$2" '%s' "$option"
}
