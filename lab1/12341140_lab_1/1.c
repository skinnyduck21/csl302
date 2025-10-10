#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int isKeyword(char *word) {
	return strcmp(word, "foreach")==0 || strcmp(word, "echo")==0 || strcmp(word, "read")==0;
}

int isIdentifier(char *word) {
	int length=strlen(word);
	if(length==0 || length==1) {
		return 0;
	}
	if(word[0]!='_') {
		return 0;
	}
	if(!(word[length-1]>='0' && word[length-1]<='9')) {
		return 0;
	}
	for(int i=1; i<length-1; i++) {
		if(!(word[i]>='a' && word[i]<='z')) {
			return 0;
		}
	}
	return 1;
}

int main(int argc, char *argv[]) {
	if(argc<2) {
		printf("Usage: %s <inputfile>\n", argv[0]);
		return 1;
	}
	FILE* fptr=fopen(argv[1], "r");
	if(fptr==NULL) {
		fprintf(stderr, "Error opening the file\n");
		return 1;
	}
	char word[100];
	printf("Keywords:\n");
	while(fscanf(fptr, "%s", word) == 1) {
		if(isKeyword(word)) {
			printf("%s\n", word);
		}
	}
	rewind(fptr);
	printf("\nIdentifiers:\n");
	while(fscanf(fptr, "%s", word)==1) {
		if(isIdentifier(word)) {
			printf("%s\n", word);
		}
	}
	return 0;
}
