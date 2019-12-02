sudo chown ec2-user /home/ec2-user/App/
sudo chmod 777 /home/ec2-user/App/
sudo chmod 777 /home/ec2-user/App/backend/ 
cd /home/ec2-user/App/backend/ 

if [ "$(whoami)" != "ec2-user" ]; then
        echo "Script must be run as user: username"
        exit -1
fi

npm install 
npm install node-sass
npm audit fix
cd /home/ec2-user/App/backend/
npm start
