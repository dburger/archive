import java.io.OutputStream;
import java.lang.StringBuffer;

/**
 * An <code>OutputStream</code> that writes to a <code>StringBuffer</code>.
 *
 * @author David J. Burger
 */
public class StringBufferOutputStream extends OutputStream {

  /** Reference to <code>StringBuffer</code> that will be written to. */
  private StringBuffer buffer = null;

  /**
   * Constructs a <code>StringBufferOutputStream</code> that writes to the
   * given <code>StringBuffer</code>.
   *
   * @param buffer the <code>StringBuffer</code> to write to
   */
  public StringBufferOutputStream(StringBuffer buffer) {
    this.buffer = buffer;
  }

  /**
   * Closes the stream making it unusable.
   */
  public void close() {
    this.buffer = null;
  }

  /**
   * Writes the <code>char</code>, represented by an <code>int</code>, to the
   * <code>StringBuffer</code>.
   *
   * @param b character to be written to the <code>StringBuffer</code>
   */
  public void write(int b) {
    // :TODO: portability with other character sets?
    this.buffer.append(Character.toString((char)b));
  }

}
