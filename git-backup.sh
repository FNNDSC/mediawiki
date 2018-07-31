#!/bin/bash
# Bash script to save and push to git the FNNDSC mediawiki
pathscript=$(cd $( dirname ${BASH_SOURCE[0]}) && pwd )
logfile=/tmp/backup.log
date=$(date +%Y%m%d)
cd $pathscript && docker-compose down
echo -e "\n\n$jour" >> $logfile
echo -e "\n\n$pathscript" >> $logfile
echo "Adding files..." >>  $logfile
git -C $pathscript add -A >> $logfile
echo "Committing files..." >>  $logfile
git -C $pathscript commit -m "Automatic daily save on $date" >> $logfile
echo "Pushing files..." >>  $logfile
git -C $pathscript push origin master >> $logfile
echo "Done!" >>  $logfile
cd $pathscript && docker-compose up