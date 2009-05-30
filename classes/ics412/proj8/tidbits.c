/*
 * Please note that chapter 6 of Linux Device drivers had a fantastic chapter
 * on weight queues (which are different from when Kernel Projects for Linux
 * was published) which can be found here:
 * http://www.xml.com/ldd/chapter/book/ch06.html
 */

/*
 * 1. Added my evnt.c file to the Makefile in /usr/src/linux-2.4/ipc/Makefile:
 *
 * obj-$(CONFIG_SYSVIPC) += msg.o sem.o shm.o evnt.o
 */

/*
 * 2. Made the file /usr/src/linux-2.4/ipc/evnt.c.  See the included file.
 */

/*
 * 3. Added evnt_init(); where the other ipc systems get inited in
 * void __init ipc_init(void); in /usr/src/linux-2.4/ipc/util.c.
 */

/*
 * 4. Add the following to /usr/src/linux-2.4/arch/i386/kernel/entry.S:
 */

	.long SYMBOL_NAME(sys_evntopen)		/* 222 */
	.long SYMBOL_NAME(sys_evntclose)	/* 223 */
	.long SYMBOL_NAME(sys_evntwait)		/* 224 */
	.long SYMBOL_NAME(sys_evntsig)		/* 225 */

/*
 * 5. Add the following to the obvious location in
 * /usr/src/linux-2.4/include/asm/unistd.h:
 */

#define __NR_evntopen		222
#define __NR_evntclose		223
#define __NR_evntwait		224
#define __NR_evntsig		225

/*
 * 6. Copy the modifed version of unistd.h into /usr/include/asm (yep,
 * overwrite it).
 */

/*
 * 7. Dropped the included evnt.c file into /usr/src/linux-2.4/ipc/.
 */

/*
 * 8. Recompile the kernel and enjoy!
 */
