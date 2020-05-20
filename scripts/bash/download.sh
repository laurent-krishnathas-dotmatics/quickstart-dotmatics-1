#!/bin/sh
# ------------------------------------------------------------------
# [Lucas Ko]
#
# Download and update bioregister.groovy
# ------------------------------------------------------------------

VERSION=0.1.0
SUBJECT=download-bioregister


USAGE=$(cat  << EOF
Usage:	download [SERVICES] \n\n

download bioregister.groovy and update it to running container

Servics: \n
\tbioregister   \t    download bioregister.groovy from S3 to running container \n

EOF
)



# --- Options processing -------------------------------------------
if [ $# == 0 ] ; then
    echo -e $USAGE
    exit 1;
fi

while getopts ":i:vh" optname
  do
    case "$optname" in
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "i")
        echo "-i argument: $OPTARG"
        ;;
      "h")
        echo $USAGE
        exit 0;
        ;;
      "?")
        echo "Unknown option $OPTARG"
        exit 0;
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        exit 0;
        ;;
      *)
        echo "Unknown error while processing options"
        exit 0;
        ;;
    esac
  done

shift $(($OPTIND - 1))

param1=$1

# --- Locks -------------------------------------------------------
LOCK_FILE=/tmp/$SUBJECT.lock
if [ -f "$LOCK_FILE" ]; then
   echo "Script is already running"
   exit
fi

trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE


# --- Function --------------------------------------------------------
function upload_browser_properties(){

    echo "binary files in s3://$P_INSTALL_BUCKET_NAME/$P_INSTALL_BUCKET_PREFIX/"
    aws s3 ls s3://$P_INSTALL_BUCKET_NAME/$P_INSTALL_BUCKET_PREFIX/

    echo -e "\nbackup browser.properties ..."
    export BACKUP_DATE=$(date +'%Y-%m%d-%Hh%M')
    aws s3 cp s3://$P_INSTALL_BUCKET_NAME/$P_INSTALL_BUCKET_PREFIX/browser.properties  s3://$P_INSTALL_BUCKET_NAME/$P_INSTALL_BUCKET_PREFIX/backup/$BACKUP_DATE/ || true

    echo "\nuploading browser.properties from EC2 to S3 ..."
    if [ -f "$EFS_BROWSER_PROPERTIES" ] ; then
        aws s3 cp $EFS_BROWSER_PROPERTIES  s3://$P_INSTALL_BUCKET_NAME/$P_INSTALL_BUCKET_PREFIX/browser.properties

        aws s3 ls s3://$P_INSTALL_BUCKET_NAME/$P_INSTALL_BUCKET_PREFIX/

        echo -e "\nbrowser.properties on EC2 has been uploaded to s3://$P_INSTALL_BUCKET_NAME/$P_INSTALL_BUCKET_PREFIX/browser.properties"
    else
        echo -e "$EFS_BROWSER_PROPERTIES not found"
        exit 0;
    fi


}

function upload_bioregister_groovy(){
    echo "uploading bioregister.groovy ..."
}

function check_env_configuration(){

if [ -z "$P_INSTALL_BUCKET_NAME" ]; then
    echo "[ERROR] P_INSTALL_BUCKET_NAME env variable is empty, please specify a bucket name"
    exit 0 ;

elif [ -z "$P_INSTALL_BUCKET_PREFIX" ]; then
    echo "[ERROR] P_INSTALL_BUCKET_PREFIX env variable is empty, please specify a prefix key"
    exit 0 ;

elif [ -z "$EFS_BROWSER_PROPERTIES" ]; then
    echo "[ERROR] EFS_BROWSER_PROPERTIES env variable is empty, please specify a path of browser.properties"
    exit 0 ;

fi

}


# --- Body --------------------------------------------------------

check_env_configuration

#  SCRIPT LOGIC GOES HERE
#echo param1=$param1

if [ "browser" = $param1 ]; then
    upload_browser_properties

elif [ "bioregister" = $param1 ]; then
    upload_bioregister_groovy

elif [ "all" = $param1 ]; then
    upload_browser_properties
    upload_bioregister_groovy

else
    echo "invalid service '$param1'"
    exit 0;
fi


# -----------------------------------------------------------------
