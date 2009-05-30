package com.dburger.blackbook;

import javax.microedition.lcdui.Alert;
import javax.microedition.lcdui.AlertType;
import javax.microedition.lcdui.Command;
import javax.microedition.lcdui.CommandListener;
import javax.microedition.lcdui.Display;
import javax.microedition.lcdui.Displayable;
import javax.microedition.lcdui.List;
import javax.microedition.midlet.MIDlet;

import javax.microedition.rms.RecordStore;
import javax.microedition.rms.RecordStoreException;

/**
 * Simple J2ME address book application.
 *
 * @author David J. Burger
 */
public class BlackBook extends MIDlet {

  /** Name used to identify the <code>RecordStore</code>. */
  private static final String RECORD_STORE_NAME = "BlackBook";

  /** Reference to <code>RecordStore</code> used to persist contact records. */
  private RecordStore recordStore = null;

  /**
   * Holds a reference to an <code>Exception</code> if one occurs while
   * opening the <code>RecordStore</code> during the constructor.
   */
  private Exception recordStoreException = null;

  /** The <code>Display</code> for this midlet. */
  private Display display = null;

  /** Flag used to determine the first <code>startApp</code> call. */
  private boolean firstStartApp = true;

  /** Basic constructor sets up the application. */
  public BlackBook() {
    this.display = Display.getDisplay(this);
    try {
      this.recordStore = RecordStore.openRecordStore(
          BlackBook.RECORD_STORE_NAME, true);
      ContactList contactList = ContactList.getInstance();
      contactList.setList(this.recordStore.enumerateRecords(
          FilterForm.getInstance(), SortForm.getInstance(), false),
          this.recordStore);
      contactList.getInstance().setCommandListener(
          new ContactListCommandListener());
      ContactForm.getInstance().setCommandListener(
          new ContactFormCommandListener());
      SortForm.getInstance().setCommandListener(
          new SortFormCommandListener());
      FilterForm.getInstance().setCommandListener(
          new FilterFormCommandListener());
    } catch (Exception e) {
      // RecordStoreFullException, RecordStoreNotFoundException,
      // RecordStoreException
      this.recordStoreException = e;
    }
  }

  /** Causes the <code>ContactList</code> to load the list. */
  private void loadContactList() {
    try {
      ContactList contactList = ContactList.getInstance();
      contactList.setList(this.recordStore.enumerateRecords(
          FilterForm.getInstance(), SortForm.getInstance(), false),
          this.recordStore);
    } catch (RecordStoreException e) {
      this.display.setCurrent(new Alert("Exception", e.getMessage(), null,
          AlertType.ERROR));
      notifyDestroyed();
    }
  }

  /** Signals the midlet that it has entered the active state. */
  public void startApp() {
    if (this.firstStartApp) {
      if (this.recordStoreException != null) {
        this.display.setCurrent(new Alert("Exception",
            this.recordStoreException.getMessage(), null, AlertType.ERROR));
        notifyDestroyed();
      } else {
        this.display.setCurrent(ContactList.getInstance());
        this.firstStartApp = false;
      }
    }
  }

  /** Signals the midlet to enter the paused state. */
  public void pauseApp() {}

  /** Signals the midlet to terminate and enter the destroyed state. */
  public void destroyApp(boolean unconditional) {}

  /** <code>CommandListener</code> for the <code>ContactList</code>. */
  class ContactListCommandListener implements CommandListener {

    /**
     * Called in response to a <code>Command</code> being executed.
     *
     * @param command executed <code>Command</code>
     * @param displayable <code>Displayable</code> the <code>Command</code>
     *     took place on
     */
    public void commandAction(Command command, Displayable displayable) {
      String commandString = command.getLabel();
      ContactList contactList = ContactList.getInstance();
      if (commandString.equals("Exit")) {
        notifyDestroyed();
      } else if (commandString.equals("Add")) {
        ContactForm recordForm = ContactForm.getInstance();
        recordForm.displayRecord(-1, null);
        display.setCurrent(recordForm);
      } else if (commandString.equals("Edit")) {
        int recordId = contactList.getSelRecordId();
        if (recordId == -1) return;
        try {
          byte[] rec = recordStore.getRecord(recordId);
          ContactForm recordForm = ContactForm.getInstance();
          recordForm.displayRecord(recordId, rec);
          display.setCurrent(recordForm);
        } catch (RecordStoreException e) {
          display.setCurrent(new Alert("Exception",
              "Unabled to display contact " + recordId + ":\n" + e.getMessage()
              + "\nThe contact will be deleted.", null, AlertType.ERROR));
          deleteSelContact();
        }
      } else if (commandString.equals("Delete")) {
        if (contactList.getSelRecordId() == -1) return;
        deleteSelContact();
      } else if (commandString.equals("Filter")) {
        display.setCurrent(FilterForm.getInstance());
      } else if (commandString.equals("Refresh")) {
        loadContactList();
      } else if (commandString.equals("Sort")) {
        display.setCurrent(SortForm.getInstance());
      }
    }

  }

  /** <code>CommandListener</code> for the <code>ContactForm</code>. */
  class ContactFormCommandListener implements CommandListener {

    /**
     * Called in response to a <code>Command</code> being executed.
     *
     * @param command executed <code>Command</code>
     * @param displayable <code>Displayable</code> the <code>Command</code>
     *     took place on
     */
    public void commandAction(Command command, Displayable displayable) {
      String commandString = command.getLabel();
      if (commandString.equals("Save")) {
        ContactForm contactForm = ContactForm.getInstance();
        int recordId = contactForm.getRecordId();
        byte[] rec = contactForm.getBytes();
        try {
          if (recordId == -1) {
            recordId = recordStore.addRecord(rec, 0, rec.length);
            ContactList.getInstance().addContact(recordId, recordStore);
          } else {
            recordStore.setRecord(recordId, rec, 0, rec.length);
            ContactList.getInstance().refreshSelContact(recordId,
                recordStore);
          }
        } catch (RecordStoreException e) {
          display.setCurrent(new Alert("Exception",
              "Unabled to save contact " + recordId + ":\n" + e.getMessage(),
              null, AlertType.ERROR));
        }
      }
      display.setCurrent(ContactList.getInstance());
    }

  }

  /** <code>CommandListener</code> for the <code>SortForm</code>. */
  class SortFormCommandListener implements CommandListener {

    /**
     * Called in response to a <code>Command</code> being executed.
     *
     * @param command executed <code>Command</code>
     * @param displayable <code>Displayable</code> the <code>Command</code>
     *     took place on
     */
    public void commandAction(Command command, Displayable displayable) {
      loadContactList();
      display.setCurrent(ContactList.getInstance());
    }

  }

  /** <code>CommandListener</code> for the <code>FilterForm</code>. */
  class FilterFormCommandListener implements CommandListener {

    /**
     * Called in response to a <code>Command</code> being executed.
     *
     * @param command executed <code>Command</code>
     * @param displayable <code>Displayable</code> the <code>Command</code>
     *     took place on
     */
    public void commandAction(Command command, Displayable displayable) {
      loadContactList();
      display.setCurrent(ContactList.getInstance());
    }

  }

  /** Used to delete the selected contact. */
  private void deleteSelContact() {
    ContactList contactList = ContactList.getInstance();
    int recordId = contactList.getSelRecordId();
    try {
      this.recordStore.deleteRecord(recordId);
      contactList.delete(contactList.getSelectedIndex());
    } catch (RecordStoreException e) {
      this.display.setCurrent(new Alert("Exception",
          "Unabled to delete contact " + recordId + ":\n" + e.getMessage(),
          null, AlertType.ERROR));
    }
  }

}
