import java.util.LinkedList;

/**
 * Used to provide policy based access to a shared resource.  The policy is as
 * follows:
 * 
 *    readers - any number of simultaneous readers may exist, but not if
 *              there is a writer updating the shared resource
 *    writers - writers are allowed to access one at a time, but not if there
 *              are any readers
 * 
 *      Because in most server situations the number of reads will be greater
 *      than the number of writes, and writes are likely to be more time
 *      consuming than reads, I have implemented a flushing policy.  That is
 *      that whenever a write takes place reads that come in during the write
 *      operation are placed on a queue of waiting readers.  When the write
 *      operation completes the waiting readers are given priority as they are
 *      all "flushed" before other operations take place.  With a constant flow
 *      of readers and writers the flow of execution becomes:
 * 
 *      Allow one writer, flush waiting readers, repeat...
 */
public class ReadWriteLock {

    private int numReaders = 0;
    private int numReadersWaiting = 0;

    private int numWriters = 0;
    private LinkedList waitingWriters = new LinkedList();

    /**
     * Called before write access to the shared resource.  Allows only one
     * writer at a time with zero readers.
     */
    public void acquireWriteLock() {
        Object lock = new Object();
        synchronized (lock) {
            synchronized (this) {
                if (numReaders == 0 && numWriters == 0 &&
                    waitingWriters.size() == 0) {
                    numWriters++;
                    return;
                }
                // need to wait, to keep order, add to end of linked list
                waitingWriters.addLast(lock);
            }
            try {
                lock.wait();
            } catch (InterruptedException e) {
            }
        }
    }

    /**
     * Called after write access to the shared resource.  Will allow
     * all readers waiting for read access to be flushed before another
     * write will be considered, otherwise will let the next writer go.
     */
    public synchronized void releaseWriteLock() {
        numWriters--;
        if (numReadersWaiting > 0) {
            numReaders = numReadersWaiting;
            numReadersWaiting = 0;
            notifyAll();
        } else if (waitingWriters.size() > 0) {
            numWriters++;
            Object writer = waitingWriters.removeFirst();
            synchronized (writer) {
                writer.notify();
            }
        }
    }

    /**
     * Called before read access to the shared resource.  Will block if there
     * is a writer or there are writers waiting.
     */
    public synchronized void acquireReadLock() {
        numReadersWaiting++;
        if (numWriters > 0 || waitingWriters.size() > 0) {
            try {
                wait();
            } catch (InterruptedException e) {
            }
        } else {
            numReadersWaiting--;
            numReaders++;
        }
    }

    /**
     * Called after read access to the shared resource.  Will release
     * the next writer if the number of readers goes to 0.
     */
    public synchronized void releaseReadLock() {
        numReaders--;
        if (numReaders == 0 && waitingWriters.size() > 0) {
            numWriters++;
            Object writer = waitingWriters.removeFirst();
            synchronized (writer) {
                writer.notify();
            }
        }
    }

}
