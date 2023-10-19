V=1

INSTALL_FILES=$(wildcard initcpio/install/*)
HOOKS_FILES=$(wildcard initcpio/hooks/*)
SCRIPT_FILES=$(wildcard initcpio/script/*)

INSTALL_DIR=$(DESTDIR)/usr/lib/initcpio/install
HOOKS_DIR=$(DESTDIR)/usr/lib/initcpio/hooks
SCRIPT_DIR=$(DESTDIR)/usr/lib/initcpio

all:

install: install-program install-initcpio install-config

install-program:
	install -D -m 755 system/system-iso $(DESTDIR)/usr/bin/system-iso

install-initcpio:
	install -d $(SCRIPT_DIR) $(HOOKS_DIR) $(INSTALL_DIR)
	install -m 755 -t $(SCRIPT_DIR) $(SCRIPT_FILES)
	install -m 644 -t $(HOOKS_DIR) $(HOOKS_FILES)
	install -m 644 -t $(INSTALL_DIR) $(INSTALL_FILES)

install-config:
	install -d -m 755 $(DESTDIR)/usr/share/system-iso
	cp -a --no-preserve=ownership system/* $(DESTDIR)/usr/share/system-iso/

dist:
	tar -cf - . | xz -9 -c - > system-iso-$(V).tar.xz
	gpg --detach-sign --yes --use-agent system-iso-$(V).tar.xz

.PHONY: install install-program install-initcpio install-config dist
