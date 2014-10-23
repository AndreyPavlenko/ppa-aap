#!/bin/sh

: ${CONFIG:='/etc/vdr/plugins/iptv/scripts.conf'}

[ -e "$CONFIG" ] && . "$CONFIG" 

: ${PORT:="$2"}
: ${PARAMETER:="$1"}
: ${SCRIPT_NAME:="$(basename "$0")"}
: ${CHANNELS_CONF:='/etc/vdr/channels.conf'}

: ${DEFAULT_VCODEC:='mp2v'}
: ${DEFAULT_ACODEC:='mpga'}
: ${DEFAULT_VB:='800'}
: ${DEFAULT_AB:='160'}
: ${DEFAULT_EXTRACT_PARAMS:='VCODEC|ACODEC|VB|AB|WIDTH|HEIGHT|TRANSCODE'}

log() {
    logger -t "${SCRIPT_NAME}" "$@"
}

fail() {
    log "Error: $@"
    exit 1
}

play() {
    local url="$1"

    ps -f -u vdr | awk "/dst=127.0.0.1:${PORT}/ {print \$2}" | xargs kill 2> /dev/null
    ps -f -u vdr | awk "/dst=127.0.0.1:${PORT}/ {print \$2}" | xargs kill -9  2> /dev/null

    exec vlc "${url}" \
  --sout "#transcode{${TRANSCODE}}:standard{access=udp,mux=ts{pid-video=${VPID},pid-audio=${APID},pid-spu=0},dst=127.0.0.1:${PORT}}" \
  --intf dummy
}

CHANNEL_RECORD="$(grep "[:]S=[10][|]P=[10][|]F=EXT[|]U=${SCRIPT_NAME}[|]A=$PARAMETER.*[:]I" $CHANNELS_CONF)"
[ -z "$CHANNEL_RECORD" ] && fail "no iptv channel with parameter $PARAMETER found"

CHANNEL_NAME="$(echo $CHANNEL_RECORD | awk '-F[;,:]' '{print $1}' | tr '|' ':')"

if [ -z "$EXTRACT_PARAMS" ]
then
    EXTRACT_PARAMS="$DEFAULT_EXTRACT_PARAMS"
else
	EXTRACT_PARAMS="$EXTRACT_PARAMS|$DEFAULT_EXTRACT_PARAMS"
fi

eval "$(echo "$CHANNEL_RECORD" | grep -o "[|]A=$PARAMETER.*[:]I" | tr '_' ' ' | grep -oE "($EXTRACT_PARAMS)=[^:]+")"

VPID=`echo $CHANNEL_RECORD | awk -F: '{print $6}'`
APID=`echo $CHANNEL_RECORD | awk -F: '{print $7}'`

if [ -z "$TRANSCODE" ]
then
    : ${VCODEC:="$DEFAULT_VCODEC"}
    : ${ACODEC:="$DEFAULT_ACODEC"}
    : ${VB:="$DEFAULT_VB"}
    : ${AB:="$DEFAULT_AB"}
    [ -z "$WIDTH" ] || GEOM=",width=$WIDTH"
    [ -z "$HEIGHT" ] || GEOM="$GEOM,height=$HEIGHT"
    TRANSCODE="vcodec=${VCODEC},vb=${VB},acodec=${ACODEC},ab=${AB}${GEOM}"
fi
