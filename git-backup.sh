#!/bin/bash
#Bash script to save and push to git the FNNDSC mediawiki
path=/neuro/labs/grantlab/research/mediawiki
jour=$(date +%Y%m%d)
#cd $path && docker-compose down
cd $path && git add -A
cd $path && git commit -m "Automatic daily save on $jour"
cd $path && git push
#cd $path && docker-compose up