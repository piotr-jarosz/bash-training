function is_debug() {
    [[ $LOG_L -eq 3 ]] && return 0 || return 1
}

function debug() {
	is_debug && echo "[DEBUG] $@"
}

function is_info() {
    [[ $LOG_L -ge 2 ]] && return 0 || return 1
}

function info() {
	is_info && echo "[INFO] $@"
}


function is_warn() {
    [[ $LOG_L -ge 1 ]] && return 0 || return 1
}

function warn() {
	is_warn && echo "[WARN] $@"
}

function is_err() {
    [[ $LOG_L -ge 0 ]] && return 0 || return 1
}

function err() {
	is_err && echo "[ERROR] $@"
}



DEBUG="$1"
[[ "$DEBUG" = "--debug" ]] && { LOG_L=3; shift ;} || LOG_L=0 
info "$LOG_L"
# DEFAULTS
CURRENT_PATH="$(pwd -P)"; debug "CURRNET PATH: $CURRENT_PATH"
SCRIPT_PATH=`cd $(dirname "$0") ; pwd -P`; debug "SCRIPT PATH: $SCRIPT_PATH"
SCRIPT_NAME=`basename $0`; debug "SCRIPT NAME: $SCRIPT_NAME"

source ${SCRIPT_PATH}/functions.sh
# DICTIONARIES

COPY_TYPES="cp, tar, targz, rsync"
VAR_CHECK_TYPES="backup"