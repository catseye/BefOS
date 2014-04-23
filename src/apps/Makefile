# Makefile for some demo programs running under BefOS.

ASM?=yasm
OBJDIR?=../../obj

all: $(OBJDIR)/belife.com

$(OBJDIR)/belife.com: belife.s
	$(ASM) -f bin -o $@ -l belife.lst belife.s

$(OBJDIR)/befterm.com: befterm.s ../inc/bekernel.inc
	$(ASM) -f bin -o $@ -l befterm.lst befterm.s

clean:
	rm -f $(OBJDIR)/*.com *.lst

cleandist:
	echo 'OK'

test:
	echo 'OK'
