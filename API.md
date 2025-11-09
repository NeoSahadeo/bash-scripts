
replace_default(){
get_option(){
	read -r -N1 -p "$1 [Y/n] " o
	o=${o,}
	printf -v "$2" '%s' "$o"
	printf "\r" # Flush buf
}
