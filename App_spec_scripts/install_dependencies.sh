sudo mkdir logs
sudo chmod 777 /home/ec2-user/logs
sudo chmod 777 /home/ec2-user/App/ 
sudo chmod 777 /home/ec2-user/App/backend/ >> /home/ec2-user/logs/logs1.txt
cd /home/ec2-user/App/backend/
npm install >> /home/ec2-user/logs/logs2.txt
npm install node-sass >> /home/ec2-user/logs/logs3.txt
npm audit fix >> /home/ec2-user/logs/logs4.txt
