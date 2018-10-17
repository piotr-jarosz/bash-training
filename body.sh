#!/bin/bash

# DEBUG FUNCTIONS
DEBUG="$1"
[[ "$DEBUG" = "--debug" ]] && DEBUG=0 && shift || DEBUG=1 

# DEFAULTS
CURRENT_PATH="$(pwd -P)"; echo "CURRNET PATH: $CURRENT_PATH"
SCRIPT_PATH=`cd $(dirname "$0") ; pwd -P`; echo "SCRIPT PATH: $SCRIPT_PATH"
SCRIPT_NAME=`basename $0`; echo "SCRIPT NAME: $SCRIPT_NAME"

source ${SCRIPT_PATH}/functions.sh

# PARAMETERS HANDLING

## Main arg for function

if [ -z "$1" ]
  then
    echo "No argument supplied"
                echo "HALP!!!"

    exit 1
fi


TBE="$1"
shift

## Execute
    case $TBE in
        -h | --help | usage)
            echo "HALP!!!"
            exit
            ;;
        backup)
            debug "BACKUP"
            ;;
        configure)
            debug "configure"
            ;;
        *)
            echo "unknown action \"$TBE\""
            exit 1
            ;;
    esac

## Parse args
while [ "$1" != "" ]; do
    PARAM=`echo $1`
    VALUE=`echo $2`
    case $PARAM in
        -h | --help)
            echo "HALP!!!"
            exit
            ;;
        -c | --conf)
            CONF_FILE="$VALUE"
            conf
            ;;
		-s | --source-path) 
			SOURCE_PATH="$VALUE"
			;;
		-d | --destination-path)
			DESTINATION_PATH="$VALUE"
			;;
		-c | --copy-type) 
			COPY_TYPE="$VALUE"
			;;
		-p | --dest-pattern) 
			DEST_PATTERN="$VALUE"
			;;
		-r | --retention-days) 
			RETENTION_DAYS="$VALUE"
			;;
        *)
            echo "unknown parameter \"$PARAM\""
            ;;
    esac
    shift
    shift
done


# DICTIONARIES
COPY_TYPES="cp, tar, targz, rsync"


# SCRIPT SPECIFIC VARIABLES
# if not commented, will override file config variables

# SOURCE_PATH=""
# DESTINATION_PATH="/tmp/backuptest"
# COPY_TYPE="tar"
# DEST_PATTERN='%T'
# RETENTION_DAYS=2


#variables check
[[ -z $COPY_TYPE ]] && debug "COPY_TYPE DOES NOT EXIST!!" || debug "COPY_TYPE:${COPY_TYPE}"
[[ $COPY_TYPES = *$COPY_TYPE* ]] || debug "WRONG COPY_TYPE: $COPY_TYPE, shoul be one of: $COPY_TYPES"
[[ -z $DEST_PATTERN ]] && debug "DEST_PATTERN DOES NOT EXIST!!" || debug "DEST_PATTERN:${DEST_PATTERN}"
[[ -z $DEST_NAME ]] && DEST_NAME=`date +"$DEST_PATTERN"`; debug "DEST_NAME: $DEST_NAME"
[[ -z $DESTINATION_PATH ]] && debug "error Please setup destination path"
[[ -z $RETENTION_DAYS ]] && debug "RETENTION_DAYS DOES NOT EXIST!!" || debug "RETENTION_DAYS:${RETENTION_DAYS}"
[[ -z $SOURCE_PATH ]] && debug "SOURCE_PATH DOES NOT EXIST!!" || debug "SOURCE_PATH:${SOURCE_PATH}"

##################################################################################
################################# SCRIPT BODY ####################################



$TBE
cd $CURRENT_PATH



