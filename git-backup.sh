#!/bin/bash
#Bash script to save and push to git the FNNDSC mediawiki
pathscript=/neuro/labs/grantlab/research/mediawiki
logfile=/tmp/backup.log
jour=$(date +%Y%m%d)
cd $pathscript && docker-compose down
echo -e "\n\n$jour" >> $logfile
echo "Adding files..." >>  $logfile
git -C $pathscript add -A >> $logfile
echo "Committing files..." >>  $logfile
git -C $pathscript commit -m "Automatic daily save on $jour" >> $logfile
echo "Pushing files..." >>  $logfile
git -C $pathscript push origin master >> $logfile
echo "Done!" >>  $logfile
cd $pathscript && docker-compose up