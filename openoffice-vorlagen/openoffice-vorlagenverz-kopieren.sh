#!/bin/bash

cd ~

HEIMAT=`pwd`

OOVORLAGENPFAD=`echo $HEIMAT/.openoffice.org/3/user/registry/data/org/openoffice/Office`
OOVORLAGEN=`echo $HEIMAT/.openoffice.org/3/user/registry/data/org/openoffice/Office/Paths.xcu`

if [ -d `echo $OOVORLAGENPFAD` ]
then

 if [ -f `echo $OOVORLAGEN` ]
 then
  cd ~
 else

  # existieren Desktop-Einträge fuer Lehrer
  if [ -f /home/share/teachers/__Vorlagen/Paths.xcu ]
  then
   
   # OpenOffice-Vorlagen-Einstellungen vom Lehrertausch kopieren 
   cp /home/share/teachers/__Vorlagen/Paths.xcu $OOVORLAGEN
  
  fi
 fi
fi

# Loeschen der .execooo*-Dateien im Heimatverzeichnis
cd ~
DATEIEN=`ls -al`
if [ "`echo $DATEIEN | egrep execooo`" = "" ]
then
 cd ~
else
 rm .execooo*
fi
