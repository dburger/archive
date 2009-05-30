#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/proc_fs.h>

#define BUF_LEN 50 /* enough to hold the sec and usec of xtime */
#define PROC_FILENAME_LEN 8
#define PROC_FILENAME "my_xtime"

/*
 * Registered as the read_proc for the module /proc file.  Returns a string
 * containing the values in the kernel variable xtime.  In this simplified
 * example it is assumed that every read will read the entire contents and
 * any subsequent read is given an EOF.
 */
int my_read(char *buf, char **buf_loc, off_t offset, int buf_len, int *eof, void *data) {
  int len; /* length of data returned */
  static char my_buf[BUF_LEN];

  /* we give all the info in one read, so requests for more get eof */
  if (offset>0) return 0;

  /* fill the buffer, xtime is available because exported in ksyms.h */
  len = sprintf(my_buf,"%ld %ld",xtime.tv_sec,xtime.tv_usec);

  /* tell reader where to find the buffer */
  *buf_loc = my_buf;

  /* and return the length */
  return len; 
}

/*
 * Function that is called when insmod is called to insert the module.
 * Here we register the proc file my_xtime.  Note that the old way:
 *
 * return proc_register(&proc_root, &my_mod_proc_file);
 *
 * showed in Kernel Projects for Linux is no longer valid in the
 * latest (2.4 anyway) kernels.  Now the proper way is to use
 * create_proc_entry, however, here we can get away with the simpler
 * create_proc_read_entry as shown below.
 */
int init_module() {
  return create_proc_read_entry(PROC_FILENAME, S_IFREG | S_IRUGO,
                                NULL, my_read, NULL) == NULL;
}

/*
 * Function that is called when rmmod is called to remove the module.
 * Here we unregister the proc file my_xtime.  Note that the old way:
 *
 * proc_unregister(&proc_root, my_mod_proc_file.low_ino);
 *
 * showed in Kernel Projects for Linux is no longer valid in the
 * latest (2.4 anyway) kernels.  Now the proper way is to use
 * remove_proc_entry as shown below.
 */
void cleanup_module() {
  remove_proc_entry(PROC_FILENAME,&proc_root);
}
