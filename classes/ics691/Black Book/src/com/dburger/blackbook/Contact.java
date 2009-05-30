package com.dburger.blackbook;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.NoSuchElementException;

/**
 * Class used to convert records to and from <code>byte[]</code> and contact
 * information fields.
 *
 * @author David J. Burger
 */
public class Contact {

  /** Fields in a <code>Contact</code>. */
  public static final String[] FIELDS = new String[] { "First", "Last",
      "Addr", "City", "State", "Zip", "Ph #", "Email" };

  /** Holds the fields of the <code>Contact</code>. */
  private Hashtable fields = null;

  /**
   * Simple constructor which merely sets the corresponding field value from
   * the passed in values.
   *
   * @param fields the field values for this <code>Contact</code>
   */
  public Contact(String fields[]) {
    this.fields = new Hashtable();
    for (int i = 0; i < fields.length; i++) {
      this.fields.put(Contact.FIELDS[i], fields[i]);
    }
  }

  /**
   * Constructs a <code>Contact</code> by pulling the fields out of
   * <code>rec</code>.
   *
   * @param rec <code>byte[]</code> holding the contact fields
   */
  public Contact(byte[] rec) {
    this.fields = new Hashtable();
    Enumeration enumeration = new DataEnumeration(rec);
    for (int i = 0; i < Contact.FIELDS.length; i++) {
      try {
        this.fields.put(Contact.FIELDS[i], (String)enumeration.nextElement());
      } catch (NoSuchElementException e) {
        // possibly the program has been recompiled with more fields, this
        // will give the null fields an empty string value
        for (; i < Contact.FIELDS.length; i++) {
          this.fields.put(Contact.FIELDS[i], "");
        }
      }
    }
  }

  /**
   * Returns the field indicated by <code>field</code>.
   *
   * @param field field to retrieve
   * @return the value of the field indicated by <code>field</code>
   */
  public String get(String field) {
    return (String)this.fields.get(field);
  }

  /**
   * Used to retrieve a <code>byte[]</code> version of the record suitable for
   * storage in a <code>RecordStore</code>.
   *
   * @return <code>byte[]</code> version of record suitable for storage in a
   *     <code>RecordStore</code>
   */
  public byte[] getBytes() {
    StringBuffer buf = new StringBuffer();
    for (int i = 0; i < Contact.FIELDS.length; i++) {
      buf.append(get(Contact.FIELDS[i]));
      if (i < Contact.FIELDS.length - 1) buf.append((char)0);
    }
    return buf.toString().getBytes();
  }

}

/** Simple class used to parse records out of null separated byte arrays. */
class DataEnumeration implements Enumeration {

  /** The <code>byte[]</code> to parse a record out of. */
  byte[] rec = null;

  /** Index to current position in <code>rec</code>. */
  private int i = 0;

  /**
   * Sets the reference to the passed in <code>byte[]</code>.
   *
   * @param rec the <code>byte[]</code> which will be parsed for data
   */
  public DataEnumeration(byte[] rec) {
    this.rec = rec;
  }

  /**
   * Returns true if this <code>Enumeration</code> has more elements, false
   * otherwise.
   *
   * @return true if this <code>Enumeration</code> has more elements, false
   *     otherwise
   */
  public boolean hasMoreElements() {
    return this.i < this.rec.length;
  }

  /**
   * Returns the next element from this <code>Enumeration</code>.
   *
   * @return the next element from this <code>Enumeration</code>
   * @throws NoSuchElementException if there is no next element
   */
  public Object nextElement() {
    if (this.i > this.rec.length) {
      throw new NoSuchElementException("No next element.");
    }
    StringBuffer buf = new StringBuffer();
    while (this.i < this.rec.length) {
      byte b = this.rec[this.i++];
      if (b == 0) break;
      buf.append((char)b);
    }
    return buf.toString();
  }

}
