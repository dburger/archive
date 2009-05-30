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
 *      arch/i386/mm/fault.c
 */

/*
 * 2. Modify the original entry.S adding this to the obvious location:
 */ 

.long SYMBOL_NAME(sys_init_pfmeter)	/* 222 at the time */
.long SYMBOL_NAME(sys_check_pfmeter)	/* 223 at the time */

/*
 * 3. Add the following to the obvious location in include/asm/unistd.h:
 */

#define __NR_init_pfmeter	222
#define __NR_check_pfmeter	223


/*
 * 4. Copy the modified version of unistd.h into /usr/include/asm (yep,
 * overwite it).
 */

/*
 * 5. Add the following variables to the /usr/src/linux-2.4/arch/i386/mm/fault.c file:
 */

int pfmeter_pid = -1;
int pfmeter_cnt = 0;
struct timeval pfmeter_start;

/*
 * 6. Add the following functions to the bottom of /usr/src/linux-2.4/arch/i386/mm/fault.c file:
 */

asmlinkage void sys_init_pfmeter(int pid) {

  pfmeter_pid = pid;
  pfmeter_cnt = 0;

  do_gettimeofday(&pfmeter_start);

  /* this will stamp the start time in the /var/log/messages file */
  printk("pfmeter started for pid %d\n", pfmeter_pid);
  printk("pfmeter start sec  %ld\n", pfmeter_start.tv_sec);
  printk("pfmeter start usec %ld\n", pfmeter_start.tv_usec);

}

asmlinkage int sys_check_pfmeter(int span) {

  int secs;
  struct timeval now;

  do_gettimeofday(&now);

  if (span<1 || (secs=now.tv_sec - pfmeter_start.tv_sec)==0)
    return 0;

  /* pages faults per span during the time the meter has been on */
  return (pfmeter_cnt * span) / secs;

}

/*
 * 7. Add the following code to the do_fault_page function in
 * arch/i386/mm/fault.c:
 */

tsk = current; /* <-- this is already in the file, rest is mine */
if (pfmeter_pid==0 || tsk->pid==pfmeter_pid) {
  pfmeter_cnt++;
  printk("doing page fault %d for %d\n",pfmeter_cnt,tsk->pid);
}

/*
 * 8. Compile the new kernel.  Since I haven't added new files or changed
 * #include statements in existing ones I should be able to get away with
 * doing only "make bzImage".
 */

/*
 * 9. Copy the /usr/src/linux-2.4/arch/i386/boot/bzImage to
 * /boot/what you are going to call it.
 */

/*
 * 10. Set up /boot/grub/grub.conf so it can boot to that new kernel image
 * (all you need is the kernel line like the others), reboot and enjoy...well,
 * actually test your program with tester.c.  Remember the output of the printk
 * statments will go to /var/log/messages.
 */

/*
 * 11. To restore all your kernel source put the backed up entry.S back where
 * it belongs (arch/i386/kernel/entry.S), and put the backed up unistd.h back
 * in the 2 places it belongs (include/linux/unistd.h and /usr/include/asm),
 * and put fault.c back where it belongs (arch/i386/mm/fault.c).  You can also
 * remove that new kernel from the /boot directory and take it out of grub as
 * well.
 *
 */

/*
 * NOTE: It is possible to do this assignment two different ways.  The way I
 * have done it allows you to choose to meter an individual program or all
 * pids.  It is also very possible to modify the kernel so that you are
 * able to track any process at any time without having to init the fault
 * module to watching on one pid or globally all pids.  In that case I this
 * assigment can be done by adjusting the code to work in the following way:
 *
 * 1. Add a variable to struct task_struct to track the number of page faults,
 * such as pf_cnt.
 * 2. Init can be used to reset all the pf_cnt to 0.  To init to 0 something
 * like this would have to happen:
 *
 * struct task_struct *p;
 *
 * read_lock(&tasklist_lock);
 * p = find_task_by_pid( something that always exists, 0 or 1 ???);
 *
 * for_each_task(p) p->pf_cnt = 0;
 *
 * read_unlock(&tasklist_lock);
 *
 *
 * Then fault.c would work similar to the above, except you would increment
 * the pf_cnt for the specific task_struct on each call:
 *
 * tsk = current; // already in the do_page_fault code
 * tsk->pf_cnt++; // need to lock ?
 * pfmeter_cnt++; // for all processes count
 *
 * If you wanted a pf_cnt for all processes, it should still be kept as a
 * variable private to the fault.c module.  Why should you not loop through
 * all processes to get the page fault count???  Well, processes will come,
 * and processes will go, and if you do a loop to get the count you will miss
 * all the processes that have already exited.  When they do ask for a page
 * fault reading, if it is a specific pid you can use find_task_by_pid to get
 * the associated tast_struct and then use the pf_cnt field along with the
 * already present start_time (unsigned long, must be in millis ???) to
 * determine the rate.  If they ask for the overall page fault reading then
 * pfmeter_cnt can be used in the calculation.
 */
