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
                a) Gb_saveauto=1				;;
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
fi

if (( Gb_commit )) ||  (( Gb_saveauto )); then 

		if (( Gb_saveNOshutdown == 0)) ; then 
				cd $pathscript && docker-compose down
				echo "DOCK DOWN"
		fi
		echo -e "\n\n$date" >> $logfile
		echo -e "\n\n$pathscript" >> $logfile
		echo -e "\n\n$commit" >> $logfile

		echo "Adding files..." >>  $logfile
		git -C $pathscript add -A >> $logfile
		echo "Committing files..." >>  $logfile
		git -C $pathscript commit -m "$commit" >> $logfile
		echo "Pushing files..." >>  $logfile
		git -C $pathscript push origin master >> $logfile

		echo "Done!" >>  $logfile
		if (( Gb_saveNOshutdown == 0)) ; then 
				cd $pathscript && docker-compose up
				echo "DOCK up"
		fi
		echo "Save done!"
else
	synopsis_show
fi

