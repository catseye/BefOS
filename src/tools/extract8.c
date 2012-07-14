#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PAGESIZE	2048
#define PAGECOUNT	 720

void extract_blocks(FILE *, char *, int, int);

char page[PAGESIZE];

/*
 * extract8 - extract binary images from given pages
 * on a BefOS boot disk.
 */
int
main(int argc, char **argv)
{
	int i = 1;
	FILE *infile;

	if ((infile = fopen(argv[1], "r")) == NULL)
		errx(1, "cannot read `%s'", argv[1]);

	for (i = 2; i < (argc - 2); i += 3)
		extract_blocks(infile, argv[i],
		    atoi(argv[i + 1]), atoi(argv[i + 2]));

	fclose(infile);
}

void
extract_blocks(FILE *infile, char *filename, int pagepos, int numpages)
{
	FILE *outfile;
	int pos = pagepos * PAGESIZE;
	int length = numpages * PAGESIZE;
	int pageno = 1;

	printf("writing %s from page %d...\n", filename, pagepos);
	if ((outfile = fopen(filename, "w")) == NULL)
		errx(1, "cannot create `%s'", filename);

	while(pageno <= numpages) {
		printf("\textracting page %d...\n", pageno++);
		bzero(page, PAGESIZE);
		fseek(infile, pos, SEEK_SET);
		fread(page, PAGESIZE, 1, infile);
		fwrite(page, PAGESIZE, 1, outfile);
		pos += PAGESIZE;
	}
	fclose(outfile);
}
