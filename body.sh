#!/bin/bash

vars=$(set -o posix; set | sort);
params="$@"
##################################################################################
#################################    IMPORT   ####################################
source "$(cd $(dirname "$0") ; pwd -P;)/head.sh"
 

##################################################################################
#################################     ARGS    ####################################

## Main arg for function

if [ -z "$1" ]; then
    err "No argument supplied"
    exit 1
fi

## Parse args
while [ "$1" != "" ]; do
    PARAM=`echo $1`
    VALUE=`echo $2`
    case $PARAM in
        -h | --help | usage)
            help
            exit
            ;;
        -c | --conf)
            CONF_FILE="$VALUE"
            read_conf
            shift
            shift
            ;;
        -s | --source-path) 
            SOURCE_PATH="$VALUE"
            shift
            shift            
            ;;
        -d | --destination-path)
            DESTINATION_PATH="$VALUE"
            shift
            shift            
            ;;
        -c | --copy-type) 
            COPY_TYPE="$VALUE"
            shift
            shift
            ;;
        -p | --dest-pattern) 
            DEST_PATTERN="$VALUE"
            shift
            shift
            ;;
        -r | --retention-days) 
            RETENTION_DAYS="$VALUE"
            shift
            shift
            ;;
        -l | --log-file)
            LOG_FILE="$VALUE"
            shift
            shift
            ;;
        backup)
            TBE="backup"
            shift
            ;;
        configure)
            TBE="configure"
            shift
            ;;
        *)
            echo "unknown argument \"$PARAM\""
            exit 1
            ;;
    esac
done



[[ (! -z $LOG_FILE) && -f $LOG_FILE ]] && exec &> >(tee -a "$LOG_FILE")


##################################################################################
################################# SCRIPT MAIN ####################################



[[ -z $TBE ]] && { is_interactive && { echo -n "what should I do?  "; read TBE; export TBE; }; }
[[ -z $TBE ]] && ( err "Oops! Doing nothing, check parameters\n\n"; help; exit 1 )
[[ $TBE = "backup" ]] && var_check
$TBE
cd $CURRENT_PATH
