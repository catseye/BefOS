# Makefile for some demo programs running under BefOS.
# $Id: Makefile 62 2006-02-05 04:39:58Z catseye $

ASM=nasm
OBJDIR=../../obj

all: $(OBJDIR)/belife.com

$(OBJDIR)/belife.com: belife.s
	$(ASM) -f bin -o $@ -l belife.lst belife.s

$(OBJDIR)/befterm.com: befterm.s ../inc/bekernel.inc
	$(ASM) -f bin -o $@ -l befterm.lst befterm.s

clean:
	rm -f $(OBJDIR)/*.com *.lst
