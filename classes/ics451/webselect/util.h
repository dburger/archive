/* used to change all characters in *s to lower case */
void locase(char *s);

/* returns the size of the file indicated by *name */
int filesize(char *name);

/* determines if the extension in *ext matches a lower case version *filename*/
int extMatch(char *filename, char *ext);
