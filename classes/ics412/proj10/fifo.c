#include <linux/kernel.h> /* for prink for now */
#include <linux/module.h> /* hey, it IS a module */
#include <linux/init.h> /* for the new style init and cleanup naming */
#include <linux/fs.h> /* for the file_operations */
#include <linux/slab.h> /* for kmalloc and friends */
#include <asm/uaccess.h> /* copy_to_user copy_from_user */
#include <linux/wait.h> /* wait queues */

#define MIN(A, B) ((A) < (B) ? (A) : (B))

#define DEVICE_NAME "fifo"
#define DEFAULT_FIFOS 4
#define MAX_FIFOS 100

/*
 * One fifo_struct is made for each fifo that is created.  Please note that
 * for SMP systems it would be necessary to add a semaphore to this struct
 * to protect the fifo from race conditions.  Due to the non-preemptive
 * nature of the Linux kernel on uniprocessor systems this is not a problem.
 */
struct fifo_struct {
  size_t len;
  char *buf;
  int write_cnt;
  wait_queue_head_t waitq;
};

static int major_number;
static struct fifo_struct *fifo;

/*
 * MODULE_PARM is a macro that picks up insmod command line parameters.  For
 * this program it can be set with: insmod fifo_cnt=##
 */
static int fifo_cnt = DEFAULT_FIFOS;
MODULE_PARM(fifo_cnt, "i");

/* forward declares so that the file_operations structs can follow */
static int fifo_open(struct inode *inode, struct file *filp);
static int fifo_release(struct inode *inode, struct file *filp);
static ssize_t fifo_read(struct file *filp, char *buf, size_t len, loff_t *p);
static ssize_t fifo_write(struct file *filp, const char *buf, size_t len, loff_t *p);

/* 
 * file_operations structs specific for open, reading, and writing.
 * Of course the one for reading doesn't need write and vice versa.
 * Here the tagged format available with the gnu compiler is used to
 * initiative the file_operations.
 * Note that owner: THIS_MODULE is necessary for reference count and is
 * available in 2.4+, otherwise need to use SET_MODULE_OWNER macro.
 */
static struct file_operations fifo_fops = {
  open: fifo_open,
  release: fifo_release,
  owner: THIS_MODULE
};

static struct file_operations fifo_read_fops = {
  read: fifo_read,
  release: fifo_release,
  owner: THIS_MODULE
};

static struct file_operations fifo_write_fops = {
  write: fifo_write,
  release: fifo_release,
  owner: THIS_MODULE
};

/*
 * Accepts open calls on the device.
 */
static int fifo_open(struct inode *inode, struct file *filp) {
  int minor_number = MINOR(inode->i_rdev);
  int fifo_idx = minor_number / 2;
  int read_end = minor_number % 2; /* read end is odd end */

  printk("%s: open was called on %d\n", DEVICE_NAME, minor_number);

  if (!read_end) {
    fifo[fifo_idx].write_cnt++;
    filp->f_op = &fifo_write_fops;
  } else {
    filp->f_op = &fifo_read_fops;
  }

  /* private_data is set to the proper fifo according to the minor_number */
  filp->private_data = &fifo[fifo_idx];

  return 0;

}

/*
 * Accepts release calls on the device.  Note that these do not always
 * correspond to close calls as descriptors can be duped and therefore
 * only when all have been closed is release called.
 */
static int fifo_release(struct inode *inode, struct file *filp) {
  int minor_number = MINOR(inode->i_rdev);
  int read_end = minor_number % 2; /* read end is odd end */
  struct fifo_struct *f = filp->private_data;

  printk("%s: release was called on %d\n", DEVICE_NAME, minor_number);

  if (!read_end) f->write_cnt--;

  printk("%d and %d\n",f->write_cnt,f->len);

  /*
   * As per instructions, no open for write and no data makes for EOF,
   * so any waiting readers are awoken at this point.
   */
  if (f->write_cnt==0 && f->len==0) {
    wake_up_interruptible(&f->waitq);
  }

  return 0;

}

/*
 * Accepts read calls on the device.  Reads on a device not open for writing
 * with an empty buffer get EOF.
 */
static ssize_t fifo_read(struct file *filp, char *buf, size_t len, loff_t *p) {
  char *newbuf;
  int bytes_to_copy;
  struct fifo_struct *f = filp->private_data;

  printk("%s: read was called\n", DEVICE_NAME);

  /* interruptible so CTRL-C can break it */
  if (f->write_cnt>0 && f->len==0) {
    interruptible_sleep_on(&f->waitq);
  }

  /* as per instructions, no open for write and no data makes for EOF */
  if (f->write_cnt==0 && f->len==0) return 0;

  /* f->len - len <= 0 gives us a NULL */
  newbuf = kmalloc(f->len - len, GFP_KERNEL);
  if (newbuf==NULL && (f->len > len)) {
    printk("%s: fifo_read unable to allocate buffer space\n", DEVICE_NAME);
    return -ENOMEM;
  }

  bytes_to_copy = MIN(f->len, len);

  if (copy_to_user(buf, f->buf, bytes_to_copy)!=0) {
    printk("%s: unable to copy to user\n", DEVICE_NAME);
    kfree(newbuf);
    return -EFAULT;
  }

  /* put the left over data in the new buffer */
  if (newbuf) memcpy(newbuf, f->buf + len, f->len - len);

  /* free the old buffer and set it to the new buffer */
  kfree(f->buf);
  f->buf = newbuf;
  f->len = (f->len > len) ? (f->len - len) : 0;

  return bytes_to_copy;

}

/*
 * Accepts write calls on the device.
 */
static ssize_t fifo_write(struct file *filp, const char *buf, size_t len, loff_t *p) {
  struct fifo_struct *f = filp->private_data;
  char *newbuf;

  printk("%s: write was called\n", DEVICE_NAME);

  /* allocate enough space to hold the old buffer + the new data */
  newbuf = kmalloc(f->len + len, GFP_KERNEL);
  if (newbuf==NULL) {
    printk("%s: fifo_write unable to allocate buffer space\n", DEVICE_NAME);
    return -ENOMEM;
  }

  /* put the left over buffer in the new buffer */
  memcpy(newbuf,f->buf,f->len);

  /* add the new data to the new buffer */
  if (copy_from_user(newbuf + f->len, buf, len)!=0) {
    printk("%s: unable to copy from user\n", DEVICE_NAME);
    kfree(newbuf);
    return -EFAULT;
  }

  /* free the old buffer and set it to the new buffer */
  kfree(f->buf);
  f->buf = newbuf;
  f->len += len;

  /* in case any readers were sleeping on f->len == 0 */
  if (f->len > 0) wake_up_interruptible(&f->waitq);

  return len;
}

/*
 * Frees the memory associated with the device.
 */
static void free_mem() {
  int i;
  for (i=0;i<fifo_cnt;i++) {
    if (fifo[i].buf) kfree(fifo[i].buf);
  }
  kfree(fifo);
}

/*
 * The init_module function.  Creates the necessary fifos, initializes the
 * values, and registers the character device.  Note that the major number
 * is by dynamic assignment which is probably going to be 254 on most systems,
 * however, the value can be checked in /var/log/messages.
 */
int fifo_init() {
  int i;

  if (fifo_cnt < 1 || fifo_cnt > MAX_FIFOS) {
    printk("%s: fifo_cnt value %d invalid, reset to default %d\n",
           DEVICE_NAME,
           fifo_cnt,
           DEFAULT_FIFOS);
    fifo_cnt = DEFAULT_FIFOS;
  }

  if ((fifo = kmalloc(fifo_cnt*sizeof(struct fifo_struct),
      GFP_KERNEL))==NULL) {
    printk("%s: unable to allocate buffer space\n", DEVICE_NAME);
    return -ENOMEM;
  }

  for (i=0;i<fifo_cnt;i++) {
    fifo[i].len = 0;
    fifo[i].buf = NULL;
    fifo[i].write_cnt = 0;
    init_waitqueue_head(&fifo[i].waitq);
  }

  /* 0 as first parameter makes for dynamic major number assignment */
  if ((major_number = register_chrdev(0, DEVICE_NAME, &fifo_fops)) < 0) {
    printk("%s: unable to register device err code %d\n",
           DEVICE_NAME, major_number);
    free_mem();
    return major_number;
  }

  printk("%s: registered, major number %d with %d fifos\n",
         DEVICE_NAME, major_number, fifo_cnt);

  return 0;

}

/*
 * The cleanup_module function.  Frees the associated memory and unregisters
 * the device.
 */
void fifo_cleanup() {
  int flag;

  free_mem();

  if ((flag = unregister_chrdev(major_number, DEVICE_NAME)) < 0) {
    printk("%s: unable to unregister device err code %d\n",
           DEVICE_NAME, flag);
  } else {
    printk("%s: unregisterd\n", DEVICE_NAME);
  }

}

/*
 * Note that the above init and cleanup functions could have been called
 * init_module and cleanup_module but as of kernel 2.3.13 and later the
 * preferred way is to identify them as follows:
 */
module_init(fifo_init);
module_exit(fifo_cleanup);
