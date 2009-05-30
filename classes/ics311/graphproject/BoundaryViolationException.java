/**
 * Represents an invalid or empty container for 
 * <code>Sequence</code> interface.
 *
 * @see Sequence
 * @author Bruce Harris
 * @version 1.0
 */
public class BoundaryViolationException extends RuntimeException {
  
  /**
   * An exception that is thrown when boundary violation exceptions occur
   * 
   * @param err     the string for display with the error
   */
  public BoundaryViolationException(String err) {
    super(err);
  }
}
