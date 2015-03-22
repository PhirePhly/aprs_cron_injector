#!/bin/bash
# APRS Cron Object Injector
# Kenneth Finnegan, 2015
# 
# This script is meant to be used when you want to inject a single APRS
# object into the APRS backbone, and can not justify the complexity of
# deploying a complete APRS daemon such as aprx.
#
# Deploy by editting the configuration parameters below, and then adding
# to your crontab to run periodically. See the README for further 
# information: https://github.com/PhirePhly/aprs_cron_injector

APRS_CALL="N0CALL"
APRS_PASS="-1"
APRS_SERVER="rotate.aprs2.net"
APRS_PORT="14580"

OBJ_NAME="         "
OBJ_LAT="0000.00N"
OBJ_LONG="00000.00W"
OBJ_OVERLAY="/"
OBJ_SYMBOL="r"
OBJ_COMMENT=""

### END OF USER CONFIGUATION ###


# Parameter verification
APRS_CALL=`echo $APRS_CALL | tr '[:lower:]' '[:upper:]'`
if [ $APRS_CALL = "N0CALL" ]; then
	echo "ERROR: N0CALL not valid APRS Callsign"
	exit 1
fi
if [ $APRS_CALL = "NOCALL" ]; then
	echo "ERROR: NOCALL not valid APRS Callsign"
	exit 1
fi
if [ $APRS_CALL = "MYCALL" ]; then
	echo "ERROR: MYCALL not valid APRS Callsign"
	exit 1
fi
if [ ${#APRS_CALL} -lt 3 ]; then
	echo "ERROR: APRS callsign must be at least three characters"
	exit 1
fi
if [ ${#APRS_CALL} -gt 9 ]; then
	echo "ERROR: APRS callsign may not be longer than nine characters"
	exit 1
fi

if [ $APRS_PASS = "-1" ]; then
	echo "ERROR: APRS-IS Passcode required for object injection"
	exit 1
fi
if [ ${#OBJ_NAME} -lt 9 ]; then
	echo "ERROR: Object name must be space-padded to nine characters"
	exit 1
fi
if [ ${#OBJ_NAME} -gt 9 ]; then
	echo "ERROR: Object name too long; may only be nine characters"
	exit 1
fi
if [ ${#OBJ_LAT} -ne 8 ]; then
	echo "ERROR: Object latitude must match DDMM.mmN format"
	exit 1
fi
if [ ${#OBJ_LONG} -ne 9 ]; then
	echo "ERROR: Object longitude must match DDDMM.mmE format"
	exit 1
fi
if [ ${#OBJ_OVERLAY} -ne 1 ]; then
	echo "ERROR: Object table or overlay selection must be a single character"
	exit 1
fi
if [ ${#OBJ_SYMBOL} -ne 1 ]; then
	echo "ERROR: Object symbol must be a single character"
	exit 1
fi
if [ ${#OBJ_COMMENT} -gt 43 ]; then
	echo "ERROR: Object comment field may not exceed 43 characters"
	exit 1
fi

# Dither beaconing to not slam APRS network on the top of the interval
sleep `expr $RANDOM % 300`

# Generate Beacon text and inject into APRS-IS backbone
TIMESTAMP="`date -u +%d%H%M`z"
OBJ_STRING=";${OBJ_NAME}*${TIMESTAMP}${OBJ_LAT}${OBJ_OVERLAY}${OBJ_LONG}${OBJ_SYMBOL}${OBJ_COMMENT}"

BEACON_LOGIN="user ${APRS_CALL} pass ${APRS_PASS} vers CronInjector 1.0-W6KWF"
BEACON_TEXT="${APRS_CALL}>APZKWF:${OBJ_STRING}"

echo -e "${BEACON_LOGIN}\n${BEACON_TEXT}" >/dev/tcp/${APRS_SERVER}/${APRS_PORT}

