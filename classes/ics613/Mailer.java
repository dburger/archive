/*
 * Created on Aug 31, 2003
 *
 */
package edu.hawaii.util;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.Message.RecipientType;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * Provides a simpler interface to the JavaMail API that can be sed to send
 * simple email messages.
 *
 * @author David J. Burger
 */
public class Mailer {

  /** The message to be sent. */
  private String message = null;

  /** The subject of the email. */
  private String subject = null;

  /** Properties for email session. */
  private Properties properties = new Properties();

  /** From address for email. */
  private String from = null;

  /** List of to recipients. */
  private ArrayList toList = new ArrayList();

  /** List of cc recipients. */
  private ArrayList ccList = new ArrayList();

  /** List of bcc recipients. */
  private ArrayList bccList = new ArrayList();

  /**
   * Basic constructor that sets the mail host.
   *
   * @param mailHost mail host to use for sending
   */
  public Mailer(String mailHost) {
    this.properties.put(mailHost, "mailhost");
  }

  /**
   * Sets the from address.
   *
   * @param from from address for message
   */
  public void setFrom(String from) {
    this.from = from;
  }

  /**
   * Sets the subject.
   *
   * @param subject subject of the message
   */
  public void setSubject(String subject) {
    this.subject = subject;
  }

  /**
   * Sets the message.
   *
   * @param message message of the email
   */
  public void setMessage(String message) {
    this.message = message;
  }

  /**
   * Returns the <code>ArrayList</code> that holds the recipients list
   * matching the passed in RecipientType.
   *
   * @param type <code>RecipientType</code> list to fetch
   * @return the list corresponding to type
   */
  private ArrayList fetchList(RecipientType type) {
    ArrayList list = null;
    if (type == RecipientType.TO) {
      list = this.toList;
    }
    else if (type == RecipientType.CC) {
      list = this.ccList;
    } else {
      list = this.bccList;
    }
    return list;
  }

  /**
   * Sets the recipient for the email of the specified type clearing out
   * others of that type.
   *
   * @param type <code>RecipientType</code> to set
   * @param recipient email address to set as recipient of type
   * @throws AddressException if the email address is of an invalid form
   */
  public void setRecipient(RecipientType type, String recipient) throws AddressException {
    clearRecipients(type);
    addRecipient(type, recipient);
  }

  /**
   * Sets the recipients for the email of the specified type clearing out others of that type.
   *
   * @param type <code>RecipientType</code> to set
   * @param recipients list of recipients to set as recipients of type
   * @throws AddressException if any of the email addresses is of an invalid form
   */
  public void setRecipients(RecipientType type, ArrayList recipients) throws AddressException {
    clearRecipients(type);
    addRecipients(type, recipients);
  }

  /**
   * Adds the recipient for the email of the specified type.
   *
   * @param type <code>RecipientType</code> to add to
   * @param recipient email address to add to recipients of type
   * @throws AddressException if the email address is of an invalid form
   */
  public void addRecipient(RecipientType type, String recipient) throws AddressException {
    ArrayList list = fetchList(type);
    list.add(new InternetAddress(recipient));
  }

  /**
   * Adds the recipients for the email of the specified type.
   *
   * @param type <code>RecipientType</code> to add to
   * @param recipients list of recipients to add as recipients of type
   * @throws AddressException if any of the email addresses is of an invalid form
   */
  public void addRecipients(RecipientType type, ArrayList recipients) throws AddressException {
    ArrayList list = fetchList(type);
    for (Iterator i = recipients.iterator(); i.hasNext();) {
      String recipient = (String)i.next();
      list.add(new InternetAddress(recipient));
    }
  }

  /**
   * Clears the recipients of the specified type.
   *
   * @param type <code>RecipientType</code> to clear.
   */
  public void clearRecipients(RecipientType type) {
    ArrayList list = fetchList(type);
    list.clear();
  }

  /**
   * Sends the email message.
   *
   * @throws MessagingException if an error occurs while sending the message
   */
  public void send() throws MessagingException {
    Session session = Session.getDefaultInstance(this.properties, null);
    Message message = new MimeMessage(session);
    message.setFrom(new InternetAddress(this.from));
    Address[] recipients = null;
    if (this.toList.size() > 0) {
      recipients = new Address[this.toList.size()];
      this.toList.toArray(recipients);
      message.addRecipients(RecipientType.TO, recipients);
    }
    if (this.ccList.size() > 0) {
      if (recipients == null || (this.ccList.size() > recipients.length)) {
        recipients = new Address[this.ccList.size()];
      }
      this.ccList.toArray(recipients);
      message.addRecipients(RecipientType.CC, recipients);
    }
    if (this.bccList.size() > 0) {
      if (recipients == null || (this.bccList.size() > recipients.length)) {
        recipients = new Address[this.bccList.size()];
      }
      this.bccList.toArray(recipients);
      message.addRecipients(RecipientType.BCC, recipients);
    }
    message.setSubject(this.subject);
    message.setText(this.message);
    Transport.send(message);
  }

}
