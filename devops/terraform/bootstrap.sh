#!/bin/sh

# Start k3s service (lightweight Kubernetes)
sudo systemctl start k3s.service

# Start LocalStack
localstack start --detached

# Wait for LocalStack to be fully up and running
sleep 5

# Create terraform S3 state bucket each time as localstack free version does not support persistence

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