#/bin/sh

# Node Requirments
sudo yum update -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

. ~/.nvm/nvm.sh

nvm install node -y

mkdir /home/ec2-user/logs

node -e "console.log('Running Node.js ' + process.version)" >> /home/ec2-user/logs/node_status.log


# AWS CodeDeploy Agent installaation
sudo yum install ruby -y

sudo yum install wget -y

cd /home/ec2-user

wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install

chmod +x ./install

sudo ./install auto

sudo service codedeploy-agent status

sudo service codedeploy-agent start

sudo service codedeploy-agent status >> /home/ec2-user/logs/code_deploy_status.log