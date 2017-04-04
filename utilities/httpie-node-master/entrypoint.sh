#!/bin/ash
echo "ARGUMENTS $@ for $BINARY";
if [ "$BINARY" == 'http' ]; then
    sh -c "http $*"
    exit 0;
fi

sh -c "node"
