#!/bin/sh

counter='0'

if [ -z "$1" ]
then
    echo "Reading playlist form stdin" 1>&2
    input='/dev/stdin'
else
    echo "Reading playlist $1" 1>&2
    input="$1"
fi

grep -vE '^\s*$' < "$input" | grep '^#EXTINF:' -A 1 | while read EXTINF
do
    name="$(echo "$EXTINF" | awk -F ',' '{print $2}')"

    if [ -z "$name" ]
    then
        echo "Unable to parse channel name: $EXTINF" 1>&2
    else
        read url
        counter="$((counter + 1))"

        if echo "$url" | grep -qE '^http://'
        then
            port="$(echo "$url" | grep -Eo ':[0-9]+/' | tr -d [:/])"
            url="$(echo "$url" | sed -r "s|http://||; s|:[0-9]*/|/|")"
            [ -z "$port" ] && port='80'
            echo "${name};IPTV:${counter}:S=0|P=0|F=HTTP|U=${url}|A=${port}:I:0:69:68:0:0:${counter}:0:0:0"
        else
           url="$(echo "$url" | sed "s/:/%3A/g")"
            echo "${name};IPTV:${counter}:S=0|P=0|F=CURL|U=${url}|A=${counter}:I:0:69:68:0:0:${counter}:0:0:0"
        fi
    fi
done