#!/bin/bash
#Bash script to make the mediawiki

#echo "-------Git Large Files Storage install-------"
#need? curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
#sudo apt-get update
#sudo apt-get install git-lfs
#git lfs install

echo "-------Pulling files-------"
git pull

#echo "-------Tracking larges files-------"
#sudo git-lfs track "wikidb/**"
#sudo git-lfs track "images/**"

echo "-------Creating Backup Crontab-------"
crontab -l | { cat; echo "*/5 * * * * bash git-backup.sh"; } | crontab -

echo "-------Powering the wiki with the dockers-------"
docker-compose up
