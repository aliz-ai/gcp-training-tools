# Sandbox environment creation automation

This script utility generates sandbox projects for the training participants.

The tool can

1. Create a folder under the organization
2. Create a project for each participant under the previously created folder with ID: `<cleaned up user e-mail>-sandbox`
3. Link the specified billing account to the project
4. Enable the specified APIs for the labs

# Limitations

1. Currently there's no way to automate the budget setup on the projects, this should be done manually after the billing account assignment.
2. Adding external users as owner is not possible through gcloud commans, so all the necessary permissions should be enlisted in the configuration based on what services will be used during the training labs.

# Prerequisites

You only need to have the latest gcloud tool installed (with alpha features as well) and have some shell terminal.

# Check out this project

```bash

git clone https://github.com/aliz-ai/gcp-training-tools.git

```

# Configuration

Open the [config.sh](config/config.sh) file and edit the properties accordingly.

```bash

vim gcp-training-tools/create-sandbox-environment/config/config.sh

```

**Configurable properties:**

| Name | Description | Required / Optional | Example |
|------|-------------|---------------------|---------|
| DOMAIN | The GCP domain in which the projects should be created | Required | `example.com` |
| BILLING_ACCOUNT_ID | The ID of the billing account to be set for the projects | Required | `012345-6789AB-CDEEF01` |
| DOMAIN_ADMIN_USER | For folder creation, projects creation and other tasks except the billing account linking this user will be authenticated by the script. | Required | `admin@example.com` |
| BILLING_ADMIN_USER | This user will be authenticated to link billing account to the created sandbox project | Required | `billing@example.com` |
| TRAINING_FOLDER_NAME | The script creates this folder under the organization and the projects will be created under this folder | Required | `training-sandbox-projects` |
| TRAINING_PARTICIPANTS | The list of the participants separated by space. A project will be created for each participant. | Required | `participant1@example.com participant2@examplee.com` |
| PROJECT_ROLES | The roles to be assigned to the participant in his own project. The list of the roles depends on what services will be used during the training labs. | `Required` | `roles/editor roles/logging.privateLogViewer roles/logging.configWriter` |
| APIS_TO_ENABLE | The GCP APIs to enable after project creation. | `Required` | `bigquery-json.googleapis.com storage-component.googleapis.com storage-api.googleapis.com` |

# Run the scripts

1. Open a terminal and go into the steps directory:

```bash

cd gcp-training-tools/create-sandbox-environment/steps

```

2. Check the prerequisites with the following scripts:

```bash

./01.prerequisites.sh

```

2. Create the folder under your domain (make sure that you're folder admin on the domain level!).

```bash

./02.folder.create.sh

```

**NOTE:** the script won't do anything if this folder already exists.

3. Create the projects under the folder for each user and give them the required permissions:

```bash

./03.projects.create.sh

```

**NOTE:** the script is able to detect if the project already exists and won't fail. However, the permissions will be set at every run.

4. Set the billing accounts for the projects

```bash

./04.billing.account.link.sh

```

**NOTE:** if you're logged in with a different account than the configured billing admin account, the script will help you to login with the configured billing admin account.

5. Enable the necessary APIs on the projects

```bash

./05.apis.enable.sh

```

You're done.

# Tips

## Adding new user

If you want to add a new user without re-configuring everything just comment out the values of the `TRAINING_PARTICIPANTS` variable with `#` and replace the value with the single user. This way the other projects will be ignored, so the single project will be up and running much faster.