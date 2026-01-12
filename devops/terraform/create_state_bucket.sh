#!/bin/sh

aws --profile localstack s3api create-bucket \
    --bucket waraq-terraform-state-eu-west-1 \
    --region eu-west-1 \
    --create-bucket-configuration LocationConstraint=eu-west-1 # this line is required only on localstack