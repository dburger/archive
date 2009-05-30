/**
 * Exception used for invalid keys
 * 
 * @author digitalOverflow
 */
public class InvalidKeyException extends RuntimeException {

    /**
     * An exception to throw for an invalid key
     * 
     * @param s      the String to display with the exception
     */
    InvalidKeyException(String s) {
        super(s);
    }

}
