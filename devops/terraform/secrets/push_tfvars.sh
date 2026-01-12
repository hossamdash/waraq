#!/bin/bash

# This script uploads the untracked terraform.tfvars file to AWS Secrets Manager
# Use this to push sensitive variables that shouldn't be committed to git

set -e

# Configuration
SECRET_NAME="tf-secrets-terraform-tfvars"
TFVARS_FILE="terraform.tfvars"
AWS_REGION="eu-west-1"
AWS_PROFILE="localstack"

# Check if secret exists
if aws secretsmanager describe-secret --secret-id "$SECRET_NAME" --region "$AWS_REGION" --profile "$AWS_PROFILE" &>/dev/null; then
  echo "Secret exists, updating..."
  aws secretsmanager put-secret-value \
    --secret-id "$SECRET_NAME" \
    --secret-string "file://$TFVARS_FILE" \
    --region "$AWS_REGION" \
    --profile "$AWS_PROFILE"
else
  echo "Secret does not exist, creating..."
  aws secretsmanager create-secret \
    --name "$SECRET_NAME" \
    --description "Secrets workspace Terraform variables" \
    --secret-string "file://$TFVARS_FILE" \
    --region "$AWS_REGION" \
    --profile "$AWS_PROFILE" \
    --tags Key=used_in,Value=terraform Key=workspace,Value=secrets Key=managed_by,Value=terraform Key=env,Value=shared
fi

echo "✓ $SECRET_NAME updated"
