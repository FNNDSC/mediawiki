#!/bin/bash
#Bash script to save and push to git the FNNDSC mediawiki

jour=$(date +%Y%m%d)
git add -A
git commit -m "Automatic daily save at $jour"
git push
