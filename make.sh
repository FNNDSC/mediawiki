#!/bin/bash
# Bash script to install and powerup the FNNDSC mediawiki

SYNOPSIS="

NAME

        $0

ARGS

        [-L]
        
        Perform a github large file storage. This is useful if any individual
        files exceed 200MB.
        

DESCRIPTION

        $0 is a script that installs and runs the FNNDSDC mediawiki
        containerized.

"

function synopsis_show
{
        echo "$SYNOPSIS"
        exit 1
}

let Gb_largeFiles=0
let Gb_pull=0
let Gb_crontab=0

while getopts Lpcx option ; do
        case "$option"
        in
                L) Gb_largeFiles=1              ;;
                p) Gb_pull=1                    ;;
                c) Gb_crontab=1                 ;;
                x) synopsis_show                ;;
                \?) synopsis_show               ;;
        esac
done


echo "-------Initialization-------"

if (( Gb_largeFiles )) ; then 
        echo "-------Git Large Files Storage install-------"
        sudo apt-get update
        sudo apt-get install git-lfs
        git lfs install
fi 

if (( Gb_pull )) ; then 
        echo "-------Pulling files latest files-------"
        git pull
        git fetch --all
        git reset --hard origin/master
fi


if (( Gb_largeFiles )) ; then 
        echo "-------Tracking larges files-------"
        sudo git-lfs track "wikidb/**"
        sudo git-lfs track "images/**"
fi

if (( Gb_crontab )) ; then
        echo "-------Creating Backup Crontab-------"
        path=$(cd $( dirname ${BASH_SOURCE[0]}) && pwd )
        crontab -l | { cat; echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"; } | crontab -
        crontab -l | { cat; echo "* * * * * $path/git-backup.sh"; } | crontab -
        #If you have update issues, you can try to modify the crontab with
        #crontab -l | { cat; echo "* * * * * sudo -u $(whoami) $path/git-backup.sh"; } | crontab -
fi

echo "-------Powering the wiki with the dockers-------"
docker-compose up
