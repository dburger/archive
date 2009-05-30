/**
 * Represents an invalid or empty container for 
 * <code>Sequence</code> interface.
 *
 * @see Sequence
 * @author Bruce Harris
 * @version 1.0
 */
public class EmptyContainerException extends RuntimeException {
  
  /**
   * the exception thrown when methods attempt to access elements of an empty container.
   * 
   * @param err    the string to display with the error
   */
  public EmptyContainerException(String err) {
    super(err);
  }
}
