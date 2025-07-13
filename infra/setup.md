
* gcloud iam service-accounts create terraform-pipeline --display-name="Terraform Pipeline"
* gcloud projects add-iam-policy-binding GCP_PROJECT_ID --member="serviceAccount:terraform-pipeline@GCP_PROJECT_ID.iam.gserviceaccount.com" --role="roles/editor"
* gcloud iam service-accounts keys create key.json --iam-account=terraform-pipeline@GCP_PROJECT_ID.iam.gserviceaccount.com


Project settings -> environment -> secrets:
* GCP_PROJECT_ID
* GCP_SA_KEY
* TF_STATE_BUCKET

Run bootstrap.sh to create initial bucket.

