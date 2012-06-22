#!/bin/bash

cd ~

HEIMAT=`pwd`

if [ -f /tmp/heimatverzeichnis ]
then
 rm /tmp/heimatverzeichnis
fi
echo $HEIMAT > /tmp/heimatverzeichnis
chmod 777 /tmp/heimatverzeichnis

WINXP=`echo $HEIMAT/.VirtualBox/Machines/winXP-2010/winXP-2010.xml`
VIRTUAL=`echo $HEIMAT/.VirtualBox/VirtualBox.xml`

PATCHEN="0"

if [ -f `echo $WINXP` ]
then
 chmod 777 $WINXP
fi

# existiert VirtualBox-Konfiguration lokal 
if [ -d /usr/share/linuxmuster-client/VirtualBox ]
then
 
 # VirtualBox-Konfiguration von lokal kopieren 
 # eventuell vorher Verzeichnis .VirtualBox anlegen
 # dazu muessen alle Dateien fuer ALLE lesbar sein!
 if [ -d `echo $HEIMAT/.VirtualBox` ]
 then
#  cp -r /usr/share/linuxmuster-client/VirtualBox/* $HEIMAT/.VirtualBox/
  cd
 else
  mkdir $HEIMAT/.VirtualBox
  cp -r /usr/share/linuxmuster-client/VirtualBox/* $HEIMAT/.VirtualBox/
  PATCHEN="1"
 fi

fi

# existieren VirtualBox-Konfiguration schulweit
if [ -d /home/share/school/.VirtualBox ]
then
 
 # VirtualBox-Konfiguration vom schulweitem Tauschverzeichnis kopieren 
 # eventuell vorher Verzeichnis .VirtualBox anlegen
 if [ -d `echo $HEIMAT/.VirtualBox` ]
 then
#  cp -r /home/share/school/.VirtualBox/* $HEIMAT/.VirtualBox/
  cd
 else
  mkdir $HEIMAT/.VirtualBox
  cp -r /home/share/school/.VirtualBox/* $HEIMAT/.VirtualBox/
  PATCHEN="1"
 fi

fi

# existieren VirtualBox-Konfiguration fuer Lehrer
if [ -d /home/share/teachers/.VirtualBox ]
then
 
 # VirtualBox-Konfiguration vom Lehrertausch kopieren 
 # eventuell vorher Verzeichnis .VirtualBox anlegen
 if [ -d `echo $HEIMAT/.VirtualBox` ]
 then
#  cp -r /home/share/teachers/.VirtualBox/* $HEIMAT/.VirtualBox/
  cd
 else
  mkdir $HEIMAT/.VirtualBox
  cp -r /home/share/teachers/.VirtualBox/* $HEIMAT/.VirtualBox/
  PATCHEN="1"
 fi

fi

# wenn datei /tmp/tmpwinXP.xml vorhanden, dann loeschen
if [ -f /tmp/tmpwinXP.xml ]
then
 rm /tmp/tmpwinXP.xml
fi

# winXP.xml patchen - shared folder in Heimatverzeichnis legen
# wenn die Konfigurationsdateien kopiert wurden -> PATCHEN="1"

if [ $PATCHEN == "1" ]
then 
 
 # /home/localadmin durch Heimatverzeichnis des Benutzers ersetzen
 ERGEBNIS=`cat $WINXP | sed 's/'" "'/'"xxyzz"'/g' | cut -d ' ' -f 1 `
 
 for EINTRAG in $ERGEBNIS; do
 
 # shared folder in Heimatverzeichnis des Benutzers legen
  `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#\/home\/localadmin#$HEIMAT#g" >> /tmp/tmpwinXP.xml`
 
 done
 
 cp /tmp/tmpwinXP.xml $WINXP
 
 # wenn datei /tmp/tmpwinXP.xml vorhanden, dann loeschen
 if [ -f /tmp/tmpwinXP.xml ]
 then
  rm /tmp/tmpwinXP.xml
 fi

fi


# RAM fuer virtuelle Maschine an tatsaechlichen RAM anpassen

# RAMSize bestimmen
RAM=`cat /proc/meminfo | grep "MemTotal" | cut -d ' ' -f 2- | cut -d 'k' -f 1`
RAM=`expr match $RAM '\(.[0-9]*\)'` 


ERGEBNIS=`cat $WINXP | sed 's/'" "'/'"xxyzz"'/g' | cut -d ' ' -f 1 `

# Den aktuellen Wert von VirtRAM bestimmen
TEST=`echo $ERGEBNIS | egrep RAMSize=\"512\"`

if [ `expr length $RAM` -eq 7 ]  # wenn RAM>=1GB (length=7), dann VirtRAM=512MB
then
 if [ "$TEST" == "" ]   # VirtRAM ist nicht 512
 then

  for EINTRAG in $ERGEBNIS; do
  
   `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#Memory RAMSize=\"256\"#Memory RAMSize=\"512\"#g" >> /tmp/tmpwinXP.xml`
  
  done
  
  cp /tmp/tmpwinXP.xml $WINXP
    
 fi
else                            # wenn RAM<1GB (length<>7), dann VirtRAM=256MB
 if [ "$TEST" == "" ]   # VirtRAM ist nicht 512
 then
  cd
 else                   # VirtRAM ist 512

  for EINTRAG in $ERGEBNIS; do
  
   `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#Memory RAMSize=\"512\"#Memory RAMSize=\"256\"#g" >> /tmp/tmpwinXP.xml`
  
  done

  cp /tmp/tmpwinXP.xml $WINXP
    
 fi
 
fi

# wenn datei /tmp/tmpwinXP.xml vorhanden, dann loeschen
if [ -f /tmp/tmpwinXP.xml ]
then
 rm /tmp/tmpwinXP.xml
fi


###########
########### da SNAPSHOTS auf /virtual liegen, ist keine Anpassung notwendig
## VirtualBox.xml patchen um Speicherort von Snapshots anzupassen
## wenn die Konfigurationsdateien kopiert wurden -> PATCHEN="1"
#
#if [ $PATCHEN == "1" ]
#then 
# 
# # wenn datei /tmp/tmpvirtual.xml vorhanden, dann loeschen
# if [ -f /tmp/tmpvirtual.xml ]
# then
#  rm /tmp/tmpvirtual.xml
# fi
# 
# ERGEBNIS1=`cat $VIRTUAL | sed 's/'" "'/'"xxyzz"'/g' | cut -d ' ' -f 1 `
# 
# for EINTRAG1 in $ERGEBNIS1; do
# 
# # Snapshot-Ordner in Heimatverzeichnis des Benutzers legen
#  `echo $EINTRAG1 | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#\/home\/localadmin#$HEIMAT#g" >> /tmp/tmpvirtual.xml`
# # bei lokaler Speicherung der Snapshots (in /virtual/...) keine Aenderung notwendig 
# 
# done
# 
# cp /tmp/tmpvirtual.xml $VIRTUAL
# 
# # wenn datei /tmp/tmpwinXP.xml vorhanden, dann loeschen
# if [ -f /tmp/tmpvirtual.xml ]
# then
#  rm /tmp/tmpvirtual.xml
# fi
# 
#fi
############

if [ -f `echo $WINXP` ]
then
 chmod 444 $WINXP
fi

# pdf-Dateien an Drucker weiterreichen nicht von root starten
if [ "`echo $HEIMAT | grep root`" = "" ]
then
 if [ "`pgrep ausdruck-winxp`" == "" ]
 then
   /usr/bin/ausdruck-winxp.sh &
 fi
fi
