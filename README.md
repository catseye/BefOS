BefOS
=====

This is the reference distribution for BefOS, a toy Befunge-themed OS
written in 8086 assembler in the NASM format.

The contents of this distribution have been placed into the public
domain; see the file `UNLICENSE` for more information.

Note that this README is based on what was originally written for the
BefOS project way back in the 20th century.  Therefore parts of it may
be crufty, outdated, and generally unfashionable.  Probably best to
take it all with a grain of salt.

BefOS - an Operating System for the Linearly Challenged
-------------------------------------------------------

Current released version: 0.10
(See "Release History" below for some laughs.)

This work by Chris Pressey of Cat's Eye Technologies
has been placed into the public domain (see UNLICENSE.)

    ,---------------------------------------------------.
    | * WARNING! * CAUTION * PROCEED AT YOUR OWN RISK * |
    |                                                   |
    | *        THIS PRODUCT IS PROVIDED "AS IS"       * |
    |                                                   |
    | * CAT'S EYE TECHNOLOGIES CAN NOT BE HELD LIABLE * |
    | *    FOR ANY DAMAGES RESULTING FROM ITS USE     * |
    `---------------------------------------------------'

What is it?
-----------

BefOS is a toy OS written in 100% 8086 assembler.  It requires the
following hardware (or a decently emulated version thereof):

    Processor:      100% Intel 8086+ Compatible
    BIOS:           100% IBM PC Compatible
    Video:          100% VGA Compatible
    Keyboard:       100% Standard 101/102-Key Compatible
    RAM:            640K base
    Storage:        1.44M floppy drive 0 (A:)

BefOS was originally written in Borland's Turbo Assembler format,
but this version has been translated to use the format of the
free assembler NASM.  The sources can be built with either NASM or YASM.

Booting into BefOS
------------------

Using QEMU or some other emulator: point the emulated `A:` drive of
the emulator at the file `disk/befos.flp`, and boot from the floppy.
The 'test' target in `disk/Makefile` will run QEMU with this image
mounted in `A:`.

Using DOS or Windows 95: run `BEKERNEL.COM`.  Note that I'm not sure
if this works anymore; I haven't tried it recently.  In any case, you
still need a blank floppy in drive `A:`.

For real: install the floppy image `disk/befos.flp` onto a blank,
1.44M floppy disk, using a tool such as 'fdimage.exe' (which is
available at ftp://ftp.freebsd.org/pub/FreeBSD/tools/).  Then
boot your computer with that floppy.

Using BefOS
-----------

Once you've booted into BefOS, you'll see a blue screen with some stuff
on it.

Here is a quick-and-dirty guide to the top line of this display:

    B               the BefOS 'logo.'
    (light)         yellow = working, green = worked, red = failed
    (4 hex digits)  amount of base memory available, in K
    (4 hex digits)  amount of extended memory available, in K
    (green bar)
    (4 hex digits)  link to next cluster of current cluster
    (4 hex digits)  link to previous cluster of current cluster
    (4 hex digits)  link to application cluster of current cluster
    (4 hex digits)  link to colour cluster of current cluster
    (4 hex digits)  link to help cluster of current cluster
    (green bar)
    (16 OEM chars)  description of current cluster
    (green bar)
    (4 hex digits)  value of last keystroke detected
    (2 hex digits)  value of current byte under cursor
    (4 hex digits)  current cluster number, starts at 0

And here are some key bindings: (NYI=Not Yet Implemented):

    PgUp            Up One Cluster 
    PgDn            Down One cluster
    
    Ctrl-PgUp       Link to Previous Cluster (header) (NYI)
    Ctrl-PgDn       Link to Next Cluster (header) (NYI)
    F1              Link to Help Cluster (header) (NYI)
    
    Up              Move Pointer Up One Row
    Down            Move Pointer Down One Row
    Left            Move Pointer Left One Column
    Right           Move Pointer Right One Column
    
    Alt-R           Run (execute page as machine code)
    
    F4              Change Properties (Header) (NYI)
    Alt--           Delete Properties (Header) (NYI)
    Alt-=           Initialize Properties (Header) (NYI)
    
    Alt-M           show More data on screen
    Alt-N           show less data on screeN
    
    Alt-G           Go to cluster number
    
    Alt-E           Edit: allow writes
    Alt-C           Copy cluster data & header to clipboard
        

In Edit Mode:

    ^2 (^@)         Write    0
    ^A to ^Z        Write    1 - 26
    ESC             Write   27
    ^\              Write   28      
    ^]              Write   29      
    ^6 (^^)         Write   30
    ^- (^_)         Write   31      
    Space           Write   32
    !..~            Write   33 - 126
    Ctrl-Bkspc      Write  127
    
    Alt-L           Load (refresh from disk)
    
    Alt-U           fill cluster Uniformly with current byte
    Alt-P           Paste cluster data & header from clipboard
    Alt-H           toggle High bit
    Alt-S           Save (commit changes to data & header to disk)

Under DOS only (not tested in a while):

    Alt-Q           Quit to DOS
    Alt-I           Install cluster from file.  Type the filename into
                    the start of the cluster buffer and terminate it
                    with a null (Ctrl-2)

Cluster Format
--------------

Each cluster has a 'header' which is in fact stored in the LAST
48 bytes of the second cluster.  The first 2000 bytes are data.
The header is structured thus:

    +------------------------------------------------+
    |VVNNPPAACCHHxxxxxxxxxxxxxxxxxxxxDDDDDDDDDDDDDDDD|
    +------------------------------------------------+
    
    VV = word indicating header type.
    
         bef0 indicates standard BefOS header, the only type supported.
    
    NN = word containing the cluster number of the next cluster.
    
         0000 indicates that there is no next cluster.
    
    PP = word containing the cluster number of the previous cluster.
    
         0000 indicates that there is no previous cluster.
    
    AA = word containing the cluster number of the first cluster of
         the application for which this is a document.
    
         0000 indicates that there is no special application for this
         generic document.
    
         ffff indicates that this IS an application written in
         x86 machine code.
    
    CC = word containing the cluster number of
         this cluster's colour cluster.
    
         0000 indicates that this cluster is monochrome.
    
    HH = 2 bytes containing the cluster number of
         this cluster's help-cluster.
    
         0000 indicates that this cluster is helpless.
    
    xxxxxxxxxxxxxxxxxxxx = 20 bytes reserved.
    
    DDDDDDDDDDDDDDDD = 16 bytes ASCII description e.g. "Seismology Now"



------------------------------------------------------------------

But the following is more like what I would like it to be...

------------------------------------------------------------------

First, we say that 1 "screen" is 4096 bytes:
  80x25char + 80x25colour + 96 bytes header.
A "tableau" is a set of 80x25 screens = 2000 * 4K = 8M.
  There is one tableau on the computer which maps to it's extended RAM.

One 1.44M floppy disk can contain six columns = 150 screens.

Header:

    +------------------------------------------------+
    |VVAAxxxxxxxxxxxxDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD|
    |DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD|
    +------------------------------------------------+
    
    VV = word indicating header type.
    
         bef0 indicates standard BefOS header, the only type supported.
    
    AA = word containing the cluster number of the first cluster of
         the application for which this is a document.
    
         0000 indicates that there is no special application for this
         generic document.
    
         ffff indicates that this IS an application written in
         x86 machine code.
    
    xxxxxxxxxxxx = 12 bytes reserved.
    
    DD..DD = 80 bytes ASCII description.


Building BefOS
--------------

BefOS can be built on Linux (and probably FreeBSD and Cygwin.)
Just type `./make.sh clean all` from the top level to build it all.

Here is what is in the various directories:

    bin/
        amalgam8      Constructs a boot disk image from BefOS objects
        extract8      Extracts BefOS objects from a boot disk image
        txt2page      Turns a text file into a BefOS object file
        mkbfinc.pl    Used during build to generate list of API calls
    disk/             Contains bootable BefOS boot disk images
    obj/              Contains BefOS objects that will be amalgamated
    src/              Contains source code for BefOS:
        apps/         Source code for the BefOS applications installed
        boot/         Source code for the boot disk's boot block
        inc/          Include files shared by many BefOS object sources
        kernel/       Source file for the core components of BefOS
        page/         Misc files that become BefOS pages on the disk
        tools/        Source code for the util programs put in bin/
        turbo/        The original Turbo Assembler sources for BefOS


Release History
---------------

*   v1999? v0.9? no version number? not sure
    
    The initial version.  Worked on and possibly released during 1999.

*   v2006.0204 a.k.a. v0.1-2006.0204 a.k.a. v0.8-2006.0204
    
    Translated to NASM.

*   v0.9-2011.0427
    
    Got rid of recursive Makefile.  Moved README (which still said
    "v2006.0204") into doc/ subdirectory.  Deleted a bunch of crap
    experimental source which was no longer used and was never
    translated to NASM anyway.  Added mkkeypg.pl to make a "Key Bindings"
    page within the disk image.  Added a putative TODO list.

*   v0.9-2012.0827
    
    Put it all into Mercurial and git; put it all into the public domain.
    Fixed build script.  Added public-domain sources (example of unreal
    mode) from zzo38's OS project.  Updated the version number in the
    README, but did not at the time tag the repo or make a release distfile.

*   v0.9-2014.0819
    
    Added another README, this one in Markdown.  Build with yasm instead
    of NASM and test with QEMU instead of Bochs.  Other minor cleanups.
    Did remember to tag this time, but still didn't make a release distfile.

*   v0.10
    
    Got running under v86 by introducing some conditional assembly.
    Removed the disk image from the repo, since it is a built binary.
    Improved the pre-populated pages (the table of contents was incorrect,
    added a "tutorial" page, etc.)  Removed key-bindings to commands that
    remain un(der)implemented.  Merged the READMEs.

Putative TODO list
------------------

*   Clean up the code base
*   Document the entry points
*   Abstract "main loop" out of bekernel.s, into editor.s
*   Switch to unreal mode on boot -- note, would no longer be pure 8086
*   Allow editing memory pages
    *   "current page" also needs "current device"
    *   can be just the base RAM for now
*   Implement an actual VM for it (likely something rather befungeoid, but
    not Befunge)
    *   Execute from "current exection page"
    *   If "current execution page" is "current displayed page",
        also update cursor while executing
*   Rewrite Editor in the befungeoid VM?
*   Fix syscalls
    *   Really, you should only be able to syscall a Beeble (=Befunge-05)
        instruction
