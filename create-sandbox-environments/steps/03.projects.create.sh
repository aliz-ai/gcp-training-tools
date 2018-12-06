#!/bin/bash

. ../config/config.sh
. ../common/common.sh

check_auth_user_with_role "$DOMAIN_ADMIN_USER" "domain admin"

org_id=$(gcloud organizations list 2>&1 |awk '/'"$DOMAIN"'/ {print $2}')
if [ -z "$org_id" ]; then
    echo "ERROR: no organization ID found for domain: [$DOMAIN]";
    exit 1
fi

folder_id=$(gcloud alpha resource-manager folders list --organization=$org_id | awk '/'"$TRAINING_FOLDER_NAME"'/  {print $3}')
if [ -z "$folder_id" ]; then
    echo "ERROR: could not get the ID of training folder: [$TRAINING_FOLDER_NAME]"
    exit 2
fi

declare -a users_array=($TRAINING_PARTICIPANTS)
for i in "${users_array[@]}"
do
    project_id=$(echo "${i//[^[:alpha:]]/}" | tr '[:upper:]' '[:lower:]' | awk '{print substr($0,0,20)}')
    project_id="$project_id-sandbox"
    ex_project=$(gcloud projects describe "$project_id" 2>&1)
    if [ "$?" -ne 0 ]; then
        echo "Creating project [$project_id]..."
        gcloud projects create "$project_id" --folder="$folder_id"
        if [ "$?" -ne 0 ]; then
            echo "ERROR: could not create project [$project_id]!"
            exit 3
        fi
    else
        echo "Project [$project_id] already exists - skipping project creation..."
    fi

    declare -a roles_array=($PROJECT_ROLES)
    for r in "${roles_array[@]}"
    do
        gcloud projects add-iam-policy-binding "$project_id" --member="user:$i" --role="$r"
        if [ "$?" -ne 0 ]; then
            echo "ERROR: cloud not assign role [$r] to user [$i] in project [$project_id]"
            exit 4
        fi
    done

done

echo "Project creation successfully completed!"