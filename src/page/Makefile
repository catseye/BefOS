# Makefile for generating misc BefOS pages.

CP?=cp
OBJDIR?=../../obj
BINDIR?=../../bin

all: $(OBJDIR)/welcome.bin \
     $(OBJDIR)/legend.bin \
     $(OBJDIR)/keybind.bin \
     $(OBJDIR)/tutorial.bin \
     $(OBJDIR)/license.bin

$(OBJDIR)/welcome.bin: welcome.txt
	$(BINDIR)/txt2page < welcome.txt > $@

$(OBJDIR)/tutorial.bin: tutorial.txt
	$(BINDIR)/txt2page < tutorial.txt > $@

$(OBJDIR)/license.bin: ../../UNLICENSE
	$(BINDIR)/txt2page < ../../UNLICENSE > $@

$(OBJDIR)/legend.bin: legend.bin
	$(CP) legend.bin $@

$(OBJDIR)/keybind.bin: ../inc/befkeys.inc
	$(BINDIR)/mkkeypg.pl < ../inc/befkeys.inc | column -c 79 | expand | $(BINDIR)/txt2page > $@

clean:
	rm -f $(OBJDIR)/*.bin

cleandist:
	echo 'OK'

test:
	echo 'OK'
