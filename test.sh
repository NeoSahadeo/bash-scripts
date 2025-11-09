#!/usr/bin/env bash

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
source <(curl -s "file:///$root/api.sh")

echo "Hello world"
