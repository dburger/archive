/**
 * Used in the chained sieve prime finding algorithm.  Checks if the passed in
 * value is divisible by this prime, if it is it is discarded.  If it is not it
 * is passed to the neighbor if one exists, or it is used in the construction
 * of a new prime if no neighbor exists.
 */
public class Prime extends Thread {

  private static final int DONE = -1;  // the sentinel passed in to shut down
  private static final int INVALID = -2; // used to track when check is valid

  private int index;  // index of this prime
  private int prime;  // value of this prime
  private int candidate = Prime.INVALID;  // check starts out INVALID

  private Prime next = null;  // the neighbor to pass possible primes to

  private PG guiGenerator = null;  // GUI for callbacks

  private static final boolean DEBUG = false; // to turn on/off debug output

  /**
   * Creates the Prime object.
   * 
   * @param prime  the value of this prime
   * @param guiGenerator
   *               the GUI for callbacks
   * @param index  the index of this prime
   */
  public Prime(int prime, PG guiGenerator, int index) {
    if (Prime.DEBUG) System.out.println(this.index + ": " + this.prime +
                                        " in constructor");
    this.prime = prime;
    this.index = index;
    this.guiGenerator = guiGenerator;
    if (this.guiGenerator != null) {
      this.guiGenerator.setValue(this.index, this.prime);
    }
  }

  /**
   * Used to pass a candidate value into this Prime.  Will block while there is
   * already a valid prime waiting to be retrieved by using get()
   * 
   * @param value  the value to be checked for primeness
   */
  public synchronized void pass(int value) {
    if (Prime.DEBUG) System.out.println(this.index + ": " + this.prime +
                                        " in pass ");
    while (this.candidate != Prime.INVALID) {
      try { wait(); } catch (Exception e) { }
    }
    this.candidate = value;
    notify();
  }

  /**
   * Used to retrieve the next candidate from this Prime.  Blocks until a valid
   * candidate is available.
   * 
   * @return next candidate prime to check
   */
  private synchronized int get() {
    if (Prime.DEBUG) System.out.println(this.index + ": " + this.prime +
                                        " in get");
    while (this.candidate == Prime.INVALID) {
      try { wait(); } catch (Exception e) { }
    }
    int current = this.candidate;
    this.candidate = Prime.INVALID;
    notify();
    return current;
  }

  /**
   * Run loop for thread.  Calls check to wait for a value to check or the
   * sentinel to end.  The value of check is then checked to see if it is time
   * to shutdown.
   */
  public void run() {
    int currentCandidate;
    for (;;) {
      if ((currentCandidate = get()) == Prime.DONE) {
        if (this.next != null) this.next.pass(Prime.DONE);
        System.out.println(this.index + ": " + this.prime + " going down");
        return;
      } else {
        if (this.guiGenerator != null) {
          this.guiGenerator.setCandidate(this.index, currentCandidate);
        }
        if (currentCandidate % this.prime != 0) {
          if (this.next == null) {
            this.next = new Prime(currentCandidate, this.guiGenerator,
                                  this.index + 1);
            this.next.start();
          } else {
            this.next.pass(currentCandidate);
          }
        }
        if (this.guiGenerator != null) {
          this.guiGenerator.removeCandidate(this.index);
        }
      }
    }
  }

}
