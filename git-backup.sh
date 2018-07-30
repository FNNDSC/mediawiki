#!/bin/bash
#Bash script to save and push to git the FNNDSC mediawiki
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
pathscript=/neuro/labs/grantlab/research/mediawiki
jour=$(date +%Y%m%d)
#cd $path && docker-compose down
cd $pathscript && git add -A
cd $pathscript && git commit -m "Automatic daily save on $jour"
cd $pathscript && git push
#cd $path && docker-compose up