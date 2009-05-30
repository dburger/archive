/* This was a big help:

http://www.mathcs.carleton.edu/faculty/jondich/cs307/documents/syscall.html

   check it out if it is still around!
*/

/*
 * The following discussion contains full paths, starting with /, or
 * relative to the top of the linux source tree...probably /usr/src/linux-2.4
 *
 */


/*
 * 1. Make backups of:
 *      arch/i386/kernel/entry.S
 *      include/asm/unistd.h
 *      /usr/include/asm/unistd.h
 *      kernel/time.c
 */

/*
 * 2. Modify the original entry.S adding this to the obvious location:
 */ 

	.long SYMBOL_NAME(sys_pedagogictime)	/* 222 at the time */
/*
 * 3. Add the following to the obvious location in include/asm/unistd.h:
 */

#define __NR_pedagogictime	222

/*
 * 4. Copy the modified version of unistd.h into /usr/include/asm (yep,
 * overwite it).
 */

/*
 * 5. Add the code for the system call to the bottom of kernel/time.c.  Here
 * is what mine looked like:
 */

asmlinkage int sys_pedagogictime(int flag, struct timeval *tv) {
  /* code taken from gettimeofday above */
  if (tv) {
    struct timeval ktv;
    do_gettimeofday(&ktv);
    if (copy_to_user(tv, &ktv, sizeof(ktv)))
      return 0; /* return false if fails */
    if (flag)
      /* hey, shouldn't this be %ld */
      printk("pedagogictime called at: %d %d\n",ktv.tv_sec, ktv.tv_usec);
    return 1; /* returning true for success */
  }
  return 0;
}

/*
 * 6. Compile the new kernel.  Since I haven't added new files or changed
 * #include statements in existing ones I should be able to get away with
 * doing only "make bzImage".
 */

/*
 * 7. Copy the /usr/src/linux-2.4/arch/i386/boot/bzImage to
 * /boot/what you are going to call it.
 */

/*
 * 8. Set up /boot/grub/grub.conf so it can boot to that new kernel image
 * (all you need is the kernel line like the others), reboot and enjoy...well,
 * actually test your program with tester.c.  Remember the output of the printk
 * statments will go to /var/log/messages.
 */

/*
 * 9. To restore all your kernel source put the backed up entry.S back where
 * it belongs (arch/i386/kernel/entry.S), and put the backed up unistd.h back
 * in the 2 places it belongs (include/asm/ and /usr/include/asm),
 * and put time.c back where it belongs (kernel/time.c).  You can also remove
 * that new kernel from the /boot directory and take it out of grub as well.
 *
 * AS FOR NOW, I'VE LEFT ALL THIS CRAP ON MY SYSTEM.
 */
