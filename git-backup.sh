#!/bin/bash
#Bash script to save and push to git the FNNDSC mediawiki
pathscript=/neuro/labs/grantlab/research/mediawiki
jour=$(date +%Y%m%d)
#cd $pathscript && docker-compose down
echo "test" >> /var/log/backuplog.log
git -C $pathscript add -A >> /var/log/backuplog.log
git -C $pathscript commit -m "Automatic daily save on $jour" >> /var/log/backuplog.log
git -C $pathscript push origin master >> /var/log/backuplog.log
ssh -T git@github.com >> /var/log/backuplog.log
#cd $pathscript && docker-compose up