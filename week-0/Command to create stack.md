Command to create stack

aws cloudformation create-stack --stack-name MyFirstAWSStack --template-body file:..//week_0.yaml --parameters ParameterKey=EC2InstanceType,ParameterValue=t2.micro ParameterKey=EC2InstanceAmId,ParameterValue=ami-009c5f630e96948cb