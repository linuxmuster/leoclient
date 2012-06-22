#!/bin/bash

cd ~

HEIMAT=`pwd`

WINXP=`echo $HEIMAT/.VirtualBox/Machines/winXP/winXP.xml`
VIRTUAL=`echo $HEIMAT/.VirtualBox/VirtualBox.xml`

if [ -f `echo $WINXP` ]
then
 chmod 644 $WINXP
fi

# wenn Virtual.xml exisitiert, dann sichern
if [ -f $VIRTUAL ]
then
 cp $VIRTUAL /tmp/tmpVirtual.xml
fi

# existiert VirtualBox-Konfiguration lokal 
if [ -d /usr/share/linuxmuster-client/VirtualBox ]
then
 
 # VirtualBox-Konfiguration von lokal kopieren 
 # eventuell vorher Verzeichnis .VirtualBox anlegen
 # dazu muessen alle Dateien fuer ALLE lesbar sein!
 if [ -d `echo $HEIMAT/.VirtualBox` ]
 then
  cp -a /usr/share/linuxmuster-client/VirtualBox/* $HEIMAT/.VirtualBox/
  cd ~
 else
  mkdir $HEIMAT/.VirtualBox
  cp -a /usr/share/linuxmuster-client/VirtualBox/* $HEIMAT/.VirtualBox/
 fi

fi

# existieren Desktop-Einträge schulweit
if [ -d /home/share/school/.VirtualBox ]
then
 
 # VirtualBox-Konfiguration vom schulweitem Tauschverzeichnis kopieren 
 # eventuell vorher Verzeichnis .VirtualBox anlegen
 if [ -d `echo $HEIMAT/.VirtualBox` ]
 then
  cp -a /home/share/school/.VirtualBox/* $HEIMAT/.VirtualBox/
  cd ~
 else
  mkdir $HEIMAT/.VirtualBox
  cp -a /home/share/school/.VirtualBox/* $HEIMAT/.VirtualBox/
 fi

fi

# existieren Desktop-Einträge fuer Lehrer
if [ -d /home/share/teachers/.VirtualBox ]
then
 
 # VirtualBox-Konfiguration vom Lehrertausch kopieren 
 # eventuell vorher Verzeichnis .VirtualBox anlegen
 if [ -d `echo $HEIMAT/.VirtualBox` ]
 then
  cp -a /home/share/teachers/.VirtualBox/* $HEIMAT/.VirtualBox/
  cd ~
 else
  mkdir $HEIMAT/.VirtualBox
  cp -a /home/share/teachers/.VirtualBox/* $HEIMAT/.VirtualBox/
 fi

fi

# wenn datei /tmp/tmpwinXP.xml vorhanden, dann loeschen
if [ -f /tmp/tmpwinXP.xml ]
then
 rm /tmp/tmpwinXP.xml
fi

ERGEBNIS=`cat $WINXP | sed 's/'" "'/'"xxyzz"'/g' | cut -d ' ' -f 1 `

for EINTRAG in $ERGEBNIS; do

 `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#\/home\/localadmin#$HEIMAT#g" >> /tmp/tmpwinXP.xml`

done

mv /tmp/tmpwinXP.xml $WINXP

# Sicherung von Virtual.xml zurueckspielen, falls existent
if [ -f /tmp/tmpVirtual.xml ]
then
 mv /tmp/tmpVirtual.xml $VIRTUAL
fi


# wenn datei /tmp/tmpwinXP.xml vorhanden, dann loeschen
if [ -f /tmp/tmpvirtual.xml ]
then
 rm /tmp/tmpvirtual.xml
fi

ERGEBNIS1=`cat $VIRTUAL | sed 's/'" "'/'"xxyzz"'/g' | cut -d ' ' -f 1 `

for EINTRAG1 in $ERGEBNIS1; do

 `echo $EINTRAG1 | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#\/home\/localadmin#$HEIMAT#g" >> /tmp/tmpvirtual.xml`

done

mv /tmp/tmpvirtual.xml $VIRTUAL


if [ -f `echo $WINXP` ]
then
 chmod 444 $WINXP
fi
