#!/bin/bash
# parameters: BE: backend only, FE: frontend only
cd "$(dirname "$0")"

source ./run_options.sh

if [ -e $1 ] 
then 
    SCOPE="BEFE"
else
    SCOPE=$1
fi

cd ..

if [ $SCOPE == BE  ] 
then
    echo "Skipping frontend"
else
    echo "LOADING STATIC CONTENT TO: " $STATIC_CONTENT_PATH

    echo "SYNCING STATIC CONTENT"
    sudo mkdir -p $STATIC_CONTENT_PATH
    sudo setfacl -m $NGINX_USER:rwx -R $STATIC_CONTENT_PATH
    sudo rsync -r frontends/ $STATIC_CONTENT_PATH
    sudo chown -R nginx $STATIC_CONTENT_PATH

    echo "Webpage will be accessible at " $STATIC_CONTENT_URL

fi

#echo "RESTARTING nginx"
#service nginx restart

if [ $SCOPE = FE ]
then
    echo "Skipping backend"
else
    cd backends/booking/service
    JAVA_HOME=$JAVA_HOME_DIR ./mvnw spring-boot:run
fi
