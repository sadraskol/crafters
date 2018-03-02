#! /bin/bash

if [ -z $PORT ];
then echo "PORT env variable is not setted! interrupting process" && exit 1
fi

$RELEASE_ROOT_DIR/bin/crafters create
$RELEASE_ROOT_DIR/bin/crafters migrate
$RELEASE_ROOT_DIR/bin/crafters foreground
