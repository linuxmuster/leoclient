#!/bin/bash

cd ~

HEIMAT=`pwd`
 
if [ -f /tmp/heimatverzeichnis ]
then
  HEIMATTMP=`cat /tmp/heimatverzeichnis`
else
  HEIMATTMP="NEU"
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

  if [ $HEIMATTMP != $HEIMAT ]
  then

   if [ -d `echo $HEIMAT/.VirtualBox/Machines/winXP-2010` ]
   then
     cp /usr/share/linuxmuster-client/VirtualBox/Machines/winXP-2010/winXP-2010.xml $HEIMAT/.VirtualBox/Machines/winXP-2010/
     PATCHEN="1"     # -> Pfad fuer shares werden angepasst
     HEIMATTMP="NEU" # -> RAM wird angepasst
   else
     cp -r /usr/share/linuxmuster-client/VirtualBox/* $HEIMAT/.VirtualBox/
     PATCHEN="1"     # -> Pfad fuer shares werden angepasst
     HEIMATTMP="NEU" # -> RAM wird angepasst
   fi
  
 fi

 else
  mkdir $HEIMAT/.VirtualBox
  cp -r /usr/share/linuxmuster-client/VirtualBox/* $HEIMAT/.VirtualBox/
  PATCHEN="1"     # -> Pfad fuer shares werden angepasst
  HEIMATTMP="NEU" # -> RAM wird angepasst
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


if [ $HEIMATTMP != $HEIMAT ]  # wenn Heimatverzeichnis verändert ist
then                          # nur dann läuft das folgende script
#*******************************************************************#

# RAM fuer virtuelle Maschine an tatsaechlichen RAM anpassen

# RAMSize bestimmen
RAM=`cat /proc/meminfo | grep "MemTotal" | cut -d ' ' -f 2- | cut -d 'k' -f 1`
RAM=`expr match $RAM '\(.[0-9]*\)'` 

RAMFIRST=`echo ${RAM:0:1}`

RAMSECOND=`echo ${RAM:1:1}`

# aktuelle Konfigurationsdatei auf 1024 MB setzen
# wenn Standard winXP-2010.xml kopiert wurde, 
# genuegt es 256 MB durch 1024 zu ersetzen
# bzw. kann dieser Schritt auskommentiert werden 
 
## aktuelle Konfigurationsdatei einlesen
#ERGEBNIS=`cat $WINXP | sed 's/'" "'/'"xxyzz"'/g' | cut -d ' ' -f 1 `
# 
#for EINTRAG in $ERGEBNIS; do
#   `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#Memory RAMSize=\"256\"#Memory RAMSize=\"1024\"#g" >> /tmp/tmpwinXP.xml`
##   `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#Memory RAMSize=\"256\"#Memory RAMSize=\"1024\"#g" | sed -e "s#Memory RAMSize=\"512\"#Memory RAMSize=\"1024\"#g" | sed -e "s#Memory RAMSize=\"768\"#Memory RAMSize=\"1024\"#g"  >> /tmp/tmpwinXP.xml`
#done
#cp /tmp/tmpwinXP.xml $WINXP
# 
## wenn datei /tmp/tmpwinXP.xml vorhanden, dann loeschen
#if [ -f /tmp/tmpwinXP.xml ]
#then
# rm /tmp/tmpwinXP.xml
#fi

# aktuelle Konfigurationsdatei mit 1024 MB einlesen

ERGEBNIS=`cat $WINXP | sed 's/'" "'/'"xxyzz"'/g' | cut -d ' ' -f 1 `

# RAMSOLL einsetzen
if [ `expr length $RAM` -eq 6 ]  # wenn RAM>=1GB (length=7), dann VirtRAM=512MB
then
      for EINTRAG in $ERGEBNIS; do
       `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#Memory RAMSize=\"1024\"#Memory RAMSize=\"256\"#g" >> /tmp/tmpwinXP.xml`
      done
      cp /tmp/tmpwinXP.xml $WINXP

elif [ $RAMFIRST == "1" ] 
then
  if [ $RAMSECOND -lt 2 ] # 1,0 oder 1,1 GB RAM
  then
      for EINTRAG in $ERGEBNIS; do
       `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#Memory RAMSize=\"1024\"#Memory RAMSize=\"512\"#g" >> /tmp/tmpwinXP.xml`
      done
      cp /tmp/tmpwinXP.xml $WINXP

  elif  [ $RAMSECOND -lt 5 ] # 1,2 1,3 oder 1,4 GB RAM
  then
    for EINTRAG in $ERGEBNIS; do
       `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#Memory RAMSize=\"1024\"#Memory RAMSize=\"768\"#g" >> /tmp/tmpwinXP.xml`
      done
      cp /tmp/tmpwinXP.xml $WINXP
  
  fi
fi 
# in allen anderen Faellen ist RAM schon korrekt auf 1024 MB gesetzt


# wenn datei /tmp/tmpwinXP.xml vorhanden, dann loeschen
if [ -f /tmp/tmpwinXP.xml ]
then
 rm /tmp/tmpwinXP.xml
fi


# Netzwerkkarte aktivieren?

# MAC-Adressen von Rechnern, die eine zweite Netzverbindung erhalten sollen
# durch Leerzeichen getrennt
#MACADRESSEN="00:17:31:19:9f:2c 00:13:d4:ed:f9:b0 00:04:76:f1:b5:8a 90:e6:ba:2c:d3:50"
MACADRESSEN="00:15:f2:c6:26:76 00:15:f2:c6:24:19 00:15:f2:c6:27:2b 00:15:f2:c6:26:94 00:15:f2:c6:24:ae 00:15:f2:c6:27:21 00:15:f2:c6:27:3c 00:15:f2:c6:26:c8 00:15:f2:c6:26:d9 00:15:f2:c6:23:d4 00:15:f2:c6:26:96 00:15:f2:c6:25:e2 00:15:f2:c6:26:e5 00:15:f2:c6:27:38 00:13:d4:f1:5f:13 00:15:f2:c6:26:c4 00:15:f2:c6:26:8f 00:15:f2:c6:26:ab 00:15:f2:c5:24:08 00:15:f2:c6:26:f8 00:17:31:19:9d:2b 00:04:76:10:84:04 00:17:31:19:9f:2c 00:13:d4:ed:f9:b0"

GEFUNDEN="0"
MAC="00277EAB29"

for RECHNER in $MACADRESSEN; do  # MAC suchen

# Überpruefen, ob MAC-Adresse vorliegt und auf welcher eth diese liegt
# echo Rechner: $RECHNER
 
 NIC=`ifconfig | grep $RECHNER | cut -d " " -f 1`
# echo $NIC

 if [ "`echo $NIC | grep eth`" != "" ]
 then

  MAC=`echo $RECHNER | cut --characters=4,5,7,8,10,11,13,14,16,17`
# echo $MAC

  if [ $NIC == "eth0" ] # eth gefunden
  then
   ERSETZEN1="BridgedInterface name=\"eth1\""
  else
   ERSETZEN1="BridgedInterface name=\"eth0\""
  fi
  GEFUNDEN="1"

 fi # eth gefunden

done # MAC suchen

# Ersetzen = Netzwerkkarte aktivieren

if [ "`echo $GEFUNDEN`" == "1" ] 
then
  
  # Netzwerkkarte aktivieren
  # dabei muss:           InternalNetwork name="intnet" 
  SUCHEN1="InternalNetwork name=\"intnet\""
  # ersetzt werden durch: BridgedInterface name="ethX"
  # ERSETZEN1 wurde oben gesetzt
  # und:   Adapter slot="0" enabled="false" MACAddress="0800277EAB29" cable="true" speed="0" type="Am79C973"
  SUCHEN2="Adapter slot=\"0\" enabled=\"false\" MACAddress=\"0800277EAB29\" cable=\"true\" speed=\"0\" type=\"Am79C973\""
  # durch:  Adapter slot="0" enabled="true" MACAddress="0800277EAB29" cable="true" speed="0" type="Am79C973"
  ERSETZEN2="Adapter slot=\"0\" enabled=\"true\" MACAddress=\"08"$MAC"\" cable=\"true\" speed=\"0\" type=\"Am79C973\""

  # wenn datei /tmp/tmpwinXP.xml vorhanden, dann loeschen
  if [ -f /tmp/tmpwinXP.xml ]
  then
   rm /tmp/tmpwinXP.xml
  fi
  
  ERGEBNIS=`cat $WINXP | sed 's/'" "'/'"xxyzz"'/g' | cut -d ' ' -f 1 `
 
  for EINTRAG in $ERGEBNIS; do
   
   `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' | sed -e "s#$SUCHEN1#$ERSETZEN1#g" | sed -e "s#$SUCHEN2#$ERSETZEN2#g"  >> /tmp/tmpwinXP.xml`
   # nichts ändern mit
   # `echo $EINTRAG | sed 's/'"xxyzz"'/'" "'/g' >> /tmp/tmpwinXP.xml`
  done
  
  cp /tmp/tmpwinXP.xml $WINXP
  
  # wenn datei /tmp/tmpwinXP.xml vorhanden, dann loeschen
  if [ -f /tmp/tmpwinXP.xml ]
  then
   rm /tmp/tmpwinXP.xml
  fi
  
fi


#*******************************************************************#
fi


# pdf-Dateien an Drucker weiterreichen nicht von root starten
if [ "`echo $HEIMAT | grep root`" = "" ]
then
# if [ "`pgrep ausdruck-winxp`" == "" ]
# then
#   /usr/bin/ausdruck-winxp.sh &
# fi
 if [ "`pgrep ausdruck-winxp-spooler`" == "" ]
 then
   /usr/bin/ausdruck-winxp-spooler &
 fi
 if [ "`pgrep ausdruck-winxp-splitter`" == "" ]
 then
   /usr/bin/ausdruck-winxp-splitter &
 fi
fi
