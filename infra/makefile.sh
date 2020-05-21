#!/usr/bin/env bash

set -e
set -u
set -x


function stack_deploy_browser(){

    set_up_configuration

    echo "BIOREGISTER_ENABLE=$BIOREGISTER_ENABLE"
    echo "VORTEX_ENABLE=$VORTEX_ENABLE"


    if [ "$BIOREGISTER_ENABLE" = "true" ] &&  [ "$VORTEX_ENABLE" = "true" ]  ; then
        BROWSER_LIMIT_MEM=$MEM_35_PCT  BIOREGISTER_LIMIT_MEM=$MEM_35_PCT  VORTEX_LIMIT_MEM=$MEM_10_PCT  TRAEFIK_LIMIT_MEM=$MEM_10_PCT	STACK_NAME=$BRO_STACK_NAME ENV=$ENV docker stack deploy --with-registry-auth  -c docker/stack/browser/browser.yml -c docker/stack/browser/browser-$ENV.yml $BRO_STACK_NAME

    elif [ "$BIOREGISTER_ENABLE" = "true" ] &&  [ "$VORTEX_ENABLE" = "false" ]  ; then
        BROWSER_LIMIT_MEM=$MEM_50_PCT  BIOREGISTER_LIMIT_MEM=$MEM_30_PCT  VORTEX_LIMIT_MEM=$MEM_00_PCT  TRAEFIK_LIMIT_MEM=$MEM_10_PCT	STACK_NAME=$BRO_STACK_NAME ENV=$ENV docker stack deploy --with-registry-auth  -c docker/stack/browser/browser.yml -c docker/stack/browser/browser-$ENV.yml $BRO_STACK_NAME

    elif [ "$BIOREGISTER_ENABLE" = "false" ] &&  [ "$VORTEX_ENABLE" = "true" ]  ; then
        BROWSER_LIMIT_MEM=$MEM_70_PCT  BIOREGISTER_LIMIT_MEM=$MEM_00_PCT  VORTEX_LIMIT_MEM=$MEM_10_PCT  TRAEFIK_LIMIT_MEM=$MEM_10_PCT	STACK_NAME=$BRO_STACK_NAME ENV=$ENV docker stack deploy --with-registry-auth  -c docker/stack/browser/browser.yml -c docker/stack/browser/browser-$ENV.yml $BRO_STACK_NAME
    else
        BROWSER_LIMIT_MEM=$MEM_80_PCT  BIOREGISTER_LIMIT_MEM=$MEM_00_PCT  VORTEX_LIMIT_MEM=$MEM_00_PCT  TRAEFIK_LIMIT_MEM=$MEM_10_PCT	STACK_NAME=$BRO_STACK_NAME ENV=$ENV docker stack deploy --with-registry-auth  -c docker/stack/browser/browser.yml -c docker/stack/browser/browser-$ENV.yml $BRO_STACK_NAME
        make ENV=$ENV scale_down_vortex
        make ENV=$ENV scale_down_bioregister
    fi


}

function set_up_configuration(){

    export BIOREGISTER_GROOVY=/efs/data/bioregister.groovy
    export BIOREGISTER_ZIP_COUNT=$(ls /efs/tmp/download_from_s3/bioregister-* | wc -l | xargs )
    export VORTEX_ZIP_COUNT=$(ls /efs/tmp/download_from_s3/vortexweb* | wc -l | xargs )

    export MEM_80_PCT=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024*80/100"m"}' )
    export MEM_70_PCT=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024*70/100"m"}' )
    export MEM_60_PCT=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024*60/100"m"}' )
    export MEM_50_PCT=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024*50/100"m"}' )
    export MEM_40_PCT=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024*40/100"m"}' )
    export MEM_30_PCT=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024*30/100"m"}' )
    export MEM_20_PCT=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024*20/100"m"}' )
    export MEM_10_PCT=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024*10/100"m"}' )
    export MEM_00_PCT=$(grep MemTotal /proc/meminfo | awk '{print $2 / 1024*0/100"m"}' )

    echo "$MEM_80_PCT" >  $PWD/target/mem80pct
    echo "$MEM_40_PCT" >  $PWD/target/mem40pct
    echo "$MEM_10_PCT" >  $PWD/target/mem10pct

    chown -R ec2-user:ec2-user $PWD/target

    if [ -f "BIOREGISTER_GROOVY" ] || [ "$BIOREGISTER_ZIP_COUNT" -eq 1  ] ; then
        export BIOREGISTER_ENABLE=true
    else
        export BIOREGISTER_ENABLE=false
    fi

    if [ "$VORTEX_ZIP_COUNT" -eq 1  ] ; then
       export VORTEX_ENABLE=true
    else
       export VORTEX_ENABLE=false
    fi
}

$*
