#!/bin/bash
#Bash script to save and push to git the FNNDSC mediawiki

jour=$(date +%Y%m%d)

cd /neuro/labs/grantlab/research/mediawiki && git add -A
cd /neuro/labs/grantlab/research/mediawiki && git commit -m "aaaAutomatic daily save at $jour"
cd /neuro/labs/grantlab/research/mediawiki && git push
