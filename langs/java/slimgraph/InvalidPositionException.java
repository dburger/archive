package com.digitaloverflow.util;

/**
 * Represents an invalid position for <code>Sequence</code> interface.
 *
 * @see Sequence
 * @author Bruce Harris
 * @version 1.0
 */
public class InvalidPositionException extends RuntimeException {
  
  /**
   * The exception to thrown when an invalid position is passed into a Container
   * 
   * @param err    the string to display for the error
   */
  public InvalidPositionException(String err) {
    super(err);
  }
}
