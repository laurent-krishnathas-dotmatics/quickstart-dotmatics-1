#!/bin/bash
# @author Laurent Krishnathas
# @year 2018

set -e
set -u
set -x

if [ -d "/config" ]; then
    ls -la /config
fi
mkdir -p $CATALINA_HOME/webapps/browser
if ls $BROWSER_ZIP_FILE 1> /dev/null 2>&1; then
  echo "files do exist"
  unzip  -qq $BROWSER_ZIP_FILE -d $CATALINA_HOME/webapps/browser
else
    echo "$BROWSER_ZIP_FILE do not exist"
fi

SRC_FILE=$BROWSER_PROP_FILE
FILE=browser.properties
if [ -f "$SRC_FILE" ]; then
    mv -f $CATALINA_HOME/webapps/browser/WEB-INF/$FILE $CATALINA_HOME/webapps/browser/WEB-INF/${FILE}_backup || true
    ln -s $SRC_FILE $CATALINA_HOME/webapps/browser/WEB-INF/$FILE
fi


SRC_FILE=$BROWSER_LICENSE_FILE
FILE=dotmatics.license.txt
if [ -f "$SRC_FILE" ]; then
    mv -f $CATALINA_HOME/webapps/browser/WEB-INF/$FILE $CATALINA_HOME/webapps/browser/WEB-INF/${FILE}_backup || true
    ln -s $SRC_FILE $CATALINA_HOME/webapps/browser/WEB-INF/$FILE
fi

chown -R tomcat:tomcat $CATALINA_HOME
chmod -R u-w  $CATALINA_HOME/conf
chmod -R u-w  $CATALINA_HOME/bin


su -c "$CATALINA_HOME/bin/catalina.sh run" -s /bin/sh tomcat
