#!/bin/sh

# Start k3s service
systemctl start k3s.service

# Start LocalStack
localstack start --detached

# Create S3 state bucket
PROFILE="localstack"
REGION="eu-west-1"
BUCKET="waraq-terraform-state-$REGION"

aws --profile "$PROFILE" s3api create-bucket \
    --bucket "$BUCKET" \
    --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION"

aws --profile "$PROFILE" s3api put-bucket-versioning \
    --bucket "$BUCKET" \
    --versioning-configuration Status=Enabled