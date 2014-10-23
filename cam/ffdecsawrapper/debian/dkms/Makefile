
PACKAGE_VERSION := @VERSION@
KERNELRELEASE := $(shell uname -r)
KERNELVERSION := $(shell echo '$(KERNELRELEASE)' | awk -F '-' '{print $$1}')
V1 := $(shell echo '$(KERNELVERSION)' | awk -F '.'     '{print $$1}')
V2 := $(shell echo '$(KERNELVERSION)' | awk -F '.'     '{print $$2}')
V3 := $(shell echo '$(KERNELVERSION)' | awk -F '[.+~]' '{print $$3}')
DVBCORE_BUILD_DIR := $(CURDIR)/dvbcore
DVBLOOPBACK_BUILD_DIR := $(CURDIR)/dvbloopback
FFDECSAWRAPPER_TARBALL := $(CURDIR)/ffdecsawrapper-$(PACKAGE_VERSION).tar.bz2

all: dvbcore dvbloopback


clean: clean_dvbcore clean_dvbloopback


dvbcore: clean_dvbcore
	mkdir -p '$(DVBCORE_BUILD_DIR)'
	
ifneq ($(wildcard /usr/src/linux-source-$(KERNELVERSION).tar.*),)
	ln -s /usr/src/linux-source-$(KERNELVERSION).tar.* "$(DVBCORE_BUILD_DIR)/linux-source`echo /usr/src/linux-source-$(KERNELVERSION).tar.* | grep -o .tar.*`"
else
  ifeq ($(V3),0)
	cd '$(DVBCORE_BUILD_DIR)'; apt-get download linux-source-$(KERNELVERSION)
	cd '$(DVBCORE_BUILD_DIR)'; s=linux-source-*.deb; d=`ar -t $$s | grep data.tar.`; ar x $$s $$d
	cd '$(DVBCORE_BUILD_DIR)'; tar xf data.tar.* --wildcards '*/usr/src/*linux-source*.tar.*'
	cd '$(DVBCORE_BUILD_DIR)'; find "$$PWD/usr/src" -name 'linux-source*tar.bz2' -exec ln -sf {} linux-source.tar.bz2 \;
	cd '$(DVBCORE_BUILD_DIR)'; find "$$PWD/usr/src" -name 'linux-source*tar.xz' -exec ln -sf {} linux-source.tar.xz \;
  else
	curl https://www.kernel.org/pub/linux/kernel/v$(V1).x/linux-$(V1).$(V2).$(V3).tar.xz > '$(DVBCORE_BUILD_DIR)/linux-source.tar.xz'
  endif
endif
	
ifeq ($(shell dpkg --compare-versions "$(KERNELVERSION)" lt '3.13'; echo $$?),0)
  ifeq ($(shell dpkg --compare-versions "$(KERNELVERSION)" lt '3.7'; echo $$?),0)
	tar xf '$(DVBCORE_BUILD_DIR)'/linux-source.tar.* -C '$(DVBCORE_BUILD_DIR)' --strip-components 5 --wildcards '*/drivers/media/dvb/dvb-core/'
	tar xjfO '$(FFDECSAWRAPPER_TARBALL)' linux-2.6.38-dvb-mutex.patch | patch -p4 -d '$(DVBCORE_BUILD_DIR)'
  else
	tar xf '$(DVBCORE_BUILD_DIR)'/linux-source.tar.* -C '$(DVBCORE_BUILD_DIR)' --strip-components 4 --wildcards '*/drivers/media/dvb-core/'
	tar xjfO '$(FFDECSAWRAPPER_TARBALL)' linux-3.7-dvb-mutex.patch | patch -p3 -d '$(DVBCORE_BUILD_DIR)'
  endif
else
	tar xf '$(DVBCORE_BUILD_DIR)'/linux-source.tar.* -C '$(DVBCORE_BUILD_DIR)' --strip-components 4 --wildcards '*/drivers/media/dvb-core/'
	tar xjfO '$(FFDECSAWRAPPER_TARBALL)' linux-3.13-dvb-mutex.patch | patch -p3 -d '$(DVBCORE_BUILD_DIR)'
endif
	
	$(MAKE) -C '/lib/modules/$(KERNELRELEASE)/build' M='$(DVBCORE_BUILD_DIR)' modules


clean_dvbcore:
	rm -rf '$(DVBCORE_BUILD_DIR)'


dvbloopback:
	tar xjf $(FFDECSAWRAPPER_TARBALL) dvbloopback
	cp /lib/modules/$(KERNELRELEASE)/build/Module.symvers '$(DVBLOOPBACK_BUILD_DIR)/module/Module.symvers'
	
ifeq ($(shell dpkg --compare-versions '$(KERNELVERSION)' lt '3.7'; echo $$?),0)
	cp -f '$(DVBLOOPBACK_BUILD_DIR)/module/dvbdev-2.6.38.h' '$(DVBLOOPBACK_BUILD_DIR)/module/dvbdev.h'
else
	cp -f '$(DVBLOOPBACK_BUILD_DIR)/module/dvbdev-3.7.x.h' '$(DVBLOOPBACK_BUILD_DIR)/module/dvbdev.h'
endif
	
	cd '$(DVBLOOPBACK_BUILD_DIR)/module' && $(MAKE) BUILD_DIR='/lib/modules/$(KERNELRELEASE)/build' MODDIR='$(DVBLOOPBACK_BUILD_DIR)/module' SYMVER='$(DVBLOOPBACK_BUILD_DIR)/module/Module.symvers'


clean_dvbloopback:
	rm -rf '$(DVBLOOPBACK_BUILD_DIR)'
