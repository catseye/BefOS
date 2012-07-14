# Makefile for generating misc BefOS pages.
# $Id: Makefile 62 2006-02-05 04:39:58Z catseye $

CP=cp
OBJDIR=../../obj
BINDIR=../../bin

all: $(OBJDIR)/welcome.bin $(OBJDIR)/legend.bin

$(OBJDIR)/welcome.bin: welcome.txt
	$(BINDIR)/txt2page < welcome.txt > $(.TARGET)

$(OBJDIR)/legend.bin: legend.bin
	$(CP) legend.bin $(.TARGET)

clean:
	rm -f $(OBJDIR)/*.bin
