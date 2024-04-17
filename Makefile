prefix := $(HOME)

bindir := $(prefix)/bin

all:

test:
	$(MAKE) -C t

D = $(DESTDIR)

install:
	install -d -m 755 $(D)$(bindir)/
	install -m 755 git-smartlist $(D)$(bindir)/git-smartlist

.PHONY: all test install
