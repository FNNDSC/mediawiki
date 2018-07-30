Mediawiki
======


.. contents:: Table of Contents


Overview
--------                        

This is the wiki of the FNNDSC lab. 

It is composed of two docker containers running:

 * ``mediawiki`` which run the apache2 server to powerup the website
 * ``mariadb`` which run a database with the content of the website

How to install
--------------

You need a docker environment set up. If you don't have, please follow the part 1 of docker tutorial: 

https://docs.docker.com/get-started/

You have to git clone this repository: 

        ``git clone https://github.com/FNNDSC/mediawiki.git``

Then just execute the ``make.sh`` script with: 

        ``bash make.sh``

It will power up the wiki on the following address:

        http://yourIPaddress:8080

As a side note, if you want to shutdown temporary the wiki you can use:

        ``docker-compose down``
To power it again you can use:

        ``docker-compose up``
NOTE: Don't forget to do it in the ``mediawiki`` directory


Backup
------

To perform backup, you have nothing to do. Just know that the following crontab is setup into the installation script ``make.sh``

- crontab -l | { cat; echo "00 04 * * * bash git-backup.sh"; } | crontab -

This crontab makes a save every day at 4 AM. 
It runs the ``git-backup.sh``. This script pushs all the content to this git repository. 

If you want to make sure that it's actually running just type: 

        ``crontab -l``

NOTE: If the wiki is not powered ``/neuro/labs/grantlab/research/mediawiki/`` then you must replace the path in ``git-backup.sh`` by your actual path. 


Important reminder
------------------

There are some details you must take into consideration to run the wiki:

 - You must be in the docker usergroup.
 - You must have a ssh key with no passphrase link to your account which performs backup.
 - You should not forget to delete the crontab if you shutdown the wiki. 

How does it work and important configuration files
--------------------------------------------------

This wiki is base on two official docker images, ``mediawiki`` and ``mariadb``. All the change between this wiki and any other are volume mapped. 
List of volumes: 
- ``images`` is the folder which contains the images of the wiki, it is link to the ``mediawiki`` docker.
- ``LocalSettings.php`` is a file of configuration of the wiki website, it is link to the ``mediawiki`` docker.
- ``wikidb`` is the folder which contains the data of the wiki, it is link to the ``mariadb`` docker.

There are two important configuration files:

 - ``LocalSettings.php``
 - ``docker-compose.yml``

The first one is mainly for website wiki features and it is inside the ``mediawiki`` container.
The second one is about parameters to run the containers. It contains the volumes mapping of the files of this repository among other things.


Potential problems
------------------

If the wiki strat growing a lot, big files will potentially be a problem for future backup on github. A solution that can be considerate is using ``Git Large Files Storage``: 

- https://git-lfs.github.com/

In ``make.sh`` steps are already written as comment. Keep in mind that this solution might have fees. 


You should keep in mind that the owner of the files created by the docker is not you. This might rise some problem in the future. Also, the contrary might cause some problems aswell. The container might not have the necessary right to modify the wiki in some servers directory.
