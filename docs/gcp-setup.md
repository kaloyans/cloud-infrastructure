# GCP Setup Guide

Step-by-step instructions for setting up the required GCP prerequisites before running Terraform.

---

## 1. Install Required Tools

```bash
# Install Google Cloud SDK
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init

# Install Terraform
brew install terraform        # macOS
# or
apt-get install terraform     # Ubuntu/Debian
```

---

## 2. Create a GCP Project

```bash
# Create new project
gcloud projects create my-project-id --name="My Infrastructure"

# Set as active project
gcloud config set project my-project-id

# Enable billing (required for compute resources)
# Go to: https://console.cloud.google.com/billing
```

---

## 3. Enable Required APIs

```bash
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable monitoring.googleapis.com
```

---

## 4. Create a Service Account

```bash
# Create service account
gcloud iam service-accounts create terraform-sa \
    --display-name="Terraform Service Account"

# Grant Editor role
gcloud projects add-iam-policy-binding my-project-id \
    --member="serviceAccount:terraform-sa@my-project-id.iam.gserviceaccount.com" \
    --role="roles/editor"

# Download credentials key
gcloud iam service-accounts keys create ~/terraform-key.json \
    --iam-account=terraform-sa@my-project-id.iam.gserviceaccount.com

# Set credentials environment variable
export GOOGLE_APPLICATION_CREDENTIALS=~/terraform-key.json
```

---

## 5. Create Terraform State Bucket

```bash
# Create GCS bucket for Terraform state
gsutil mb -p my-project-id -l europe-west3 gs://my-project-terraform-state

# Enable versioning
gsutil versioning set on gs://my-project-terraform-state
```

---

## 6. Configure and Apply Terraform

```bash
# Clone the repo
git clone https://github.com/kaloyans/cloud-infrastructure
cd cloud-infrastructure/gcp

# Create tfvars file
cat > terraform.tfvars <<EOF
project_id = "my-project-id"
region     = "europe-west3"
zone       = "europe-west3-a"
environment = "prod"
EOF

# Initialise
terraform init

# Preview
terraform plan

# Apply
terraform apply
```

---

## 7. Clean Up

```bash
# Destroy all resources when no longer needed
terraform destroy
```

---

## Notes

- Always run `terraform plan` before `terraform apply`
- Store `terraform.tfvars` in `.gitignore` — never commit credentials
- Use `terraform destroy` to avoid unexpected GCP costs
