#!/bin/bash

. ../config/config.sh
. ../common/common.sh

check_auth_user_with_role "$DOMAIN_ADMIN_USER" "domain admin"

declare -a users_array=($TRAINING_PARTICIPANTS)
for i in "${users_array[@]}"
do
    project_id=$(echo "${i//[^[:alpha:]]/}" | tr '[:upper:]' '[:lower:]' | awk '{print substr($0,0,20)}')
    project_id="$project_id-sandbox"

    echo "Enabling APIs for project [$project_id]"

    declare -a apis_array=($APIS_TO_ENABLE)
    for a in "${apis_array[@]}"
    do
        gcloud services enable "$a" --project="$project_id"
        if [ "$?" -ne 0 ]; then
            echo "ERROR: cloud enable API [$a] in project [$project_id]"
            exit 4
        fi
    done

done

echo "APIs successfully enabled."
