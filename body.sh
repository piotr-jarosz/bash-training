#!/bin/bash

# DEBUG FUNCTIONS
DEBUG="$1"
[[ "$DEBUG" = "--debug" ]] && DEBUG=0 && shift || DEBUG=1 

function is_debug() {
    [[ $DEBUG -eq 0 ]] && return 0 || return 1
}

function debug() {
	is_debug && echo "$@"
}


# DEFAULTS
CURRENT_PATH="$(pwd -P)"
debug "CURRNET PATH: $CURRENT_PATH"
SCRIPT_PATH=`cd $(dirname "$0") ; pwd -P`
debug "SCRIPT PATH: $SCRIPT_PATH"
SCRIPT_NAME=`basename $0`
debug "SCRIPT NAME: $SCRIPT_NAME"

 [[ -z $CONF_FILE ]] && CONF_FILE=${SCRIPT_PATH}/conf.yaml
if [[ -e $CONF_FILE  ]]; then
	debug "CONF_FILE: $CONF_FILE"
	if [[ $CONF_FILE == *.yml || $CONF_FILE == *.yaml ]]; then
		debug "YAML TYPE CONF FILE"
		source $SCRIPT_PATH/bash-yaml/yaml.sh

		if is_debug; then
		    parse_yaml $CONF_FILE && echo
		fi

		create_variables $CONF_FILE
	else
		source $CONF_FILE &> /dev/null || { debug "UNKNOWN CONF TYPE" ; exit 1; }
	fi
fi


### CONFIGURATION HANDLE FROM YAML ###



# DICTIONARIES
COPY_TYPES="cp, tar, targz, rsync"


# SCRIPT SPECIFIC VARIABLES
# if not commented, will override file config variables

SOURCE_PATH="/tmp/dotestow"
DESTINATION_PATH="/tmp/backuptest"
COPY_TYPE="tar"
DEST_PATTERN='%T'
RETENTION_DAYS=2


#variables check
[[ $COPY_TYPES = *$COPY_TYPE* ]] || debug "WRONG COPY_TYPE: $COPY_TYPE, shoul be one of: $COPY_TYPES"
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
		DEST="$DESTINATION_PATH/$DEST_NAME.tar"
		tar -cvf "$DEST" -C "$SOURCE_PATH" .
		SUCCESS=$?
	elif [[ $COPY_TYPE == "targz" ]]; then
		debug "STARTING TARGZ"
		DEST="$DESTINATION_PATH/$DEST_NAME.tar.gz"
		tar -zcvf "$DEST" -C "$SOURCE_PATH" .
		SUCCESS=$?
	elif [[ $COPY_TYPE == "cp" ]]; then
		debug "STARTING CP"
		DEST="$DESTINATION_PATH/$DEST_NAME"
		mkdir -p $DEST
		cp -R --verbose $SOURCE_PATH/* $DESTINATION_PATH/
		SUCCESS=$?
	elif [[ $COPY_TYPE == "rsync" ]]; then
		debug "STARTING RSYNC"
		DEST="$DESTINATION_PATH/$DEST_NAME"
		mkdir -p $DEST
		rsync -v $SOURCE_PATH/ $DEST/
		SUCCESS=$?
	fi

	if [[ $SUCCESS -eq 0 ]]; then
		debug "BACKUP: SUCCESS, EXIT_CODE: $SUCCESS"
		while [[ $(ls $DESTINATION_PATH | wc -l) -lt $RETENTION_DAYS ]]; do
			OLDEST_FILE=$(echo $(ls -t $DESTINATION_PATH) | awk '{ print $NF }')
			debug "OLDEST FILE to be tested: $OLDEST_FILE"
			if [[ $(stat -c %Y "$DESTINATION_PATH/$OLDEST_FILE") -gt $(date -d "-${RETENTION_DAYS} days" +%s) ]]; then
				debug "OLDEST FILE older than retention"
				rm -rf "$DESTINATION_PATH/$OLDEST_FILE"
			else
				break
			fi
		done
	else
		debug "ERROR: $COPY_TYPE BACKUP of $SOURCE_PATH FAILED with EXIT_CODE: $SUCCESS" 
	fi

}





cd $CURRENT_PATH
"$@"