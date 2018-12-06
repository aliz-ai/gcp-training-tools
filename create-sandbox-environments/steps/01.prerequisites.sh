#!/bin/bash

. ../config/config.sh

gcloudVersion=$(gcloud --version 2>&1 | awk '/Google Cloud SDK/ {print $4}')

if [ "$gcloudVersion" \< "194.0" ]; then
    echo "ERROR: gcloud is not available or it's version is too old (must be at least 194.0, actual is: $gcloudVersion)"
    exit 1
elif [ "$pythonVersion" \< "2.7" ]; then
    echo "ERROR: python is not available or it's version is too old (must be at least 2.7, actual is: $pythonVersion)"
    exit 2
fi