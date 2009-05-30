#define O_READ 0
#define O_WRITE 1

int fd_load(char *drive);
void fd_close();
int fd_ls();
int fd_cd(char *directory);
int fd_rm(char *name);
void fd_pwd();
int fd_mkdir(char *name);
int fd_cp(char *src, char *dst);

int fd_fopen(char *name, int mode);
int fd_fread(int fd, char *buf, int len);
int fd_fwrite(int fd, char *buf, int len);
int fd_fseek(int fd, int offset);
void fd_fclose(int fd);
