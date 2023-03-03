#!/bin/bash
cd "$(dirname "$0")"


if [ -e $1 ] || [ -e $2 ]
then
    echo USAGE
    echo "run_remote.sh user@host directory [optios_script.sh] [BE/FE]"
    echo will run remotely on given host and directory with given startup
    echo script. If no script given, default run_options.sh will be used
fi

HOST=$1
REMOTE_DIR=$2
BEFE=FE

echo PREPARING remote directory $REMOTE_DIR on $HOST 

ssh $HOST "mkdir -p $REMOTE_DIR"
if [ $? ]
then
    echo mkdir failed
fi
rsync -r ../ $HOST:$REMOTE_DIR
if [ $? ]
then
    echo rsync failed
fi

echo RUNNING remotely $REMOTE_DIR/scripts/run_local.sh

ssh -t $HOST $REMOTE_DIR/scripts/run_local.sh $BEFE

