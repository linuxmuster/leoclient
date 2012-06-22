#!/bin/bash

cd ~

RECHNER=`hostname`

HEIMAT=`pwd`

# existieren Desktop-Einträge lokal 
if [ -d /usr/share/linuxmuster-client/Desktop ]
then
 
 # Desktopeinträge von localadmin kopieren 
 # eventuell vorher Verzeichnis Desktop anlegen
 if [ -d `echo $HEIMAT/Desktop` ]
 then
  cp -a /usr/share/linuxmuster-client/Desktop/* $HEIMAT/Desktop/
 else
  mkdir $HEIMAT/Desktop
  cp -a /usr/share/linuxmuster-client/Desktop/* $HEIMAT/Desktop/
 fi

fi

# existieren Desktop-Einträge schulweit
if [ -d /home/share/school/.Desktop ]
then
 
 # Desktopeinträge von localadmin kopieren 
 # eventuell vorher Verzeichnis Desktop anlegen
 if [ -d `echo $HEIMAT/Desktop` ]
 then
  cp -a /home/share/school/.Desktop/* $HEIMAT/Desktop/
 else
  mkdir $HEIMAT/Desktop
  cp -a /home/share/school/.Desktop/* $HEIMAT/Desktop/
 fi

fi

# existieren Desktop-Einträge fuer Lehrer
if [ -d /home/share/teachers/.Desktop ]
then
 
 # Desktopeinträge von localadmin kopieren 
 # eventuell vorher Verzeichnis Desktop anlegen
 if [ -d `echo $HEIMAT/Desktop` ]
 then
  cp -a /home/share/teachers/.Desktop/* $HEIMAT/Desktop/
 else
  mkdir $HEIMAT/Desktop
  cp -a /home/share/teachers/.Desktop/* $HEIMAT/Desktop/
 fi

fi

