#!/bin/bash
# Script created by Rainer Rössler (roesslerrr-at-web.de)
# License: Free Software (License GPLv3)

cd ~

RAUM=`hostname | cut -d 'p' -f 1 | tr [:upper:] [:lower:] `


# Standarddrucker PDF setzen
STANDARDDRUCKER="PDF"


# Gibt es einen Netzwerkdrucker fuer den Raum?
ERGEBNIS=`lpstat -v | sed 's/'" "'/'"xxyzz"'/g' | cut -d ' ' -f 1 `
 
for EINTRAG in $ERGEBNIS; do

  if [ "`echo $EINTRAG | tr [:upper:] [:lower:] | egrep $RAUM`" == "" ]
  then
    cd ~
  else
    STANDARDDRUCKER=`echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | cut -d ':' -f 1 | cut -d ' ' -f 3 `
  fi

done


# Gibt es einen lokalen USB-Drucker?
LOKALDRUCKER=`lpstat -v | grep "/usb/" | cut -d ':' -f 1 | cut -d ' ' -f 3 `

if [ "`echo $LOKALDRUCKER`" == "" ]
then
  cd ~
else
  STANDARDDRUCKER=`echo $LOKALDRUCKER`
fi

LOKALDRUCKER=`lpstat -v | grep "usb://" | cut -d ':' -f 1 | cut -d ' ' -f 3 `

if [ "`echo $LOKALDRUCKER`" == "" ]
then
  cd ~
else
  STANDARDDRUCKER=`echo $LOKALDRUCKER`
fi


# Standarddrucker eintragen - dazu muss USER in der Gruppe lp sein
#echo $STANDARDDRUCKER
lpadmin -d $STANDARDDRUCKER
lpoptions -d $STANDARDDRUCKER
