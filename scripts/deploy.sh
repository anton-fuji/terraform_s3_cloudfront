#!/bin/bash

# Disable terraform pager output
export PAGER=''

pushd infra
    terraform init
    terraform apply --auto-approve

    BUCKET_NAME=$(terraform output -raw bucket_name)
    CLOUDFRONT_DISTRIBUTION_ID=$(terraform output -raw cloudfront_distribution_id)
    CLOUDFRONT_DISTRIBUTION_DOMAIN_NAME=$(terraform output -raw cloudfront_domain_name)
popd

echo "AWS infrastructure deployment completed successfully."
echo "S3 Bucket Name: $(cat .bucket_name)"
echo "CloudFront Distribution ID: $(cat .cloudfront_distribution_id)"
echo "CloudFront Domain Name: $(cat .cloudfront_domain_name)"
echo "GitHub Actions Deployer Role ARN: $(cat .github_actions_deployer_role_arn)"

# copy all the files in public to the s3 bucket
# aws s3 cp public/ "s3://${BUCKET_NAME}/" --recursive

# # invalidate the cloudfront distribution
# aws cloudfront create-invalidation \
#     --distribution-id ${CLOUDFRONT_DISTRIBUTION_ID} \
#     --paths "/*"

# # print the url of the website
# echo "https://${CLOUDFRONT_DISTRIBUTION_DOMAIN_NAME}"
