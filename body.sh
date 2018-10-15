#!/bin/bash

# DEBUG
[ -z $DEBUG ] && DEBUG=1
debug() {
	[[ $DEBUG -eq 1 ]] && echo "$@"
}

# DEFAULTS
CURRENT_PATH="$(pwd -P)"
debug "CURRNET PATH: $CURRENT_PATH"
SCRIPT_PATH=`cd $(dirname "$0") ; pwd -P`
debug "SCRIPT PATH: $SCRIPT_PATH"
SCRIPT_NAME=`basename $0`
debug "SCRIPT NAME: $SCRIPT_NAME"
CRON_PATH=/etc/cron.daily/

# run once daily
cron() {
	IS_CRON=`crontab -l 2> /dev/null | grep $SCRIPT_NAME | wc -l` 
	debug "IS_CRON: $IS_CRON"
	if [[ $IS_CRON -eq 0 ]]; then
	    #[[ -e "/etc/cron.daily/$SCRIPT_NAME" ]] && debug "${CRON_PATH}/${SCRIPT_NAME} exist" || (cp ${SCRIPT_PATH}/${SCRIPT_NAME} ${CRON_PATH}; debug "${CRON_PATH}/${SCRIPT_NAME} not exist")
	    (crontab -l 2> /dev/null && echo "### BACKUP SCRIPT ###" && echo "0 0 * * * ${SCRIPT_PATH}/${SCRIPT_NAME}") | crontab -
	    debug "0 0 * * * ${SCRIPT_PATH}/${SCRIPT_NAME} added to crontab"
	fi 
}

"$@"