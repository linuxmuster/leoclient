#!/bin/bash
# Script created by Rainer Rössler (roesslerrr-at-web.de)
# License: Free Software (License GPLv3)

cd ~

RECHNER=`hostname`

HEIMAT=`pwd`

# existieren Desktop-Einträge lokal 
if [ -d /usr/share/linuxmuster-client/Desktop ]
then
 
 # Desktopeinträge von localadmin kopieren 
 # eventuell vorher Verzeichnis Desktop anlegen
 if [ -d `echo $HEIMAT/Arbeitsfläche` ]
 then
  cp -a /usr/share/linuxmuster-client/Desktop/* $HEIMAT/Arbeitsfläche/
 else
  mkdir $HEIMAT/Arbeitsfläche
  cp -a /usr/share/linuxmuster-client/Desktop/* $HEIMAT/Arbeitsfläche/
 fi

fi

# existieren Desktop-Einträge schulweit
if [ -d /home/share/school/.Desktop ]
then
 
 # Desktopeinträge von localadmin kopieren 
 # eventuell vorher Verzeichnis Desktop anlegen
 if [ -d `echo $HEIMAT/Arbeitsfläche` ]
 then
  cp -a /home/share/school/.Desktop/* $HEIMAT/Arbeitsfläche/
 else
  mkdir $HEIMAT/Arbeitsfläche
  cp -a /home/share/school/.Desktop/* $HEIMAT/Arbeitsfläche/
 fi

fi

# existieren Desktop-Einträge fuer Lehrer
if [ -d /home/share/teachers/.Desktop ]
then
 
 # Desktopeinträge von localadmin kopieren 
 # eventuell vorher Verzeichnis Desktop anlegen
 if [ -d `echo $HEIMAT/Arbeitsfläche` ]
 then
  cp -a /home/share/teachers/.Desktop/* $HEIMAT/Arbeitsfläche/
 else
  mkdir $HEIMAT/Arbeitsfläche
  cp -a /home/share/teachers/.Desktop/* $HEIMAT/Arbeitsfläche/
 fi

fi

