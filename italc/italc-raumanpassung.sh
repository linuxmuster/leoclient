#!/bin/bash

cd ~

RECHNER=`hostname`

HEIMAT=`pwd`

#symbolischer Link .italc im Heimatverzeichnis löschen, falls vorhanden
if [ -h `echo $HEIMAT/.italc` ]
then
  rm `echo $HEIMAT/.italc`
fi

#Verzeichnis .italc im Heimatverzeichnis wegsichern, falls vorhanden
if [ -d `echo $HEIMAT/.italc` ]
then
  #Verzeichnis .italc-alt im Heimatverzeichnis loeschen, falls vorhanden 
  if [ -d `echo $HEIMAT/.italc-alt` ]
  then
    rm -rf `echo $HEIMAT/.italc-alt`
  fi
  mv `echo $HEIMAT/.italc $HEIMAT/.italc-alt`
fi

#neuer symbolischer link erzeugen, falls Ziel existiert
if test -d `echo /home/share/teachers/.italc/$RECHNER`; then
  ln -s `echo /home/share/teachers/.italc/$RECHNER/ $HEIMAT/.italc`
fi
