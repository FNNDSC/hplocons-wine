#!/bin/sh -ex
cd /tmp
wget https://downloads.hpe.com/pub/softlib2/software1/pubsw-windows/p390407056/v138774/Setup.exe
wine Setup.exe
rm Setup.exe
