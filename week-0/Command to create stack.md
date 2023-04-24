Command to create stack with 1 EC2 Instance

aws cloudformation create-stack --stack-name MyFirstAWSStack --template-body file://week_0.yaml --parameters ParameterKey=InstanceType,ParameterValue=t2.micro ParameterKey=ImageId,ParameterValue=ami-009c5f630e96948cb 