#!/bin/sh

SOCKET=/var/run/apps/truckinfo/app.pid
EXEC=/home/mantovani/apps/TruckInfo/script/truckinfo_fastcgi.pl 
if [ -f $SOCKET ] ; then
        fuser -k $SOCKET
fi

CATALYST_DEBUG=0 perl $EXEC -l $SOCKET -n 1 -d
