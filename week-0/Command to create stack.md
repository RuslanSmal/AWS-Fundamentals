Command to create stack with 1 EC2 Instance

week-0
aws cloudformation create-stack --stack-name MyFirstAWSStack --template-body file://week_0.yaml --parameters ParameterKey=InstanceType,ParameterValue=t2.micro ParameterKey=ImageId,ParameterValue=ami-02d5619017b3e5162 

week-1
aws cloudformation create-stack --stack-name week1 --template-body file://week-1.yaml --parameters ParameterKey=InstanceType,ParameterValue=t2.micro ParameterKey=ImageId,ParameterValue=ami-02d5619017b3e5162 ParameterKey=KeyName,ParameterValue=MyKeyPair