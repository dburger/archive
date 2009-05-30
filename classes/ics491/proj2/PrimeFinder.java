/**
 * Class used as a non GUI frontend to the thread prime sieve finder.  Should
 * be called with:
 * 
 * java PrimeFinder max
 */
public class PrimeFinder {

  /**
   * Main entry point to program.  Creates the initial Prime and then
   * generates values up to max.
   */
  public static void main(String args[]) {

    int max;  // max value to search to
    Prime next = null;  // first neighbor

    // check to make sure they passed in the max value to search to
    if (args.length == 0) {
      System.out.println("Proper usage of this program is:\n" +
                         "java PrimeFinder max\n" +
                         "where max is the maximum number to search up to for primes.");
      System.exit(1);
    }

    // check to make sure the value is positive
    if ((max = Integer.parseInt(args[0])) <= 2) {
      System.out.println("The value to search to must be greater than 2.");
      System.exit(1);
    }

    // we know 2 is prime so go ahead and make the first prime neighbor
    next = new Prime(2, null, 0);
    next.start();

    // now go from 3 up to the max
    for (int i = 3; i < max; i++) {
      next.pass(i);
    }

    // and then kill the neighbor threads
    next.pass(-1);

  }

}
