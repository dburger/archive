/*
 * Note that Understanding the Linux Kernel Chapter 10, Process
 * Scheduling, was an invaluable resource to understanding the
 * Linux scheduler and specifically helpful in figuring out which
 * chunk of code needed to be replaced to implement fair
 * scheduling.  That was, of course, the part that set next to the
 * next process to run.  As of the time of this writing, the
 * chapter can still be found online here:
 * http://www.oreilly.com/catalog/linuxkernel/chapter/ch10.html
 */

/*
 * 1. sched.c was modified to implement fair scheduling.  The new
 * sched.c with fair scheduling is included in this directory.
 */

/*
 * 2. Because no new dependencies were required and no new files
 * were added compiling was merely a matter of make bzImage and
 * then copying bzImage into the boot directory.
 */

/*
 * 3. Instrumenting this was a pain in the a$$.  The fibonacci
 * program from chapter 3 was resurrected to help test the new
 * scheduler.  You can find this program in this directory called
 * schedtest.c.  By launching this program with values of 40+ with
 * many processes from one group, and only one from another, the
 * scheduler's impact can be seen.  As for in kernel instrumenting,
 * read the notes that follow...
 */

/*
 * 4. The last part of the assignment was to add instrumentation of
 * the scheduler into the kernel.  It was somewhat vague about what
 * should be tracked and of course context switch numbers are
 * already available.  So here we go again putting in a new system
 * call...so...make backups of:
 *  arch/i386/kernel/entry.S
 *  include/asm/unistd.h
 *  /usr/include/asm/unistd.h
 */

/*
 * 5. Modify the original entry.S adding this to the obivous location:
 */

.long SYMBOL_NAME(sys_schedictl)     /* 222 at the time */

/*
 * 6. Add the following to the obvious location in include/asm/unistd.h:
 */

#define __NR_schedictl     222

/*
 * 7. Copy the modified version of unistd.h into /usr/include/asm (yep,
 * overwrite it).
 */

/*
 * 8. The code for the system call is already in the modified sched.c in
 * this directory.  It is called sys_schedictl and is at the bottom of the
 * file.
 */

/*
 * 9. I wrote a user space program called schedictl, which is also buildable
 * via the included makefile, that will control the system call instrumentation
 * put into the kernel.  The command line options are -kid.  If you run it
 * without the k it turns on, or continues, instrumentation.  The i is to init
 * the instrumentation values back to 0.  The d is used to dump the stats into
 * /var/log/messages.  The stats that are kepts are:
 * resets - the number of times it "wraps around" to the lowest gid
 * zeros - the number of times it runs a process that has already exhausted its
 *         time quantum because another gid has more processes without 0
 *         priority processes
 * recalcs - the number of times that it recalculates the priorities
 *
 * Note that context switches is already available elsewhere.
 */

/*
 * 10. Compile and enjoy!
 */

