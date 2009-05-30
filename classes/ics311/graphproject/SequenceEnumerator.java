import java.util.Enumeration;
import java.util.NoSuchElementException;
/**
 * An enumerator for Sequences
 * 
 * @author digitalOverflow
 */
public class SequenceEnumerator implements Enumeration {

    private Sequence S;
    private Position curr;

    /**
     * Constructor for SequenceEnumerator
     * 
     * @param seq    the sequence for enumeration
     */
    SequenceEnumerator(Sequence seq) {
        S = seq;
        if (S.isEmpty())
            curr = null;
        else
            curr = S.first();
    }

    /**
     * Tests if this enumeration contains more elements.
     *
     * @return  <code>true</code> if and only if this enumeration object
     *           contains at least one more element to provide;
     *          <code>false</code> otherwise.
     */
    public boolean hasMoreElements() {
        return curr!=null;
    }

    /**
     * Returns the next element of this enumeration if this enumeration
     * object has at least one more element to provide.
     *
     * @return     the next element of this enumeration.
     * @exception  NoSuchElementException  if no more elements exist.
     */
    public Object nextElement() {
        if (curr==null)
            throw new NoSuchElementException("No such element on nextElement()");
        Object temp = curr.element();
        if (curr!=S.last())
            curr = S.after(curr);
        else
            curr = null;
        return temp;
    }

    /**
     * Resets the SequenceEnumerator to point back at the first
     * element
     */
    public void reset() {
        if (S.isEmpty())
            curr = null;
        else
            curr = S.first();
    }
}
