#!/bin/bash

UNENDLICH=0

cd ~

if [ -f /tmp/heimatverzeichnis ]
then
  HEIMAT=`cat /tmp/heimatverzeichnis`
  cd `echo $HEIMAT`
  UNENDLICH=1
fi


while [ $UNENDLICH = 1 ] 
do 
 
 if [ -f /tmp/heimatverzeichnis ]
 then
   HEIMATAKTUELL=`cat /tmp/heimatverzeichnis`
 fi
 
 # Ueberpruefen ob aktueller Benutzer dem gespeicherten
 # Heimatverzeichnis entspricht
 if [ $HEIMAT == $HEIMATAKTUELL ]
 then
     UNENDLICH=1
 else
     UNENDLICH=0
 fi
 
 
 # Ueberpruefen ob Datei ausdruck-winxp.pdf im Heimatverzeichnis vorhanden
 if [ -f ausdruck-winxp.pdf ]
 then
 # echo Datei ist vorhanden, bitte ausdrucken
   sleep 10
 #  echo 10
   mv ausdruck-winxp.pdf ausdruck-winxp-fertig.pdf
   lp ausdruck-winxp-fertig.pdf
 else 
   sleep 5
 fi

done

