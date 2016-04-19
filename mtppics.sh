#!/bin/bash

####################
# mtppics.sh
# Copyright 2016 by Ben Cotton
# License: GNU GPLv3+ 
#
# This script is mostly just a piece of garbage to help my wife and I copy
# pictures off our phones on a regular basis. It's probably not going to work
# very well for you, but maybe it will someday...
####################

# By default, where are we copying the files from? Should be a relative path on
# the MTP device.
SOURCE_DIR=${MTPPICS_SOURCE_DIR:-"Card/DCIM/Camera"}
# By default, where are we copying the files to? Can be an absolute or relative
# path on the computer. You can use date(1) format variables in here.
DEST_DIR=${MTPPICS_DEST_DIR:-"Pictures/%Y/%m"}

_VERSION='0.1'
_COPYRIGHT="Copyright 2016 - Ben Cotton"

function _cleanup {
    # Clean up after ourselves
    if [ "${MTP_MOUNT}" ]; then
        echo "Unmounting ${MTP_MOUNT}"
        fusermount -u ${MTP_MOUNT} || \
            echo "WARNING: Could not unmount ${MTP_MOUNT}"
        rmdir ${MTP_MOUNT} || echo "WARNING: Could not remove ${MTP_MOUNT}"
    fi
    
    read -p 'Press the enter key to exit'
    exit
}

function _errorhandler {
    echo "🏈🐺🌴🌴🌴 Encountered an error ${1}"
    echo 'Aborting!'
    _cleanup
}

trap '_errorhandler "${EMSG:-"Unknown error"}"' ERR SIGINT SIGTERM SIGHUP

echo "mtppics.sh - v${_VERSION} - ${_COPYRIGHT}"

# We're going to get pretty crazy with the date(1) command.
CURRENT_DATE='now'
while getopts ":ls:" option; do
    case $option in
        l)
            # Archive pictures for the last month.
            CURRENT_DATE="$(date +%Y-%m-15) -1 month"
            ;;
        s)
            # Archive pictures for a given date string.
            CURRENT_DATE="${OPTARG}"
            ;;
        \?)
            _errorhandler "unknown option -$OPTARG"
            ;;
        :)
            _errorhandler "missing argument to -$OPTARG"
            ;;
    esac
done

# We use the EMSG to give a user-helpful message about what we we're doing and
# also to double as a comment on what...we're doing.
EMSG='making temporary directory'
MTP_MOUNT=$(mktemp -d)
EMSG='looking for simple-mtpfs command'
MTPFSCMD=$(which simple-mtpfs)

EMSG='mounting MTP device'
${MTPFSCMD} ${MTP_MOUNT}

YYYYMM=$(date --date="${CURRENT_DATE}" +%Y%m)
DEST_DIR=$(date --date="${CURRENT_DATE}" "+${DEST_DIR}")

EMSG='making sure destination directory exists'
mkdir -p "${DEST_DIR}"

EMSG="copying files to ${DEST_DIR}"
echo "Ready to start ${EMSG}"
rsync -v "${MTP_MOUNT}/${SOURCE_DIR}/"*${YYYYMM}* "${DEST_DIR}"

echo 'Copy complete'

_cleanup
