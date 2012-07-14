#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PAGESIZE	2048
#define PAGECOUNT	 720
#define LINESIZE	  80
#define LINECOUNT	  25

char page[PAGESIZE];

void remove_trailing_newline(char *);

/*
 * txt2page - convert a text file into a BefOS page.
 */
int
main(int argc, char **argv)
{
	int i = 1;
	char line[2048];
	
	bzero(page, PAGESIZE);
	for (i = 0; i < LINECOUNT; i++) {
		bzero(line, LINESIZE);
		if (fgets(line, 2048, stdin) == NULL)
			break;
		remove_trailing_newline(line);
		strncpy(&page[i * LINESIZE], line, LINESIZE);
	}

	/* TODO: MSDOS: set stdout to binary mode */
	fwrite(page, PAGESIZE, 1, stdout);
	return(0);
}

void
remove_trailing_newline(char *s)
{
	int i;

	i = strlen(s) - 1;
	while (s[i] == '\n' && i >= 0)
		s[i--] = 0;
}