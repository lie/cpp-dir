#!/bin/bash

# class.sh

function usage() {
cat << _EOT_
Overview:
	C++ class code generator focusing on accessor

Usage:
	$0 [options] <inputs>

Option:
	-c <file> generate prorotype declaration of accessor from cpp code
	-h <file> generate declaration of accessor from declaration of private variables in hpp code
	-o <file> Write generated code to <file>
	          (The default output destination is standard output)

_EOT_
exit 1
}

function getenv() {
	if [ -e /Applications ]; then
		echo "mac"
	elif [ -e /cygdrive ]; then
		echo "cygwin"
	else
		echo "other"
	fi
}

# generate decraretion of accessor(getter & setter)
function gen-dec-of-accessor() {
	if [ $1 == "" ]; then
		exit 1;
	fi

	cat $1 | while read line
	do
		if [ ${#line} -eq 0 ]; then # 空行はスキップ（この処理不要？）
			continue;
		fi

		TMPCLASS=`echo "$line" | ${SED} -rn 's/^\s*class\s+(\S+)\s*\{\s*$/\1/p'` # 本当はもう少し真面目に書くべき

		if [ "$TMPCLASS" != "" ]; then 
			CLASS=$TMPCLASS
		fi

		TYPE=`echo "$line" | ${SED} -rn 's/^\s*(\S.*\S)\s+(\S+)\s*;\s*$/\1/p'`
		NAME=`echo "$line" | ${SED} -rn 's/^\s*(\S.*\S)\s+(\S+)\s*;\s*$/\2/p'`
		PROPERED=`echo "$NAME" | awk '{print toupper(substr($1,1,1))substr($1,2)}'` # bash 4.0 からは{$NAME^}でいける

		if [ "$TYPE" == "" ] || [ "$NAME" == "" ]; then
			continue;
		fi

		echo -e "\t""$TYPE" get"$PROPERED"\(\)\;
		echo -e "\t"void set"$PROPERED"\("$TYPE" new"$PROPERED"\)\;
	done
}

# generate accessor (getter & setter) from decraretion of private variable
function gen-accessor() {
	if [ $1 == "" ]; then
		exit 1;
	fi

	ACSMOD=""

	cat $1 | while read line
	do
		if [ ${#line} -eq 0 ]; then # 空行はスキップ（この処理不要？）
			continue;
		fi

		TMPCLASS=`echo "$line" | ${SED} -rn 's/^\s*class\s+(\S+)\s*\{\s*$/\1/p'` # 本当はもう少し真面目に書くべき
		TMPACSMOD=`echo "$line" | ${SED} -rn 's/^\s*(.*)\s*:\s*$/\1/p'`     # access modifier

		if [ "$TMPCLASS" != "" ]; then 
			CLASS=$TMPCLASS
		fi

		if [ "$TMPACSMOD" != "" ]; then
			ACSMOD=$TMPACSMOD
		fi

		echo "$ACSMOD" "$TMPACSMOD"

		line=`echo "$line" | ${SED} -rn 's/^(.*)\/\/.*$/\1/p'` # remove inline comment
		TYPE=`echo "$line" | ${SED} -rn 's/^\s*(\S.*\S)\s+(\S+)\s*;\s*$/\1/p'`   # get a type name
		NAME=`echo "$line" | ${SED} -rn 's/^\s*(\S.*\S)\s+(\S+)\s*;\s*$/\2/p'`   # get a varaible name
		PROPERED=`echo "$NAME" | awk '{print toupper(substr($1,1,1))substr($1,2)}'` # bash 4.0 からは{$NAME^}でいける

		if [ "$TYPE" == "" ] || [ "$NAME" == "" ] || [ "$ACSMOD" != "private" ]; then
			continue;
		fi

		echo "$TYPE" "$CLASS"::get"$PROPERED"\(\)
		echo \{
		echo -e "\treturn" "$NAME"\;
		echo \}
		echo
		echo void "$CLASS"::set"$PROPERED"\("$TYPE" new"$PROPERED"\)
		echo \{
		echo -e "\t""$NAME" = new"$PROPERED"\;
		echo \}
		echo
	done
}

TMPIFS=${IFS}
IFS=$'\n'

SED=""
ENV=`getenv`

case "$ENV" in
	"mac"    ) SED="gsed";;
	"cygwin" ) SED="sed" ;;
	*        ) 
		echo $0": Illegal execution environment."
		exit 1
		;;
esac

SRC=""  # input cource file
DST=""  # output destination (standard output or clipboard)
MODE="" # generation mode (cpp -> hpp or hpp -> cpp)
        #  - cpp(accessor) -> hpp(prototype declaration)
        #  - hpp(variable declaretion) -> cpp(accessor)
if [ "$OPTIND" = 1 ]; then
	while getopts c:h:o: OPT; do
		case $OPT in
			c)
				MODE="ctoh"
				SRC=$OPTARG
				echo cppToHpp $OPTARG
				;;
			h)
				MODE="htoc"
				SRC=$OPTARG
				echo hppToCpp $OPTARG
				;;
			o)
				DST="$OPTARG"
				echo output-target $OPTARG
				;;
			*)
				usage
				;;
		esac
	done
else
	echo "No installed getopts-command." 1>&2
	exit 1
fi

# switch
if [ "$MODE" = "ctoh" ]; then
	if [ "$DST" = "" ]; then
		gen-dec-of-accessor "$SRC"
	else
		gen-dec-of-accessor "$SRC" > "$DST"
	fi
elif [ "$MODE" = "htoc" ]; then
	if [ "$DST" = "" ]; then
		gen-accessor "$SRC"
	else
		gen-accessor "$SRC" > "$DST"
	fi
else	
	usage
fi

IFS=${TMPIFS}

exit 0
