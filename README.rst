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

You need a docker environment set up. If you don't have it, please follow the part 1 of docker tutorial: 

https://docs.docker.com/get-started/

You have to git clone this repository: 

        ``git clone git@github.com:FNNDSC/mediawiki.git``

If you can't perform this commamd, you have to create an ssh key and link it to your git account which can edit this repository.

Then execute the ``make.sh`` script with: 

        ``./make.sh`` 

If you are running it for the first time, you might want to create a crontab to perform daily backup. Then you should use : 

		``./make.sh -c`` 

If it has been a long time since you powered the wiki, you might want to update your files from this repo using :

		``./make.sh -p`` 

It will then power up the wiki on the following address:

        http://yourIPaddress:8080

As a side note, if you want to shutdown the wiki temporarily you can use:

        ``docker-compose down``

To power it up again you can use:

        ``docker-compose up``

NOTE: Don't forget to do it in the ``mediawiki`` directory


Backup
------

To perform backup, you must run ``./make.sh -c`` once. Then, just make sure that the following crontab is set up using ``crontab -l``.

- crontab -l | { cat; echo "00 04 * * * your/path/to/git-backup.sh"; } | crontab -

This crontab saves the wiki every day at 4 AM. 
It runs the ``git-backup.sh``. This script pushs all the content to this git repository. 

If you want to make sure that it's actually running just type: 

        ``crontab -l``

Some logs are stocked in /tmp/backup.log. But if you want to have more detail yo u might want to install an MTA service.

Important reminder
------------------

There are some details you must take into consideration to run the wiki:

 - You must be in the docker usergroup.
 - You must have a ssh key with no passphrase link to your account which performs backup.
 - You should not forget to delete the crontab if you shutdown the wiki. 

How does it work and important configuration files
--------------------------------------------------

This wiki is based on two official docker images, ``mediawiki`` and ``mariadb``. All the changes between this wiki and any other are volume mapped. 
List of volumes: 
- ``images`` is the folder which contains the images of the wiki, it is link to the ``mediawiki`` docker.
- ``LocalSettings.php`` is a file of configurations for the wiki website, it is link to the ``mediawiki`` docker.
- ``wikidb`` is the folder which contains the data of the wiki, it is link to the ``mariadb`` docker.

There are two important configuration files:

 - ``LocalSettings.php``
 - ``docker-compose.yml``

The first one is mainly for website wiki features and it is inside the ``mediawiki`` container.
The second one is about parameters to run the containers. It contains the volumes mapping of the files of this repository among other things.


Potential problems
------------------

If the wiki start to contain big files (over 200MB), it will potentially be a problem for future backup on github. A solution that can be considered is to use ``Git Large Files Storage``: 

- https://git-lfs.github.com/

In ``make.sh`` steps are already written with ``-L`` argument. Keep in mind that this solution might cause problems. 


You should keep in mind that the owner of the files created by the docker is not you. This might rise some problem in the future. Also, the contrary might cause some problems aswell. The container might not have the necessary right to modify the wiki in some servers directory.
