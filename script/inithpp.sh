#!/bin/bash
#
# Create the hpp file

set -u

readonly SCRIPT_NAME="$(basename $0)"               # Name of this script file
readonly SCRIPT_DIR="$(cd $(dirname $0) && pwd)"    # Absolute path of a the directory of this script file
readonly SCRIPT_FILE="${SCRIPT_DIR}/${SCRIPT_NAME}" # Absolute path of this script file
readonly HEADER="$(basename $0): "
readonly SPACER="${HEADER//?/ }"

function error_message() {
	local orig_ifs=$IFS
	IFS=$'\n'

	local line
	read line
	echo "${HEADER}${line}" >&2
	while read line; do 
		echo "${SPACER}${line}" >&2
	done

	IFS=${orig_ifs}
}

if [ $# -lt 1 ]; then
	echo "Missing argument." | error_message
	exit 1
fi

readonly INCLUDE_DIR="$(cd ${SCRIPT_DIR}/../include && pwd)"
readonly HPP_FILENAME="${1%.hpp}"'.hpp'
readonly HPPFILE="${INCLUDE_DIR}/${HPP_FILENAME}"
readonly MACRO=`echo ${HPP_FILENAME/./_} | tr [a-z] [A-Z]`

if [ -e "${HPPFILE}" ]; then
	echo "${HPPFILE} already exists." | error_message
	exit 1
fi

echo "#ifndef ${MACRO}" >> "${HPPFILE}"
echo "#define ${MACRO}" >> "${HPPFILE}"
echo >> "${HPPFILE}"
echo "#include <bits/stdc++.h>" >> "${HPPFILE}"
echo >> "${HPPFILE}"
echo >> "${HPPFILE}"
echo >> "${HPPFILE}"
echo "#endif /* ${MACRO} */" >> "${HPPFILE}"
