#!/bin/bash
# Script created by Rainer Rössler (roesslerrr-at-web.de)
# License: Free Software (License GPLv3)
notify-send -u critical -i /usr/share/icons/Humanity/status/48/dialog-warning.svg "ACHTUNG!" "Der Rechner schaltet sich in 2 Min. aus! Speichern Sie Ihre Daten jetzt!" &
sleep 28
notify-send -u critical -i /usr/share/icons/Humanity/status/48/dialog-warning.svg "ACHTUNG!" "Der Rechner schaltet sich in 90 Sek. aus! Speichern Sie Ihre Daten jetzt!" &
sleep 28
notify-send -u critical -i /usr/share/icons/Humanity/status/48/dialog-warning.svg "ACHTUNG!" "Der Rechner schaltet sich in 60 Sek. aus! Speichern Sie Ihre Daten jetzt!" &
sleep 28
notify-send -u critical -i /usr/share/icons/Humanity/status/48/dialog-warning.svg "ACHTUNG!" "Der Rechner schaltet sich in 30 Sek. aus! Speichern Sie Ihre Daten jetzt!" &
sleep 10
notify-send -u critical -i /usr/share/icons/Humanity/status/48/dialog-warning.svg "ACHTUNG!" "Der Rechner schaltet sich in 20 Sek. aus! Speichern Sie Ihre Daten jetzt!" &
sleep 10
notify-send -u critical -i /usr/share/icons/Humanity/status/48/dialog-warning.svg "ACHTUNG!" "Der Rechner schaltet sich in 10 Sek. aus! Speichern Sie Ihre Daten jetzt!" &
sleep 10
notify-send -u critical -i /usr/share/icons/Humanity/status/48/dialog-warning.svg "ACHTUNG!" "Der Rechner schaltet sich jetzt aus!" &
sleep 5
exit 0
