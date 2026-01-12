#!/bin/sh

PROFILE="localstack"
REGION="eu-west-1"
BUCKET="waraq-terraform-state-$REGION"

aws --profile "$PROFILE" s3api create-bucket \
    --bucket "$BUCKET" \
    --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION" # this line is required only on localstack

aws --profile "$PROFILE" s3api put-bucket-versioning \
    --bucket "$BUCKET" \
    --versioning-configuration Status=Enabled