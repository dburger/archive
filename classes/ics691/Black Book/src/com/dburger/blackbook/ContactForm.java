package com.dburger.blackbook;

import java.util.Enumeration;
import java.util.Hashtable;

import javax.microedition.lcdui.Command;
import javax.microedition.lcdui.Displayable;
import javax.microedition.lcdui.Form;
import javax.microedition.lcdui.TextField;

/**
 * <code>Form</code> used to show the detail of an individual contact and to
 * allow editing of that contact.
 *
 * @author David J. Burger
 */
public class ContactForm extends Form {

  /** The singleton instance. */
  private static ContactForm instance = null;

  /** Title for the <code>Form</code>. */
  private static String TITLE = "Contact Form";

  /** <code>Hashtable</code> of <code>TextField</code>s to display fields. */
  private Hashtable textFields = new Hashtable();

  /** Id of record in database, -1 if not in database. */
  private int recordId;

  /** Used to retrieve the singleton instance. */
  public static ContactForm getInstance() {
    if (ContactForm.instance == null) {
      ContactForm.instance = new ContactForm(ContactForm.TITLE);
    }
    return ContactForm.instance;
  }

  /**
   * Private constructor prevents instantiation and sets up the form.
   *
   * @param title the title for the <code>Form</code>
   */
  private ContactForm(String title) {
    super(title);

    for (int i = 0; i < Contact.FIELDS.length; i++) {
      TextField textField = new TextField(Contact.FIELDS[i] + ":", "", 30,
          TextField.ANY);
      append(textField);
      this.textFields.put(Contact.FIELDS[i], textField);
    }

    addCommand(new Command("Back", Command.BACK, 0));
    addCommand(new Command("Save", Command.SCREEN, 0));
  }

  /**
   * Returns the field indicated by <code>field</code>.
   *
   * @param field field to retrieve
   * @return the value the <code>TextField</code> indicated by
   *     <code>field</code>
   */
  public String get(String field) {
    TextField textField = (TextField)this.textFields.get(field);
    return textField.getString();
  }

  /**
   * Used to retrieve the id associated with the displayed record, -1 if not
   * saved in the record store.
   *
   * @return recordId associated with the displayed record
   */
  public int getRecordId() {
    return this.recordId;
  }

  /**
   * Used to retreive a <code>byte[]</code> suitable for storing the record
   * displayed in the <code>Form</code> in a <code>RecordStore</code>.
   *
   * @return <code>byte[]</code> of displayed record for storing in
   *     <code>RecordStore</code>
   */
  public byte[] getBytes() {
    String[] fields = new String[Contact.FIELDS.length];
    for (int i = 0; i < Contact.FIELDS.length; i++) {
      fields[i] = get(Contact.FIELDS[i]);
    }
    return new Contact(fields).getBytes();
  }

  /**
   * Used to set the id for the displayed record, -1 indicating never saved in
   * the record store.
   *
   * @param recordId record store identifier for the displayed record
   */
  public void setRecordId(int recordId) {
    this.recordId = recordId;
  }

  /**
   * Used to display the give record in this <code>Form</code>.  For an empty
   * form, pass in -1 for the <code>recordid</code>.
   *
   * @param recordId identifier of the record to display
   * @param rec <code>byte[]</code> containing the contact record
   */
  public void displayRecord(int recordId, byte[] rec) {
    this.recordId = recordId;
    if (recordId == -1) {
      rec = new byte[] { (byte)0, (byte)0, (byte)0, (byte)0, (byte)0,
          (byte)0, };
    }
    Contact contact = new Contact(rec);
    for (int i = 0; i < Contact.FIELDS.length; i++) {
      TextField textField = (TextField)this.textFields.get(Contact.FIELDS[i]);
      textField.setString(contact.get(Contact.FIELDS[i]));
    }
  }

}
