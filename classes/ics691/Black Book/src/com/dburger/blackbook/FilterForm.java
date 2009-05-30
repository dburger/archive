package com.dburger.blackbook;

import javax.microedition.lcdui.ChoiceGroup;
import javax.microedition.lcdui.Command;
import javax.microedition.lcdui.Form;
import javax.microedition.lcdui.TextField;

import javax.microedition.rms.RecordFilter;

/**
 * <code>Form</code> used to select filter parameters as well as the
 * implementor of the <code>RecordFilter</code> interface.
 *
 * @author David J. Burger
 */
public class FilterForm extends Form implements RecordFilter {

  /** The singleton instance. */
  private static FilterForm instance = null;

  /** Title for the <code>Form</code>. */
  private static String TITLE = "Choose Filter";

  /** Holds the field to filter on. */
  private ChoiceGroup field = null;

  /** Holds how to filter, starts with or contains. */
  private ChoiceGroup type = null;

  /** Holds the filter text. */
  private TextField text = null;

  /** Used to retrieve the singleton instance. */
  public static FilterForm getInstance() {
    if (FilterForm.instance == null) {
      FilterForm.instance = new FilterForm(FilterForm.TITLE);
    }
    return FilterForm.instance;
  }

  /**
   * Private constructor prevents instantiation and sets up the form.
   *
   * @param title the title for the <code>Form</code>
   */
  private FilterForm(String title) {
    super(title);
    String[] fields = new String[Contact.FIELDS.length + 1];
    fields[0] = "None";
    for (int i = 0; i < Contact.FIELDS.length; i++) {
      fields[i + 1] = Contact.FIELDS[i];
    }
    append((this.field = new ChoiceGroup("Field", ChoiceGroup.POPUP,
        fields, null)));
    append((this.type = new ChoiceGroup("Type", ChoiceGroup.POPUP,
        new String[] { "Starts With", "Contains" }, null)));
    append((this.text = new TextField("Text", "", 15, TextField.ANY)));
    addCommand(new Command("Back", Command.BACK, 0));
  }

  /**
   * <code>RecordFilter</code> implementation determines matching records.
   *
   * @param rec record to determine if matches
   */
  public boolean matches(byte[] rec) {
    if (this.field.getSelectedIndex() == 0) return true;
    Contact contact = new Contact(rec);
    String filterField = this.field.getString(this.field.getSelectedIndex());
    String value = contact.get(filterField);
    String text = this.text.getString();
    return this.type.getSelectedIndex() == 0 ?
        value.startsWith(text) : value.indexOf(text) > - 1;
  }

}
