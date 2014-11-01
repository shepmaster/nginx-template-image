#!/bin/bash

APPNAME=nginx-template-image
CONTAINERNAME=nginx
HOSTFOLDER=/home/core/$CONTAINERNAME
GISTURL=https://api.github.com/repos/Noirvisch/nginx-template-image/tarball
TARFOLDER=Noirvisch-nginx-template-image\*
VERSION=0.1.2
LINKS="--link drone-ci:drone"

USAGE="$0 <COMMAND>\n
\n
Available commands:\n
  download  download all necessary files to the $HOSTFOLDER folder\n
  build     Builds the docker container removing the old one\n
  service   Install a systemd unit to autostart the docker container\n
  run       Run the docker container (setting up all the connected files)"

case $1 in
  download)
    echo "Creating folder $HOSTFOLDER"
    mkdir -p $HOSTFOLDER
    cd $HOSTFOLDER
    echo "Downloading files:"
    curl -o download -L $GISTURL
    if [ $? -ne 0 ]; then
      echo "Failed to download: $retval"
      exit 1
    fi
    echo "unpacking"
    mkdir /tmp/dirtree
    tar -xf download -C /tmp/dirtree
    if [ $? -ne 0 ]; then
      echo "Failed to unpack: $retval"
      exit 2
    fi
	cp -rf /tmp/dirtree/${TARFOLDER}*/* .
    rm -f download
	rm -rf /tmp/dirtree
    chmod +x *.sh
    echo "done"
    ;;

  run)
    # custom first run scripting
    cd $HOSTFOLDER
    RUNNING=`docker ps -a | grep "$CONTAINERNAME" | wc -l`
    if [ $RUNNING -ne "0" ]; then
      echo "$CONTAINERNAME has already been started once."
      exit 1
    fi
    echo "Starting drone docker..."
    docker run -d --name="$CONTAINERNAME" -p 80:80 -p 443:443 -v $HOSTFOLDER/templates/:/etc/nginx/sites-templates/ $LINKS noirvisch/$APPNAME:$VERSION
    ;;
    
  build)
    if [ ! -e Dockerfile ]; then
      echo "You first need to download the Dockerfile. Try: $0 download"
      exit 1
    fi
    docker build -t noirvisch/$APPNAME:$VERSION .
    ;;
    
  help)
    echo -e $USAGE
    ;;
  *)
    echo "Unknown command: $1"
    echo -e $USAGE
    exit 1
    ;;
esac

exit 0
