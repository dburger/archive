/**
 * Interface designed for classes that wish to send string
 * messages to another class.
 * 
 * @author David J. Burger
 * @version 1.0
 * @since 06/19/01
 */
public interface Status {
    /**
     * Method called to send a string message to another class.
     * 
     * @param sStatus The string message to send.
     */
    public void status(String sStatus);
}
