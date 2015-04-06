#!/bin/sh

KEYMAP_FILE_PATH="/usr/share/X11/xkb/tizen_key_layout.txt"
BASE_KEYSYM="0x10090000"
XF86_HEADER_FILE="./XF86keysym.h"
NORMAL_HEADER_FILE="./keysymdef.h"
TEMP_TEXT_FILE="./temp_file.txt"
NEW_DEFINE_SYM_FILE="./new_define_sym.txt"
cout=1
BASE_KEYSYM_DEC=`python -c "print int('$BASE_KEYSYM', 16)"`

if [ -e ${KEYMAP_FILE_PATH} ]
then
	echo "Have a key layout file: ${KEYMAP_FILE_PATH}"
else
	echo "Doesn't have a key layout file: ${KEYMAP_FILE_PATH}"
	exit
fi

echo "Generate a tizen keymap header file"

while read KEYNAME KEYCODE
do
	XF86_EXIST=`expr match "${KEYNAME}" 'XF86'`
	if [ $XF86_EXIST = 4 ]
	then
		KEYSYM="XF86XK_${KEYNAME#XF86}"
		FIND_HEADER_FILE=$XF86_HEADER_FILE
	else
		KEYSYM="XK_${KEYNAME}"
		FIND_HEADER_FILE=$NORMAL_HEADER_FILE
	fi
	grep -rn "${KEYSYM}" $FIND_HEADER_FILE > $TEMP_TEXT_FILE
	FINDED_DEFINE=`cat temp_file.txt | awk '{print $2}'`

	BOOL_FOUND_SYM=false
	for SEARCH_SYM in ${FINDED_DEFINE}
	do
		if [ "$SEARCH_SYM" = "$KEYSYM" ]
		then
			BOOL_FOUND_SYM=true
			break
		fi
	done
	if [ "$BOOL_FOUND_SYM" = false ]
	then
		echo "${KEYSYM}" >> $NEW_DEFINE_SYM_FILE
	fi
done < ${KEYMAP_FILE_PATH}

echo "" >> $XF86_HEADER_FILE
echo "/* Keys for tizen */" >> $XF86_HEADER_FILE
echo "" >> $NORMAL_HEADER_FILE
echo "/* Keys for tizen */" >> $NORMAL_HEADER_FILE

while read KEYNAME
do
    KEYSYM_DEC=$(echo $BASE_KEYSYM_DEC $cout | awk '{print $1 + $2}')
	KEYSYM=$(printf "%x" $KEYSYM_DEC)
	cout=$(echo $cout 1 | awk '{print $1 + $2}')
	XF86_EXIST=`expr index "${KEYNAME}" 'XF86'`
	if [ $XF86_EXIST = 1 ]
	then
		echo -en "#define ${KEYNAME}\t\t0x$KEYSYM\n" >> $XF86_HEADER_FILE
	else
		echo -en "#define ${KEYNAME}\t\t0x$KEYSYM\n" >> $NORMAL_HEADER_FILE
	fi
done < ${NEW_DEFINE_SYM_FILE}

rm $NEW_DEFINE_SYM_FILE
rm $TEMP_TEXT_FILE
