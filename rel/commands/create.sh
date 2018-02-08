#! /bin/bash

# Database should have been created beforehand:
if [ -z $ECTO_PG_URL ];
then echo "ECTO_PG_URL env variable is not setted! interrupting process" && exit 2
fi

$RELEASE_ROOT_DIR/bin/crafters command Elixir.Crafters.ReleaseTasks create
