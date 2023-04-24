Command to create stack with 1 EC2 Instance

aws cloudformation create-stack --stack-name MyFirstAWSStack --template-body file://week_0.yaml --parameters ParameterKey=InstanceType,ParameterValue=t2.micro ParameterKey=ImageId,ParameterValue=ami-02d5619017b3e5162 