#!/bin/bash

pushd infra
  terraform init

  BUCKET_NAME=$(terraform output -raw bucket_name)

  aws s3 rm "s3://${BUCKET_NAME}/" --recursive

  terraform destroy --auto-approve
popd