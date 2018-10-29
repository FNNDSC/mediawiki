#!/bin/bash
# Bash script to save and push to git the FNNDSC mediawiki

SYNOPSIS="

NAME

        $0

ARGS

        [-c] COMMIT
        Specify the commit you want to right on your backup

        [-s]
        Run the backup to the FNNDSC github repository without shutting down the wiki.
        NOTE: If the wiki is running, you should use ./git-backup.sh -R 
        instead of -S

        [-a]
        This arguments is only for the automatic daily save purpose.
        You should not use it.


DESCRIPTION

        $0 is a script that shutdown the wiki, run the backup 
        on the FNNDSC github repository and power up the wiki again. 
        NOTE: To run this script you must run with a [-c] arguments.

        A log file is available in /tmp/backup.log

EXAMPLE
        
        ./git-backup -c \"Voici mon commit\"

"

function synopsis_show
{
        echo "$SYNOPSIS"
        exit 1
}

let Gb_commit=0
let Gb_saveNOshutdown=0
let Gb_saveauto=0

while getopts ac:sx option ; do
        case "$option"
        in
                a) Gb_saveauto=1                ;;
                c) Gb_commit=1
                commit=$OPTARG                  ;;
                s) Gb_saveNOshutdown=1          ;;
                x) synopsis_show                ;;
                \?) synopsis_show               ;;
        esac
done


pathscript=$(cd $( dirname ${BASH_SOURCE[0]}) && pwd )
logfile=/tmp/backup.log
date=$(date +%Y%m%d)

if (( Gb_saveauto )) ; then 
        commit="Automatic daily save on $date"
        echo "Auto daily save" >> $logfile
else
        echo "Manual save" >> $logfile 
fi


if (( Gb_commit )) ||  (( Gb_saveauto )); then 

        if (( Gb_saveNOshutdown == 0)) ; then 
                cd $pathscript && docker-compose down
                echo -e "Save with shutdown\n" >> $logfile
        else
                echo -e "Save without shutdown\n" >> $logfile
        fi
        echo -e "Date = $date" >> $logfile
        echo -e "Path = $pathscript" >> $logfile
        echo -e "Commit = $commit\n" >> $logfile

        export SSH_AGENT_PID=`ps -a | grep ssh-agent | grep -o -e [0-9][0-9][0-9][0-9]`
        export SSH_AUTH_SOCK=`find /tmp/ -path '*keyring-*' -name '*ssh*' -print 2>/dev/null`


        echo "Adding files..." >> $logfile
        git -C $pathscript add -A >> $logfile
        echo "Committing files..." >>  $logfile
        git -C $pathscript commit -m "$commit" >> $logfile
        echo -e "Pushing files...\n" >>  $logfile
        git -C $pathscript push origin master >> $logfile
        git -C $pathscript push >> $logfile
        git -C $pathscript push git@github.com:FNNDSC/mediawiki.git master >> $logfile
        whoami >> $logfile

        echo -e "Pushing Done!\n-----------------\n\n" >> $logfile
        if (( Gb_saveNOshutdown == 0)) ; then 
                cd $pathscript && docker-compose up
        fi
else
    synopsis_show
fi
