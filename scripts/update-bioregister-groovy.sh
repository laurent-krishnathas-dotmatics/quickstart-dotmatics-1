#!/bin/sh
set -x
set -e

env

if [ -z "$BACKUP_DATE" ]; then
    echo "BACKUP_DATE env is a empty string"
    export BACKUP_DATE=$(date +'%Y-%m%d-%Hh%M')
else
    echo "BACKUP_DATE has the value: $BACKUP_DATE"
fi


if [  -f "$TMP_BIOREGISTER_GROOVY" ]; then
    echo "bioregister.groovy exists,then update ServerURL and oracle host."

    if [   -f  "$EFS_BIOREGISTER_GROOVY" ]; then
        export BIOREGISTER_PASSWORD=$(cat $EFS_BIOREGISTER_GROOVY | grep password= |  cut -d"'" -f2 | xargs)
        sed -i 's/password=\x27.*\x27/password=\x27'$BIOREGISTER_PASSWORD'\x27/g' $TMP_BIOREGISTER_GROOVY
        cat $TMP_BIOREGISTER_GROOVY | grep password=
    fi

    if [ '$P_DNS_ZONE_ID' = '' ] ; then
          echo "pDnsHostedZoneID is empty."
          sed -i 's/http:\/\/localhost:8080/http:\/\/'$ALB_DNS_NAME'/g'  $TMP_BIOREGISTER_GROOVY

    elif [ "$P_DNS_ZONE_APEX_DOMAIN" = '' ]; then
          echo "pDnsZoneApexDomain is empty."
          sed -i 's/http:\/\/localhost:8080/http:\/\/'$ALB_DNS_NAME'/g'  $TMP_BIOREGISTER_GROOVY
    else
          echo "pDnsHostedZoneID and pDnsZoneApexDomain are not empty."
          sed -i 's/http:\/\/localhost:8080/https:\/\/'$P_DNS_NAME'.'$P_DNS_ZONE_APEX_DOMAIN'/g'  $TMP_BIOREGISTER_GROOVY
    fi
    sed -i 's/localhost/'$PRIVATE_DNS_NAME'/g'  $TMP_BIOREGISTER_GROOVY
    sed -i 's/c:\\\\c2c_attachments/\/c2c_attachments/g' $TMP_BIOREGISTER_GROOVY
    sed -i 's/XE/'$P_DATABASE_NAME'/g' $TMP_BIOREGISTER_GROOVY
    echo "updating browser.properties done at $(date)"
else
    echo "[WARN] $TMP_BIOREGISTER_GROOVY doesn't exist,then bioregister container will not be launched."
fi

if [  -f "$EFS_BIOREGISTER_GROOVY" ]; then
    cp -r $EFS_BIOREGISTER_GROOVY /efs/backup/$BACKUP_DATE/
fi

if [  -f "$TMP_BIOREGISTER_GROOVY" ]; then
  echo "copy bioregister ... "
  yes | cp $TMP_BIOREGISTER_GROOVY $EFS_BIOREGISTER_GROOVY
  rm -rf $TMP_BIOREGISTER_GROOVY
fi