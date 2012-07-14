#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PAGESIZE	2048
#define PAGECOUNT	 720

void write_block(FILE *, char *, int);
void make_bootable(FILE *);

char page[PAGESIZE];

/*
 * amalgam8 - take the various BefOS program binary files
 * and create a bootable disk image containing them.
 */
int
main(int argc, char **argv)
{
	int i = 1;
	FILE *outfile;
	
	if ((outfile = fopen(argv[1], "w")) == NULL)
		errx(1, "cannot create `%s'", argv[1]);

	/* blank out f by writing n number of blocks of zeroes to it */
	bzero(page, PAGESIZE);
	for (i = 0; i < PAGECOUNT; i++)
		fwrite(page, PAGESIZE, 1, outfile);

	for (i = 2; i < (argc-1); i += 2)
		write_block(outfile, argv[i], atoi(argv[i+1]));

	make_bootable(outfile);

	fclose(outfile);
}

void
write_block(FILE *outfile, char *filename, int pagepos)
{
	FILE *infile;
	int pos = pagepos * PAGESIZE;
	int block = 1;

	printf("writing %s at page %d...\n", filename, pagepos);
	if ((infile = fopen(filename, "r")) == NULL)
		errx(1, "cannot read `%s'", filename);

	while(!feof(infile)) {
		printf("\twriting block %d...\n", block++);
		bzero(page, PAGESIZE);
		fread(page, PAGESIZE, 1, infile);
		fseek(outfile, pos, SEEK_SET);
		fwrite(page, PAGESIZE, 1, outfile);
		pos += PAGESIZE;
	}
}

void
make_bootable(FILE *outfile)
{
	fseek(outfile, 510, SEEK_SET);
	fwrite("\x55\xaa", 2, 1, outfile);
}
