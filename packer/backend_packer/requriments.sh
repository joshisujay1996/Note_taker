#/bin/sh

# Setup for Mongo
sudo chmod 777 /etc/yum.repos.d
sudo echo $'[mongodb-org-4.0]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/4.0/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-4.0.asc' >> /etc/yum.repos.d/mongodb-org-4.0.repo

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

# Mongo Db installitation
cd /home/ec2-user

sudo chmod +x /etc/yum.repos.d/mongodb-org-4.0.repo

sudo yum -y install mongodb-org

sudo service mongod start 

