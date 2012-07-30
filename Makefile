#!/usr/bin/make
# Zur Erstellung des Debian-Pakets notwendig (make DESTDIR=/root/sophomorix)
# Created by Rüdiger Beck (jeffbeck-at-web.de)
DESTDIR=

# Virtualbox
VBOXDIR=$(DESTDIR)/usr/bin
VIRTCONF=$(DESTDIR)/etc/leovirtstarter
LEOCLIENTCONF=$(DESTDIR)/etc/leoclient
# Perl modules
PERLMOD=$(DESTDIR)/usr/share/perl5/leoclient
BIN=$(DESTDIR)/usr/bin
SBIN=$(DESTDIR)/usr/sbin
SHARE=$(DESTDIR)/usr/share/linuxmuster-client
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
	@echo '   make leoclient-leovirtstarter-client'
	@echo '      install virtualbox gui to start machines'
	@echo ' '
	@echo '   make leoclient-leovirtstarter-server'
	@echo '      install preparation script on server'
	@echo ' '
	@echo '   make leoclient-leovirtstarter-common'
	@echo '      install common files for leovirtstarter-client and leovirtstarter-server '
	@echo ' '
	@echo '   make leoclient-watch-my-home'
	@echo '      install script to trigger alarm, when files/dirs are saved outside a dir'
	@echo ' '
	@echo '   make leoclient-printer-virtual'
	@echo '      install pdf-file splitter and spooler'
	@echo ' '
	@echo '   make leoclient-printer-default'
	@echo '      install set default printer script'
	@echo ' '
	@echo '   make leoclient-italc'
	@echo '      install italc stuff'
	@echo ' '
	@echo '   make leoclient-shutdown'
	@echo '      install shutdown script'
	@echo ' '
	@echo '   make leoclient-icon-script'
	@echo '      install scripts to sync desktop icons'
	@echo ' '
	@echo '   make clearlog'
	@echo '      clear logfiles on this host'
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

leoclient-leovirtstarter-client:
	@echo '   * Installing the client script'
	@install -d -m0755 -oroot -groot $(VBOXDIR)
	@install -oroot -groot --mode=0755 virtualbox-gui/leovirtstarter-client $(VBOXDIR)
	@echo '   * Installing the client configuration files'
	@install -d -m755 -oroot -groot $(VIRTCONF)
	@install -oroot -groot --mode=0644 virtualbox-gui/leovirtstarter.conf  $(VIRTCONF)
	@install -oroot -groot --mode=0644 virtualbox-gui/leovirtstarter-onthego.conf  $(VIRTCONF)
	@echo '   * Installing vbox scripts'
	@install -d -m0755 -oroot -groot $(VBOXDIR)
	@install -oroot -groot --mode=0755 virtualbox/virtualbox-vm-conf-kopieren.sh $(VBOXDIR)


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

leoclient-watch-my-home:
	@echo '   * Installing the script leoclient-watch-my-home'
	@install -d -m0755 -oroot -groot $(BIN)
	@install -oroot -groot --mode=0755 watch-my-home/leoclient-watch-my-home $(VBOXDIR)
	@echo '   * Installing the configuration file'
	@install -d -m755 -oroot -groot $(LEOCLIENTCONF)
	@install -oroot -groot --mode=0644 watch-my-home/leoclient-watch-my-home.conf  $(LEOCLIENTCONF)


# build a package
deb:
	### deb
	@echo 'Did you do a dch -i ?'
	@sleep 8
	dpkg-buildpackage -tc -uc -us -sa -rfakeroot
	@echo ''
	@echo 'Do not forget to tag this version in git'
	@echo ''

clean:
	rm -rf  debian/leoclient



leoclient-printer-virtual:
	@echo '   * Installing printer scripts'
	@install -d -m0755 -oroot -groot $(BIN)
	@install -oroot -groot --mode=0755 printer/ausdruck-winxp-splitter $(BIN)
	@install -oroot -groot --mode=0755 printer/ausdruck-winxp-spooler $(BIN)
	@install -d -m755 -oroot -groot $(LEOCLIENTCONF)
	@install -oroot -groot --mode=0644 printer/leoclient-printer-virtual.conf  $(LEOCLIENTCONF)


leoclient-printer-default:
	@echo '   * Installing printer scripts'
	@install -d -m0755 -oroot -groot $(BIN)
	@install -oroot -groot --mode=0755 printer/standarddrucker-nach-raum.sh $(BIN)
	@install -d -m755 -oroot -groot $(LEOCLIENTCONF)
	@install -oroot -groot --mode=0644 printer/leoclient-printer-default.conf  $(LEOCLIENTCONF)


leoclient-italc:
	@echo '   * Installing italc scripts'
	@install -d -m0755 -oroot -groot $(BIN)
	@install -oroot -groot --mode=0755 italc/italc-raumanpassung.sh $(BIN)
	@install -d -m755 -oroot -groot $(LEOCLIENTCONF)
	@install -oroot -groot --mode=0644 italc/leoclient-italc.conf  $(LEOCLIENTCONF)


leoclient-shutdown:
# no config file
	@echo '   * Installing shutdown script (without cronjob entry)'
	@install -d -m0755 -oroot -groot $(VBOXDIR)
	@install -oroot -groot --mode=0755 shutdown/herunterfahren.sh $(BIN)



#lo:
#	@echo '   * Installing libreoffice stuff'
#	@install -d -m0755 -oroot -groot $(BIN)
#	@install -oroot -groot --mode=0755 openoffice-vorlagen/openoffice-vorlagenverz-kopieren.sh $(BIN)

leoclient-icon-script:
	@echo '   * Installing desktop icons'
	@install -d -m0755 -oroot -groot $(BIN)
	@install -oroot -groot --mode=0755 desktop-icons/desktop-icons-hinzu.sh $(BIN)


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

