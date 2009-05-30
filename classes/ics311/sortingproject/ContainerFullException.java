/***************************************************************************
 * <CODE>ContainerFullException</CODE> --- Represents an invalid position for 
 *                                        <code>Sequence</code> interface.
 * @authors - Bruce Harris
 * @company - Byte Techies - {Brett Ishida, Peter Thok, Aaron Kagawa}
 *            Lecture: 311 Section 1 Spring 2001
 * @date      Date Created: Unknown
 * @ver       1.0           
 ***************************************************************************/
public class ContainerFullException extends RuntimeException {
  
  public ContainerFullException(String err) {
    super(err);
  }
} /* end ContainerFullException */
