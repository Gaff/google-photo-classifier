#!/bin/bash
# bootstrap.sh

BUCKET_NAME="${GOOGLE_CLOUD_PROJECT}-terraform-state"
REGION="europe-west2"

# Create the state bucket
gcloud storage buckets create gs://${BUCKET_NAME} \
    --project=${GOOGLE_CLOUD_PROJECT} \
    --uniform-bucket-level-access \
    --public-access-prevention \
    --location=${REGION}

gcloud storage buckets update gs://${BUCKET_NAME} --versioning

