#!/bin/bash

. ../config/config.sh
. ../common/common.sh

check_auth_user_with_role "$BILLING_ADMIN_USER" "billing admin"

declare -a users_array=($TRAINING_PARTICIPANTS)
for i in "${users_array[@]}"
do
    project_id=$(echo "${i//[^[:alpha:]]/}" | tr '[:upper:]' '[:lower:]' | awk '{print substr($0,0,20)}')
    project_id="$project_id-sandbox"

    echo "Configuring billing account [$BILLING_ACCOUNT_ID] for  project [$project_id]..."
    gcloud alpha billing projects link "$project_id" --billing-account "$BILLING_ACCOUNT_ID"
    if [ "$?" -ne 0 ]; then
        echo "ERROR: could not set billing account [$BILLING_ACCOUNT_ID] for  project [$project_id]"
        exit 1
    fi
done



echo "Billing account is now successfully assigned to the sandbox projects."
echo "WARNING: it's highly recommended to set up a \$100 budget for all of the projects in folder [$TRAINING_FOLDER_NAME]. At the time of writing the budget setup is not supported programmatically."
