#!/bin/bash

# DEBUG
[ -z $DEBUG ] && DEBUG=1
debug() {
	[[ $DEBUG -eq 1 ]] && echo "$@"
}

# SCRIPT SPECIFIC VARIABLES
# if not empty, will override file config variables

SOURCE_PATH="/tmp/dotestow"
DESTINATION_PATH="/tmp/backuptest"
COPY_TYPE="rsync"
DEST_PATTERN='as+%F-%A'

# DEFAULTS
CURRENT_PATH="$(pwd -P)"
debug "CURRNET PATH: $CURRENT_PATH"
SCRIPT_PATH=`cd $(dirname "$0") ; pwd -P`
debug "SCRIPT PATH: $SCRIPT_PATH"
SCRIPT_NAME=`basename $0`
debug "SCRIPT NAME: $SCRIPT_NAME"
#CRON_PATH=/etc/cron.daily
COPY_TYPES="cp, tar, targz, rsync"
#variables check
[[ $COPY_TYPES = *$COPY_TYPE* ]] || debug "WRONG COPY_TYPE: $COPY_TYPE, shoul be one of: $COPY_TYPES"
[[ -z $CONF_FILE ]] && CONF_FILE=${SCRIPT_PATH}/base.conf
debug "CONF_FILE: $CONF_FILE"
[[ -e $CONF_FILE ]] && (debug "FILE EXISTS: $CONF_FILE"; source $CONF_FILE) || debug "FILE NOT EXISTS: $CONF_FILE"
[[ -z $DEST_NAME ]] && DEST_NAME=`date +"$DEST_PATTERN"`; debug "DEST_NAME: $DEST_NAME"
[[ -z $DESTINATION_PATH ]] && debug "error Please setup destination path"





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

backup() {
	[[ -d $DESTINATION_PATH ]] && debug "DESTINATION PATH EXISTS: $DESTINATION_PATH" || (mkdir -p $DESTINATION_PATH && debug "DESTINATION PATH CREATED: $DESTINATION_PATH")
	if [[ $COPY_TYPE == "tar" ]]; then
		debug "STARTING TAR"
		DESTINATION_PATH="$DESTINATION_PATH/$DEST_NAME.tar"
		tar -cvf "$DESTINATION_PATH" -C "$SOURCE_PATH" .
	elif [[ $COPY_TYPE == "targz" ]]; then
		debug "STARTING TARGZ"
		DESTINATION_PATH="$DESTINATION_PATH/$DEST_NAME.tar.gz"
		tar -zcvf "$DESTINATION_PATH" -C "$SOURCE_PATH" .
	elif [[ $COPY_TYPE == "cp" ]]; then
		debug "STARTING CP"
		DESTINATION_PATH="$DESTINATION_PATH/$DEST_NAME"
		mkdir -p $DESTINATION_PATH
		cp -R --verbose $SOURCE_PATH/* $DESTINATION_PATH/
	elif [[ $COPY_TYPE == "rsync" ]]; then
		debug "STARTING RSYNC"
		DESTINATION_PATH="$DESTINATION_PATH/$DEST_NAME"
		mkdir -p $DESTINATION_PATH
		rsync -v $SOURCE_PATH/ $DESTINATION_PATH/
	fi

}





cd $CURRENT_PATH
"$@"