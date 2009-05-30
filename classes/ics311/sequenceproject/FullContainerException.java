/**
 * An exception to be thrown when attempting to add to a full Container
 */
public class FullContainerException extends RuntimeException {

    /**
     * The exception to be thrown when attempting to add to a full Container
     * 
     * @param s      the string to display with the error
     */
    FullContainerException(String s) {
        super(s);
    }

}
