#!/bin/bash
#Bash script to install and powerup the FNNDSC mediawiki

echo "-------Initialization-------"

#echo "-------Git Large Files Storage install-------"
#sudo apt-get update
#sudo apt-get install git-lfs
#git lfs install

#echo "-------Pulling files latest files-------"
#git pull
#git fetch --all
#git reset --hard origin/master

#echo "-------Tracking larges files-------"
#sudo git-lfs track "wikidb/**"
#sudo git-lfs track "images/**"

echo "-------Creating Backup Crontab-------"
path=$(cd $( dirname ${BASH_SOURCE[0]}) && pwd )
chmod +x ./git-backup.sh
crontab -l | { cat; echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"; } | crontab -
crontab -l | { cat; echo "* * * * * $path/git-backup.sh"; } | crontab -
#If you have update issues, you can try to modify the crontab with
#crontab -l | { cat; echo "* * * * * sudo -u $(whoami) $path/git-backup.sh"; } | crontab -

echo "-------Powering the wiki with the dockers-------"
docker-compose up