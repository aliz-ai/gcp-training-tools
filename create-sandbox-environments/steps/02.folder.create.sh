#!/bin/bash

. ../config/config.sh
. ../common/common.sh

check_auth_user_with_role "$DOMAIN_ADMIN_USER" "domain admin"

org_id=$(gcloud organizations list 2>&1 |awk '/'"$DOMAIN"'/ {print $2}')
if [ -z "$org_id" ]; then
    echo "ERROR: no organization ID found for domain: [$DOMAIN]";
    exit 1
fi

existing_folder=$(gcloud alpha resource-manager folders list --organization=$org_id | awk '/'"$TRAINING_FOLDER_NAME"'/  {print $1}')
if [ "$existing_folder" != "$TRAINING_FOLDER_NAME" ]; then
    echo "Folder [$TRAINING_FOLDER_NAME] does not exist, creating..."
    gcloud alpha resource-manager folders create --display-name "$TRAINING_FOLDER_NAME" --organization=$org_id
    if [ "$?" -ne 0 ]; then
        echo "ERROR: could not create folder: [$DOMAIN_ADMIN_USER]"
        exit 2
    fi
fi