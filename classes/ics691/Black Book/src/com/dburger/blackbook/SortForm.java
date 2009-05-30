package com.dburger.blackbook;

import javax.microedition.lcdui.ChoiceGroup;
import javax.microedition.lcdui.Command;
import javax.microedition.lcdui.Form;

import javax.microedition.rms.RecordComparator;

/**
 * <code>Form</code> used to select sort parameters as well as the implementor
 * of the <code>RecordComparator</code> interface.
 *
 * @author David J. Burger
 */
public class SortForm extends Form implements RecordComparator {

  /** The singleton instance. */
  private static SortForm instance = null;

  /** Title for the <code>Form</code>. */
  private static String TITLE = "Choose Sort Fields";

  /** <code>ChoiceGroup</code> for primary sort field. */
  private ChoiceGroup priField = null;

  /** <code>ChoiceGroup</code> for secondary sort field. */
  private ChoiceGroup secField = null;

  /** Used to retrieve the singleton instance. */
  public static SortForm getInstance() {
    if (SortForm.instance == null) {
      SortForm.instance = new SortForm(SortForm.TITLE);
    }
    return SortForm.instance;
  }

  /**
   * Private constructor prevents instantiation and sets up the form.
   *
   * @param title the title for the <code>Form</code>
   */
  private SortForm(String title) {
    super(title);
    append((this.priField = new ChoiceGroup("Primary Field", ChoiceGroup.POPUP,
        Contact.FIELDS, null)));
    this.priField.setSelectedIndex(1, true); // last name
    append((this.secField = new ChoiceGroup("Secondary Field",
        ChoiceGroup.POPUP, Contact.FIELDS, null)));
    this.secField.setSelectedIndex(0, true); // first name
    addCommand(new Command("Back", Command.BACK, 0));
  }

  /**
   * <code>String</code> to <code>RecordComparator</code>
   * <code>compareTo</code> converter.
   *
   * @param value the value from the <code>String.compareTo</code>
   * @return equivalent value for <code>RecordComparator.compareTo</code>
   */
  private int s2r(int value) {
    if (value == RecordComparator.EQUIVALENT) return value;
    return value < 0 ? RecordComparator.PRECEDES : RecordComparator.FOLLOWS;
  }

  /**
   * Compares <code>rec1</code> and <code>rec2</code> to determine sort order.
   *
   * @param rec1 first record for comparison
   * @param rec2 second record for comparison
   * @return PRECEDES, FOLLOWS, or EQUIVALENT
   */
  public int compare(byte[] rec1, byte[] rec2) {
    Contact contact1 = new Contact(rec1);
    Contact contact2 = new Contact(rec2);
    String priField = getPriField();
    String secField = getSecField();
    // java.lang.String.compareTo does not use the same values!!!
    int result = s2r(contact1.get(priField).compareTo(contact2.get(priField)));
    if (result != RecordComparator.EQUIVALENT) return result;
    return s2r(contact1.get(secField).compareTo(contact2.get(secField)));
  }

  /** Used to fetch the selected primary sort field. */
  public String getPriField() {
    return this.priField.getString(this.priField.getSelectedIndex());
  }

  /** Used to fetch the selected secondary sort field. */
  public String getSecField() {
    return this.secField.getString(this.secField.getSelectedIndex());
  }

}
