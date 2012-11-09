#!/usr/bin/make
# Zur Erstellung des Debian-Pakets notwendig (make DESTDIR=/root/sophomorix)
# Created by Rüdiger Beck (jeffbeck-at-web.de)
DESTDIR=

# Virtualbox
VBOXDIR=$(DESTDIR)/usr/bin
LEOVIRT=$(DESTDIR)/usr/share/leoclient-virtualbox
DEFVM=virtualbox/default-winXP-VM
VIRTCONF=$(DESTDIR)/etc/leovirtstarter
LEOCLIENTCONF=$(DESTDIR)/etc/leoclient
MENU=$(DESTDIR)/usr/share/menu
# Perl modules
PERLMOD=$(DESTDIR)/usr/share/perl5/leoclient
BIN=$(DESTDIR)/usr/bin
SBIN=$(DESTDIR)/usr/sbin
SHARE=$(DESTDIR)/usr/share/linuxmuster-client
DESKTOP=$(DESTDIR)/usr/share/applications
ICON=$(DESTDIR)/usr/share/pixmaps
INIT=$(DESTDIR)/etc/init.d
# where is the start script linked
START=$(DESTDIR)/etc/rc2.d/S99leoclient

help:
	@echo ' '
	@echo 'Most common options of this Makefile:'
	@echo '-------------------------------------'
	@echo ' '
	@echo '   make help'
	@echo '      show this help'
	@echo ' '
	@echo '   make leoclient-virtualbox'
	@echo '      install virtualbox default machines and login script'
	@echo ' '
	@echo '   make leoclient-leovirtstarter-client'
	@echo '      install virtualbox gui to start machines'
	@echo ' '
	@echo '   make leoclient-leovirtstarter-server'
	@echo '      install preparation script on server'
	@echo ' '
	@echo '   make leoclient-leovirtstarter-common'
	@echo '      install common files for leovirtstarter-client and leovirtstarter-server '
	@echo ' '
	@echo '   make leoclient-vm printer'
	@echo '      install pdf-file splitter and spooler'
	@echo ' '
	@echo '   make deb'
	@echo '      create a debian package'
	@echo ' '
	@echo '   make clean'
	@echo '      clean up stuff created by packaging'
	@echo ' '



#leoclient:
#	@echo '   * Installing leoclient scripts'
#	@install -d -m0755 -oroot -groot $(INIT)
#	@install -oroot -groot --mode=0755 updater/leoclient-updater $(INIT)
#	@rm -f $(START)
#	@# link to script in runlevel dir
#	@ln -s $(INIT)/leoclient-updater $(START)
#	@# link to execute script /usr/bin/leoclient-updater
#	@rm -f $(BIN)/leoclient-updater
#	@ln -s $(INIT)/leoclient-updater $(BIN)/leoclient-updater



default: 
	@echo 'Doing Nothing'



# tools
############################################################
#vbox:
#	@echo '   * Installing vbox scripts'
#	@install -d -m0755 -oroot -groot $(VBOXDIR)
#	@install -oroot -groot --mode=0755 virtualbox/virtualbox-vm-conf-kopiere#n.sh $(VBOXDIR)

leoclient-virtualbox:
	@echo '   * Installing leoclient-virtualbox'
	@echo '   * Installing script to setup default VirtualBox configuration'
	@install -d -m0755 -oroot -groot $(VBOXDIR)
	@install -oroot -groot --mode=0755 virtualbox/setup-virtualbox $(VBOXDIR)
	@echo '   * Installing default win-XP-VM'
	@install -d -m0755 -oroot -groot $(LEOVIRT)
	@install -d -m0755 -oroot -groot $(LEOVIRT)/VirtualBox
	@install -oroot -groot --mode=0755 $(DEFVM)/compreg.dat $(LEOVIRT)/VirtualBox
	@install -oroot -groot --mode=0755 $(DEFVM)/VirtualBox.xml $(LEOVIRT)/VirtualBox
	@install -oroot -groot --mode=0755 $(DEFVM)/xpti.dat $(LEOVIRT)/VirtualBox
	@install -d -m0755 -oroot -groot $(LEOVIRT)/VirtualBox/Machines
	@install -d -m0755 -oroot -groot $(LEOVIRT)/VirtualBox/Machines/winXP
	@install -oroot -groot --mode=0755 $(DEFVM)/Machines/winXP/winXP.xml $(LEOVIRT)/VirtualBox/Machines/winXP


leoclient-leovirtstarter-client:
	@echo '   * Installing the client script'
	@install -d -m0755 -oroot -groot $(VBOXDIR)
	@install -oroot -groot --mode=0755 virtualbox-gui/leovirtstarter-client $(VBOXDIR)
	@echo '   * Installing the client configuration files'
	@install -d -m755 -oroot -groot $(VIRTCONF)
	@install -oroot -groot --mode=0644 virtualbox-gui/leovirtstarter.conf  $(VIRTCONF)
	@install -oroot -groot --mode=0644 virtualbox-gui/leovirtstarter-onthego.conf  $(VIRTCONF)
	@echo '   * Installing unity dash entry'
	@install -d -m0755 -oroot -groot $(DESKTOP)
	@install -oroot -groot --mode=0644 virtualbox-gui/leovirtstarter-client.desktop $(DESKTOP)
	@echo '   * Installing icon'
	@install -d -m0755 -oroot -groot $(ICON)
	@install -oroot -groot --mode=0644 virtualbox-gui/leovirtstarter-client.png $(ICON)

leoclient-leovirtstarter-server:
	@echo '   * Installing the server script'
	@install -d -m0755 -oroot -groot $(VBOXDIR)
	@install -oroot -groot --mode=0755 virtualbox-gui/leovirtstarter-server $(VBOXDIR)
	@echo '   * Installing the server configuration file'
	@install -d -m755 -oroot -groot $(VIRTCONF)
	@install -oroot -groot --mode=0644 virtualbox-gui/leovirtstarter-server.conf  $(VIRTCONF)


leoclient-leovirtstarter-common:
	@echo '   * Installing the common configuration file'
	@install -d -m755 -oroot -groot $(VIRTCONF)
	@install -oroot -groot --mode=0644 virtualbox-gui/leovirtstarter.conf  $(VIRTCONF)
	@echo '   * Installing the common module'
	@install -d -m755 -oroot -groot $(PERLMOD)
	@install -oroot -groot --mode=0644 virtualbox-gui/leovirtstarter.pm $(PERLMOD)



# build a package
deb:
	### deb
	dpkg-buildpackage -tc -uc -us -sa -rfakeroot
	@echo ''
	@echo 'Do not forget to tag this version in git. Have you done a dch -i?'
	@echo ''

clean:
	rm -rf  debian/leoclient



leoclient-vm-printer:
	@echo '   * Installing printer scripts'
	@install -d -m0755 -oroot -groot $(BIN)
	@install -oroot -groot --mode=0755 printer/run-vm-printer-splitter $(BIN)
	@install -oroot -groot --mode=0755 printer/run-vm-printer-spooler $(BIN)
	@install -d -m755 -oroot -groot $(LEOCLIENTCONF)
	@install -oroot -groot --mode=0644 printer/leoclient-vm-printer.conf  $(LEOCLIENTCONF)



#lo:
#	@echo '   * Installing libreoffice stuff'
#	@install -d -m0755 -oroot -groot $(BIN)
#	@install -oroot -groot --mode=0755 openoffice-vorlagen/openoffice-vorlagenverz-kopieren.sh $(BIN)


#bios:
#	@echo '   * Installing biostime script (todo)'
#	@install -d -m0755 -oroot -groot $(BIN)
#	@#@install -oroot -groot --mode=0755 bios/bios???.sh $(BIN)


lm:
	@echo '   * Installing linuxmuster scripts'
	@install -d -m0755 -oroot -groot $(SHARE)
	@@install -oroot -groot --mode=0755 linuxmuster/mount.sh $(SHARE)
	@@install -oroot -groot --mode=0755 linuxmuster/umount.sh $(SHARE)
	@@install -oroot -groot --mode=0644 linuxmuster/profile $(SHARE)

leoclient-tools:
	@echo '   * Install leoclient tools'
	@install -d -m0755 -oroot -groot $(SBIN)
	@install -oroot -groot --mode=0755  tools/leoclient-admin $(SBIN)
	@install -d -m755 -oroot -groot $(LEOCLIENTCONF)
	@install -oroot -groot --mode=0644 tools/leoclient-admin.conf  $(LEOCLIENTCONF)

