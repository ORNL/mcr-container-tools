#!/bin/bash

# This script discovers which SO dependencies are lacking for SO libraries in a given directory and its subdirectories 

set -e


# Parse arguments
SEARCH_PATH=
LD_SO=
HELP_MSG="
Usage:
	-p Path to directory to search for SO files
	-l Exclude libraries in the ldconfig cache
	-h Prints this help message
"
while getopts "p:lh" opt; do
	case $opt in
	p)
	SEARCH_PATH="${OPTARG}"
	;;
	l)
	LD_SO=`ldconfig -p | awk '{print $1}' | sort | uniq`
	;;
	h)
	echo ${HELP_MSG}
	exit 0
	;;
	esac
done

if [ ! -d "$SEARCH_PATH" ]; then
	echo "Directory doesn't exist:  $SEARCH_PATH" >&2
	exit 1
fi



FOUND_SO=`find -L "$SEARCH_PATH" -type f -exec file -L {} \; | awk -F':' '/ELF/ {print $1}'`
PROVIDED_SO=`echo "$FOUND_SO" | xargs -I {} basename {} | sort | uniq`
SO_DEPS=`echo "$FOUND_SO" | xargs readelf -d | sed -n 's/.*(NEEDED)\ *Shared\ library:\ \[\(.*\)\].*/\1/p' | sort | uniq`

MISSING_SO=`comm -1 -3 <(echo -e "$PROVIDED_SO") <(echo -e "$SO_DEPS")`
if [ ! -z "$LD_SO" ]; then
	MISSING_SO=`comm -1 -3 <(echo -e "$LD_SO") <(echo -e "$MISSING_SO")`
fi


echo "$MISSING_SO"