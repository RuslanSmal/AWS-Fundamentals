#!/bin/bash
touch week-2.txt

function createbucket()
   {
    aws s3 mb s3://week-2
    aws s3api put-bucket-versioning --bucket week-2 --versioning-configuration Status=Enabled
    aws s3 cp week-2.txt s3://week-2
   }

echo "Creating the AWS S3 bucket! "
echo ""
createbucket    # Calling the createbucket function  
echo "AWS S3 bucket week-2 created successfully"
