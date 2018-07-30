#!/bin/bash
#Bash script to save and push to git the FNNDSC mediawiki
pathscript=/neuro/labs/grantlab/research/mediawiki
jour=$(date +%Y%m%d)
#cd $pathscript && docker-compose down
cd $pathscript && git add -A > /var/log/backuplog.log
cd $pathscript && git commit -m "Automatic daily save on $jour" > /var/log/backuplog.log
cd $pathscript && git push > /var/log/backuplog.log
#cd $pathscript && docker-compose up