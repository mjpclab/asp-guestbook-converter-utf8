#!/bin/bash

#Usage shenj-utf8 [gbook-directory]

if [ -n "$1" ]; then
	basedir="$1"
else
	basedir="$(pwd)"
fi;

echo -n 'Converting charset to UTF-8...'
find "$basedir" -type f \( -iname '*.asp' -o -iname '*.inc' \) -print0 | while read -d $'\0' file; do
	iconv -s -f GBK -t UTF-8 "$file" > "$file".tmp
	\mv -f "$file".tmp "$file"
done;
[ $? -eq 0 ] && echo ' [OK]' || echo ' [Failed!]'

echo -n 'Replacing charset declaration...'
find "$basedir" -type f \( -iname '*.asp' -o -iname '*.inc' \) -print0 | xargs -0 grep -Zl '[Cc]harset' 2>/dev/null | while read -d $'\0' file; do
	sed -b -e '/[Cc]harset/s/gbk/utf-8/' "$file" > "$file".tmp
	\mv -f "$file".tmp "$file"
done;
[ $? -eq 0 ] && echo ' [OK]' || echo ' [Failed!]'

echo -n 'Replacing codepage declaration...'
find "$basedir" -type f \( -iname '*.asp' -o -iname '*.inc' \) -print0 | xargs -0 grep -Zl '[Cc]ode[Pp]age' 2>/dev/null | while read -d $'\0' file; do
	sed -b -e '/[Cc]ode[Pp]age/s/936/65001/' "$file" > "$file".tmp
	\mv -f "$file".tmp "$file"
done;
[ $? -eq 0 ] && echo ' [OK]' || echo ' [Failed!]'
