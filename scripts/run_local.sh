#!/bin/bash

source ./run_options.sh



cd ..

echo "LOADING STATIC CONTENT TO: " $STATIC_CONTENT_PATH


echo "SYNCING STATIC CONTENT"
sudo mkdir -p $STATIC_CONTENT_PATH
sudo setfacl -m $NGINX_USER:rwx -R $STATIC_CONTENT_PATH
sudo rsync -r frontends/ $STATIC_CONTENT_PATH
sudo chown -R nginx $STATIC_CONTENT_PATH
cd backends/booking/fcgi-cpp
make

#echo "RESTARTING nginx"
#service nginx restart

echo "RUNNING fcgi-main"
echo "Webpage will be accessible at " $STATIC_CONTENT_URL
spawn-fcgi -p $FCGI_PORT -n fcgi-main

