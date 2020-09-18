#!/bin/bash

set -e

if [ -z $PROJECT_ID ]
then
  echo "Please supply the 'PROJECT_ID' environment variable for your GCP Project ID"
  echo "e.g."
  echo "export PROJECT_ID=myproject"
  exit 1
fi

if [ -z $CLUSTER_NAME ]
then
  echo "Please supply the 'CLUSTER_NAME' environment variable for your GKE cluster name"
  echo "e.g."
  echo "export CLUSTER_NAME=mycluster"
  exit 1
fi

echo "this script modifies the `dirname "$0"`/setenv.sh file..."

sed -i -e "s/PROJECT_ID=\".*\"/PROJECT_ID=\"${PROJECT_ID}\"/" `dirname "$0"`/setenv.sh
sed -i -e "s/CLUSTER_NAME=\".*\"/CLUSTER_NAME=\"${CLUSTER_NAME}\"/" `dirname "$0"`/setenv.sh

echo "modifying local boot service account so that it is configured with Googles Workload Identity"
echo "please git add, commit and push the local changes"

jx gitops annotate --dir .jx/git-operator/resources --kind ServiceAccount iam.gke.io/gcp-service-account=${CLUSTER_NAME}-boot@${PROJECT_ID}.iam.gserviceaccount.com


