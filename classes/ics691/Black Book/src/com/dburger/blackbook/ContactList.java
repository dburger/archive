package com.dburger.blackbook;

import javax.microedition.lcdui.Command;
import javax.microedition.lcdui.List;
import javax.microedition.rms.RecordEnumeration;
import javax.microedition.rms.RecordStore;
import javax.microedition.rms.RecordStoreException;

/**
 * <code>List</code> used to show a list of contacts along as well as
 * providing the menus to interact with the records.
 *
 * @author David J. Burger
 */
public class ContactList extends List {

  /** The singleton instance. */
  private static ContactList instance = null;

  /** Title used for the list. */
  private static String TITLE = "Contact List";

  public static ContactList getInstance() {
    if (ContactList.instance == null) {
      ContactList.instance = new ContactList(ContactList.TITLE, List.IMPLICIT);
    }
    return ContactList.instance;
  }

  /**
   * Sets up the <code>Command</code>s available on the
   * <code>ContactList</code>.
   *
   * @param title the title to use for the list
   * @param listType the type of list
   */
  private ContactList(String title, int listType) {
    super(title, listType);
    setSelectCommand(new Command("Edit", Command.ITEM, 0));
    addCommand(new Command("Exit", Command.EXIT, 0));
    addCommand(new Command("Add", Command.SCREEN, 0));
    addCommand(new Command("Delete", Command.ITEM, 0));
    addCommand(new Command("Filter", Command.SCREEN, 0));
    addCommand(new Command("Refresh", Command.SCREEN, 0));
    addCommand(new Command("Sort", Command.SCREEN, 0));
  }

  /**
   * Used to set the list of contacts currently contained in the list
   * according to the given <code>RecordEnumeration</code>.
   *
   * @param enumeration <code>RecordEnumeration</code> containing the list to
   *     display
   * @param store <code>RecordStore</code> from which the
   *     <code>RecordEnumeration</code> is based
   * @throws RecordStoreException if there is a problem setting the list
   */
  public void setList(RecordEnumeration enumeration, RecordStore store)
      throws RecordStoreException {
    deleteAll();
    while (enumeration.hasNextElement()) {
      int recordId = enumeration.nextRecordId();
      addContact(recordId, store);
    }
  }

  /**
   * Used to add a single contact to the end of this <code>ContactList</code>.
   *
   * @param recordId record identifier of contact to add
   * @param store <code>RecordStore</code> containing the contact
   * @throws RecordStoreException if there is a problem finding the contact
   *     with identifier <code>recordId</code>
   */
  public void addContact(int recordId, RecordStore store)
      throws RecordStoreException {
    append(getContactString(recordId, store), null);
  }

  /**
   * Used to refresh the selected contact.  This is called, for example, when
   * the user has edited a contact and the fields that are display in the
   * <code>ContactList</code> have changed.
   *
   * @param recordId record identifier of contact to refresh
   * @param store <code>RecordStore</code> containing the contact
   * @throws RecordStoreException if there is a problem finding the selected
   *     contact in the <code>RecordStore</code>
   */
  public void refreshSelContact(int recordId, RecordStore store)
      throws RecordStoreException {
    set(getSelectedIndex(), getContactString(recordId, store), null);
  }

  /**
   * Used to fetch the <code>String</code> to appear in the
   * <code>ContactList</code> for a given contact.
   *
   * @param recordId record identifier of contact to fetch for
   * @param store <code>RecordStore</code> holding the contact
   * @return the <code>String</code> to appear in the <code>ContactList</code>
   *     for the contact indicated by recordId
   * @throws RecordStoreException if there is a problem fetching the record
   *     identified by <code>recordId</code>
   */
  private String getContactString(int recordId, RecordStore store)
      throws RecordStoreException {
    Contact contact = new Contact(store.getRecord(recordId));
    String priField = SortForm.getInstance().getPriField();
    String secField = SortForm.getInstance().getSecField();
    return contact.get(Contact.FIELDS[1]) + ", "
        + contact.get(Contact.FIELDS[0]) + "\n    ["
        + contact.get(priField) + " : " + contact.get(secField)
        + "] (" + recordId + ")";
  }

  /**
   * Used to extract the record identifier from the selected contact in the
   * list.
   *
   * @return <code>int</code> record identifier found from selected contact
   */
  public int getSelRecordId() {
    int selected = getSelectedIndex();
    if (selected == -1) return -1;
    String contact = getString(selected);
    int lParen = contact.lastIndexOf('(');
    int rParen = contact.length() - 1;
    return Integer.parseInt(contact.substring(lParen + 1, rParen));
  }

}
