# Determine our working directory in the base of the repo
TOP := $(dir $(lastword $(MAKEFILE_LIST)))
ROOT = $(realpath $(TOP))

# Set our gopath to the repo base (which will pick up src)
# as well as the go_workspace folder within our repo
GOPATH=$(ROOT):$(ROOT)/go_workspace
export GOPATH

# Please change this to your Google Cloud Project Name
PROJECT=changeme
# This can be used for a larger-company setup where you have a dev 
# and production env
ENV=dev
# You may or may not want to save your app engine data here.
# I like having it NOT in /tmp/ because I don't want my gae data
# wiped on reboot
TMPDATA = ~/tmp/gae-$(PROJECT)/

# If you have multiple gae projects, you might need to change these so they
# don't conflict
PORT=8900
ADMIN_PORT=8800

# This probably isn't necessary but in case you want to provide a
# absolute path or something
DEV_APP_BIN="dev_appserver.py"

# Run the local dev server (dev_appserver.py) to simulate app engine
run:
	mkdir -p $(TMPDATA)
	$(DEV_APP_BIN) --storage_path=$(TMPDATA) --port=$(PORT) --admin_port=$(ADMIN_PORT) --skip_sdk_update_check=true ./server/app.yaml

# Deploy our project to Google App Engine using the gcloud command.
# You must have set up your project first (see article)
deploy:
	gcloud app deploy -q --project $(PROJECT) --verbosity=info ./server/app.yaml

# The following is an example of how you could make a deploy_prod
# command to deploy to a different GCP Project than the default
# deploy_prod: PROJECT=prod-changeme
# deploy_prod: deploy