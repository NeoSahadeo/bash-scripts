#!/usr/bin/env bash

# vars:
target_name="main"
libs=()
src_name="src"
build_name=".build"
compiler="clang"
cflags="-Wall -Wextra -Werror"
cppflags="-MMD -MP -I include"

# opts:
i_git=true
i_clangd=true
i_readme=true

#CONSTANTS
CURSOR_UP="\e[A"
RESET="\e[0m"
CLEAR_LINE="\e[2K"

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


produce_makefile(){
	echo "Writing Makefile"
echo -e "NAME        := $target_name

LIBS				:= $libs

SRC_DIR			:= $src_name
SRCS				:= \$(shell find \$(SRC_DIR) -name '*.c')

BUILD_DIR   := $build_name
OBJS        := \$(SRCS:\$(SRC_DIR)/%.c=\$(BUILD_DIR)/%.o)
DEPS        := \$(OBJS:.o=.d)

CC          := $compiler
CFLAGS      := $cflags
CPPFLAGS    := $cppflags
LDLIBS      := \$(addprefix -l,\$(LIBS))

RM          := rm -rf
MAKEFLAGS   += --no-print-directory
DIR_DUP     = mkdir -p \$(@D)

all: \$(NAME)

dev: \$(NAME)
	./$target_name

\$(NAME): \$(OBJS)
	\$(CC) \$(OBJS) \$(LDLIBS) -o \$(NAME)
	\$(info CREATED \$(NAME))

\$(BUILD_DIR)/%.o: \$(SRC_DIR)/%.c
	\$(DIR_DUP)
	\$(CC) \$(CFLAGS) \$(CPPFLAGS) -c -o \$@ \$<
	\$(info CREATED \$@)

-include \$(DEPS)

clean:
	\$(RM) \$(OBJS) \$(DEPS)
	\$(info CLEANED)

fclean: clean
	\$(RM) \$(NAME)

re:
	\$(MAKE) fclean
	\$(MAKE) all

.PHONY: clean fclean re dev

.SILENT:" > Makefile
}

produce_clangd(){
	echo "Writing .clangd"
	echo -e "CompileFlags:
	Add: [
	]" > .clangd
}

produce_readme(){
	echo "Writing README.md"
	echo -e "# Title

Desc

## Installation

## Usage

## Contributing

## License" > README.md
}

produce_main(){
	echo "Writing main.c"
	echo -e "int main(){
		//
		return 0;
	}"
}

produce_gitignore(){
	echo -e ".build" > '.gitignore'
}

initialise_git(){
	echo "Initialising Git"
	git init &> /dev/null
	git branch -M main &> /dev/null
}

initialise_dir(){
	echo "Setting up directory"
	mkdir $src_name
	produce_main
}

replace_default(){
	local v=""
	local varname=${!2}
	printf "$BOLD_GREY$1 %s$RESET" "$varname"
	printf "\r$1 "
	for ((;;)); do
		local input=""
		read -r -N1 input
		printf "\r$1 %*s" ${#varname}
			case $input in
				$'\^?'| $'\x7f'| $'\b')
					printf "$CLEAR_LINE"
					if [[ -z "$v" ]]; then # Handles min change
						v="$varname"
					fi
					v="${v%?}"
					;;
				$'\n')
					if [[ -z "$v" ]]; then # Handles default option
						v=$varname
					fi
					printf "$CURSOR_UP\r$1 $BOLD_GREEN%s$RESET\n$CLEAR_LINE" "$v"
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
	read -r -N1 -p "$1 [Y/n] " o
	o=${o,}
	printf -v "$2" '%s' "$o"
	printf "\r" # Flush buf
}

get_user_config(){
	echo "Configuring Makefile"
	replace_default "Target name:" target_name
	replace_default "Libraries:" libs
	replace_default "Src dir:" src_name
	replace_default "Build dir:" build_name
	replace_default "Compiler:" compiler
	replace_default "CFLAGS:" cflags
	replace_default "CPPFLAGS:" cppflags

	get_option "Initialise Git" i_git
	get_option "Create .clangd" i_clangd
	get_option "Create README.md" i_readme
}

echo "Simple C Project Setup:
======================"

get_user_config


$i_git && initialise_git
$i_clangd && produce_clangd
$i_readme && produce_readme
produce_makefile
