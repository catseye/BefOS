# Makefile for the tools to be placed in bin/
# (needs to build first, since these tools are used
# to assemble the final BefOS disk image.)
# $Id: Makefile 62 2006-02-05 04:39:58Z catseye $

CP=/bin/cp
CHMOD=/bin/chmod
CC=gcc
ASM=nasm
OBJDIR=../../obj
BINDIR=../../bin

all: $(BINDIR)/amalgam8 $(BINDIR)/extract8 \
     $(BINDIR)/txt2page \
     $(BINDIR)/mkbfinc.pl \
     $(BINDIR)/mkkeypg.pl

$(BINDIR)/amalgam8: amalgam8.c
	$(CC) -o $@ amalgam8.c

$(BINDIR)/extract8: extract8.c
	$(CC) -o $@ extract8.c

$(BINDIR)/txt2page: txt2page.c
	$(CC) -o $@ txt2page.c

$(BINDIR)/mkbfinc.pl: mkbfinc.pl
	$(CP) mkbfinc.pl $@
	$(CHMOD) 755 $@

$(BINDIR)/mkkeypg.pl: mkkeypg.pl
	$(CP) mkkeypg.pl $@
	$(CHMOD) 755 $@

clean:
	rm -f $(BINDIR)/*
