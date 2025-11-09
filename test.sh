#!/usr/bin/env bash

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source <(curl -s "file:///$root/src/api.sh")
# source <(curl -s "https://raw.githubusercontent.com/NeoSahadeo/bash-scripts/refs/heads/main/src/cinit.sh")
source <(curl -s "file:///$root/src/cinit.sh")
#
# target_name="Neo"
# echo ""
# replace_default "Target name:" target_name
# echo $target_name
#
# p=true
# get_option "Create README.md" p
# get_option "Create Eepy.md" p
# get_option "Create ME.md" p
