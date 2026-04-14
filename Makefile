V=1

all:

install: install-program install-initcpio install-config

install-program:
	install -D -m 755 system-iso.sh $(DESTDIR)/usr/bin/system-iso

install-config:
	install -d -m 755 $(DESTDIR)/usr/share/system-iso
	cp -a --no-preserve=ownership j/* $(DESTDIR)/usr/share/system-iso/

dist:
	tar -cf - . | xz -9 -c - > system-iso-$(V).tar.xz
	gpg --detach-sign --yes --use-agent system-iso-$(V).tar.xz

.PHONY: install install-program install-config dist
