#!/bin/bash

check_auth_user_with_role() {
    USER="$1"
    ROLE="$2"
    current_account=$(gcloud config list account --format "value(core.account)")

    if [ "$current_account" != "$USER" ]; then
        echo "WARNING - you are currently not signed in with your $ROLE user [$USER]"
        echo "The system is going to ask you to login with that account."
        read -p "Please press ENTER to contiune..."
        gcloud auth login || (echo "Login failed - exiting!" && exit 1)

        current_account=$(gcloud config list account --format "value(core.account)")
        if [ "$current_account" != "$USER" ]; then
            echo "Login failed - exiting!"
            exit 1
        fi
    fi
}