#!/bin/sh
# Create and initialize a context management database
#
if [ -f ctxstore.db ] ; then
    echo "Database ctxstore already exists."
    exit 1
fi
#
echo "Creating empty database..."
prodb ctxstore empty

echo "Adding pagefile space..."
echo 'd "Context-page-file":11,32;64 .' > ctxstore_pagefile.st
prostrct add ctxstore ctxstore_pagefile.st
prostrct list ctxstore

echo "Adding context management schema ... "
$DLC/bin/_progres -b -p loaddf.p -param "ctxstore.df" -db ctxstore -1

echo "Adding administration ..."
echo "   TBD"

echo "Adding access controls ..."
echo "   TBD"


