#!/usr/bin/env bash

# MIT 2026 Neo Sahadeo
# Description:
# 	(Un)loads a default sink and source

SINK_NAME="Default-Sink"
SOURCE_NAME="Virtual-Source"

load(){
	pactl load-module module-null-sink sink_name=$SINK_NAME
	pactl load-module module-pipe-source source_name=$SOURCE_NAME
}

unload(){
	pactl unload-module module-null-sink
	pactl unload-module module-pipe-source
}

if [[ $# > 0 ]]; then
	case "$#" in
		1)
			if [[ $1 == "load" ]]; then
				load
			elif [[ $1 == "reload" ]]; then
				unload
				load
			elif [[ $1 == "unload" ]]; then
				unload
			fi
	esac
fi
