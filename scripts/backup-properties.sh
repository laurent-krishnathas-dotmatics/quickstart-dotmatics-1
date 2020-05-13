#!/bin/sh
set -x
set -e

env

if [ -z "$P_INSTALL_BUCKET_NAME" ]; then
    echo "P_INSTALL_BUCKET_NAME env is empty"
    echo "backup failed"
    exit 1
else
    aws s3 ls s3://${P_INSTALL_BUCKET_NAME}

    if  [ -f "$EFS_BROWSER_PROPERTIES" ]; then
        export BACKUP_DATE=$(date +'%Y-%m%d-%Hh%M')
        aws s3 cp $EFS_BROWSER_PROPERTIES s3://$P_INSTALL_BUCKET_NAME/backup/browser-${BACKUP_DATE}.properties
    else
        echo "EFS_BROWSER_PROPERTIES env is empty"
        echo "backup failed"
        exit 1
    fi

    aws s3 ls s3://${P_INSTALL_BUCKET_NAME}/backup/
    echo "backup done."
fi
