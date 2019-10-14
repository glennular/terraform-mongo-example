#!/bin/bash -ex

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo 'started\n'


echo -e "[mongodb]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/4.2/x86_64/
gpgcheck=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
enabled=1" | sudo tee /etc/yum.repos.d/mongodb.repo

# Update the packace indexes and install mongodb
#apt-get update && \
#sudo apt-get -y install mongodb-clients mongodb-server && \

sudo yum update -y

#hopefully by the time yum is done, the drive is mounted
# todo: add a wait for the mount
if [ "$(file -b -s /dev/xvdh)" == "data" ]; then
    mkfs.ext4 /dev/xvdh
fi

mkdir -p /data
mount /dev/xvdh /data
echo /dev/xvdh /data defaults,nofail 0 2 >> /etc/fstab
echo 'ebs mounted\n'

sudo yum install -y mongodb-org
sed -i -e "s,bindIp: 127.0.0.1,bindIp: 0.0.0.0,g" /etc/mongod.conf
sed -i -e "s,dbPath:.*$,dbPath: /data,g" /etc/mongod.conf

mkdir -p /data/db
sudo chown -R mongod:mongod /data/db

sudo service mongod restart 
wget --quiet https://raw.githubusercontent.com/mongodb/docs-assets/primer-dataset/primer-dataset.json
mongoimport --db example_data --collection restaurants --drop --file primer-dataset.json

echo $'ended\n' 
# Debug code in case you get the error - can not connect to mongodb from app server on command -> ruby app.rb
#sudo rm /var/lib/mongodb/mongod.lock && \
#sudo -u mongodb mongod -f /etc/mongodb.conf --repair && \
#sudo start mongodb

exit 0