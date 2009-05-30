#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/wait.h>
#include <linux/sched.h>

#define MAX_EVNT 1000

/*
 * head of the list that will hold all active events,
 * this list is kept sorted by evnt_id so that an
 * available id can be found in O(n)
 */
struct list_head head;

/* represents an event with the associated id and wait queue */
struct evnt {
  int evnt_id;
  wait_queue_head_t waitq;
  struct list_head list;
};

/*
 * Initializes the evnt system by initializing the linked list that holds the
 * wait queues created for each event.
 * Called on boot in void __init ipc_init(void) in the file
 * /usr/src/linux-2.4/ipc/util.c where msg, sem, and shm are also initialized.
 */
void __init evnt_init() {
  printk("evnt_init()\n");
  INIT_LIST_HEAD(&head);
}

/*
 * Used to create a new evnt or determine the existence of an evnt.  If evnt
 * is 0 a new evnt is created and its id is returned.  If evnt is not 0 then
 * the corresponding evnt is searched for, and the id is echoed back to the
 * user if it is found, otherwise, -1 is returned.
 *
 * @param evnt    0 to create a new evnt, or evnt id to affirm existing evnt
 *
 * @return    evnt_id or -1 if existing evnt not found, or no slots available
 */
asmlinkage int sys_evntopen(int evnt) {
  int prev_id;
  struct evnt *e;
  struct list_head *p;

  printk("sys_evntopen\n");

  if (evnt) {
    /* existing event, make sure it exists */
    list_for_each(p,&head) {
      e = list_entry(p, struct evnt, list);
      if (evnt == e->evnt_id) return evnt;
    }
    /* didn't find it the evnt */
    return -1;
  } else {
    /* look for first available id, starting at 1 */
    prev_id = 0;
    list_for_each(p,&head) {
      e = list_entry(p, struct evnt, list);
      if ((e->evnt_id - prev_id) > 1) break;
      prev_id = e->evnt_id;
    }
    /* now p is pointing at evnt (or head) that has a gap BEFORE it */

    if (prev_id == MAX_EVNT) return -1;

    /* create the new evnt, putting it in the list in order */
    e = (struct evnt *)kmalloc(sizeof(struct evnt),GFP_USER);
    e->evnt_id = prev_id + 1;
    init_waitqueue_head(&e->waitq);
    /* the gap is BEFORE p, so add_tail with p as head */
    list_add_tail(&e->list,p);
    return e->evnt_id;
  }  
}

/*
 * Closes out an existing evnt.  If the evnt has waiting processes, they are
 * signaled before destroying the evnt.  If the evnt is not found, -1 is
 * returned.
 *
 * @param evnt    evnt to close out
 *
 * @return    echoes back the id of the event closed, or -1 if not found
 */
asmlinkage int sys_evntclose(int evnt) {
  struct evnt *e;
  struct list_head *p;

  printk("sys_evntclose\n");

  /* locate the associated event list */
  list_for_each(p,&head) {
    e = list_entry(p, struct evnt, list);
    if (evnt == e->evnt_id) {
      list_del(p);
      /* wake up any waiting processes */
      wake_up_interruptible(&e->waitq);
      kfree(e);
      return evnt;
    }
  }
  /* evnt not found */
  return -1;
}

/*
 * Called by a process to wait on evnt.
 *
 * @param evnt    id of evnt to wait on
 *
 * @return    evnt id after wait, or -1 if the evnt was
 *            not found
 */
asmlinkage int sys_evntwait(int evnt) {
  struct evnt *e;
  struct list_head *p;

  printk("sys_evntwait\n");

  /* locate the wait queue associated with evnt */
  list_for_each(p,&head) {
    e = list_entry(p, struct evnt, list);
    if (evnt == e->evnt_id) {
      interruptible_sleep_on(&e->waitq);
      return evnt;
    }
  }
  /* the evnt was not found */
  return -1;
}

/*
 * Called to signal and thus resume all processes waiting
 * on evnt.
 *
 * @param evnt    id of evnt to signal
 *
 */
asmlinkage void sys_evntsig(int evnt) {
  struct evnt *e;
  struct list_head *p;

  printk("sys_evntsig\n");

  /* locate the wait queue associated with evnt */
  list_for_each(p,&head) {
    e = list_entry(p, struct evnt, list);
    if (evnt == e->evnt_id) {
      wake_up_interruptible(&e->waitq);
      break;
    }
  }
  return;
}
