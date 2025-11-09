#!/usr/bin/env bash

source <(curl -s "https://raw.githubusercontent.com/NeoSahadeo/bash-scripts/refs/heads/main/src/api.sh")

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
	}" > "$src_name/main.c"
}

produce_gitignore(){
	echo -e ".build" > '.gitignore'
}

initialise_git(){
	echo "Initialising Git"
	git init &> /dev/null
	git branch -M main &> /dev/null
	produce_gitignore
}

initialise_dir(){
	echo "Setting up directory"
	mkdir $src_name
	produce_main
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
initialise_dir
