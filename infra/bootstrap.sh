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





# WIF: (didn't get it to work!)

# Enable APIs:
#    Identity and Access Management (IAM) API
#    Cloud Resource Manager API
#    IAM Service Account Credentials API
#    Security Token Service API


gcloud iam workload-identity-pools create "github-pool" \
    --project="${GOOGLE_CLOUD_PROJECT}" \
    --location="global" \
    --display-name="GitHub Pool"

gcloud iam workload-identity-pools describe "github-pool" \
    --project="${GOOGLE_CLOUD_PROJECT}" --location="global" \
    --format="value(name)"

gcloud iam workload-identity-pools providers create-oidc "github-provider" \
    --project="${GOOGLE_CLOUD_PROJECT}"   --location="global"   --workload-identity-pool="github-pool"   \
    --display-name="GitHub Provider"   --issuer-uri="https://token.actions.githubusercontent.com"   \
    --attribute-mapping="google.subject=assertion.sub" --attribute-condition="assertion.repository=='Gaff/google-photo-classifier'"