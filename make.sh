#!/bin/bash
#Bash script to install and powerup the FNNDSC mediawiki

#echo "-------Git Large Files Storage install-------"
#need? curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
#sudo apt-get update
#sudo apt-get install git-lfs
#git lfs install

echo "-------Pulling files-------"
git pull
git fetch --all
git reset --hard origin/master

#echo "-------Tracking larges files-------"
#sudo git-lfs track "wikidb/**"
#sudo git-lfs track "images/**"

echo "-------Creating Backup Crontab-------"
crontab -l | { cat; echo "00 03 * * * bash git-backup.sh"; } | crontab -

echo "-------Powering the wiki with the dockers-------"
docker-compose up
