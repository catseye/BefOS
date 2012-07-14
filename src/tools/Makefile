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
     $(BINDIR)/mkbfinc.pl

$(BINDIR)/amalgam8: amalgam8.c
	$(CC) -o $(.TARGET) amalgam8.c

$(BINDIR)/extract8: extract8.c
	$(CC) -o $(.TARGET) extract8.c

$(BINDIR)/txt2page: txt2page.c
	$(CC) -o $(.TARGET) txt2page.c

$(BINDIR)/mkbfinc.pl: mkbfinc.pl
	$(CP) mkbfinc.pl $(.TARGET)
	$(CHMOD) 755 $(.TARGET)

clean:
	rm -f $(BINDIR)/*
