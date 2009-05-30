/*
 * Created on Aug 31, 2003
 *
 */
package edu.hawaii.pagecheck;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import edu.hawaii.util.Mailer;

/**
 * Checks web pages for changes by comparing algorithmic hashes to previous
 * hash values sending email notices regarding any changes.  For usage please
 * see getUsage().
 *
 * @author David J. Burger
 */
public class PageCheck {

  /** Stores the hash values of the checked URLs */
  private HashMap hashValues;

  /** Subject for the notification message. */
  private String subject;

  /** From address for the notification message. */
  private String from;

  /** Name of file to store the hash values to. */
  private String dataFile;

  /** Name of smtp server to use. */
  private String server;

  /** List of URLs to check. */
  private ArrayList urls = new ArrayList();

  /** List of recipients to receive notification messages. */
  private ArrayList recipients = new ArrayList();

  /**
   * Constructer that reads the job information from the file indicated by filename.
   *
   * @param filename name of file that holds the job information
   * @throws IOException if the indicated filename cannot be read
   */
  public PageCheck(String filename) throws IOException {
    String input = null;
    BufferedReader in = new BufferedReader(new FileReader(filename));
    while ((input = in.readLine()) != null) {
      int equalPosition = input.indexOf('=');
      if (equalPosition == -1) {
        continue;
      }
      String key = input.substring(0, equalPosition);
      String value = input.substring(equalPosition + 1);

      if (key.equals("recipient")) {
        this.recipients.add(value);
      }
      else if (key.equals("url")) {
        this.urls.add(value);
      }
      else if (key.equals("server")) {
        this.server = value;
      }
      else if (key.equals("data")) {
        this.dataFile = value;
      }
      else if (key.equals("from")) {
        this.from = value;
      }
      else if (key.equals("subject")) {
        this.subject = value;
      }
    }
  }

  /**
   * Returns the usage of this program to including a description of the file format
   * used for the input file.
   *
   * @return <code>String</code> explaining program usage
   */
  private static String getUsage() {
    return "Proper usage is: java PageCheck file1 file2 ..."
      + "where the files are input files in the following format:\n\n"
      + "server=mail.hawaii.edu\n"
      + "from=root@pagecheck.com"
      + "subject=Page Check Notification"
      + "recipient=dburger@hawaii.edu\n"
      + "recipient=bob@bob.com\n"
      + "data=file.dat\n"
      + "url=http://www2.hawaii.edu/~dburger\n"
      + "url=http://csdl.ics.hawaii.edu/~johnson/413f03/a4-pagecheck.htm\n"
      + "url=http://www.yahoo.com\n";
  }

  /**
   * Reads in the previous hash values from the data file indicated in the input file.
   *
   * @throws IOException if the data file can't be read
   * @throws ClassNotFoundException if the data file does not hold a <code>HashMap</code> object.
   */
  private void readOldHashes() throws IOException, ClassNotFoundException {
    if (this.dataFile == null) {
      throw new IOException("No data file was specified in the input file.");
    }
    try {
      ObjectInputStream is = new ObjectInputStream(new FileInputStream(this.dataFile));
      this.hashValues = (HashMap)is.readObject();
    }
    catch (FileNotFoundException e) {
      // must be a first run?
      this.hashValues = new HashMap();
    }
  }

  /**
   * Compares the previous hash values of the URLs to the new hash values, returning a
   * message that indicates the results.
   *
   * @return <code>String</code> that indicates the results of the hash comparisons
   */
  private String compareHashes() {
    String message = "";
    for (Iterator i = this.urls.iterator(); i.hasNext();) {
      String url = (String)i.next();
      try {
        UrlInfo urlInfo = new UrlInfo(url);
        byte[] oldHash = (byte[])this.hashValues.get(url);
        byte[] newHash = urlInfo.getHash("SHA");
        // if oldHash == null this is first check of URL, don't send message just store newHash
        if (oldHash != null && !Arrays.equals(oldHash, newHash)) {
          message = message + "changed: " + url + "\n";
        }
        this.hashValues.put(url, newHash);
      }
      catch (Exception e) {
        // IOException from connection of NoSuchAlgorithmException using SHA
        message = message + "failed: " + url + " " + e.getMessage() + "\n";
      }
    }

    // new has values are stored for the next run of the program
    try {
      ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream(dataFile));
      os.writeObject(this.hashValues);
      os.close();
    }
    catch (IOException e) {
      message = message + "failed: storing new hash values to " + this.dataFile + "\n";
    }

    return message;
  }

  /**
   * Sends the message to the recipients indicated from the input file.
   *
   * @param message the message to send as the body of the email
   * @throws MessagingException if the email could not be sent
   */
  private void sendEmail(String message) throws MessagingException {
    Mailer mailer = new Mailer(server);
    mailer.setFrom(from);
    mailer.setRecipients(RecipientType.TO, recipients);
    mailer.setSubject(subject);
    mailer.setMessage(message);
    mailer.send();
  }

  /**
   * Reads in the old hash values, comparing them to the new hash values, and
   * returns a string indicating the result.
   *
   * @return <code>String</code> indicating result of hash comparisons
   * @throws IOException if a problem occurs when reading or saving the data file
   * @throws ClassNotFoundException if the data file does not contain a <code>HashMap</code>
   */
  public String check() throws IOException, ClassNotFoundException {
    readOldHashes();
    return compareHashes();
  }

  /**
   * Main entry point to program.
   *
   * @param args command line parameters for passing input file
   */
  public static void main(String[] args) {

    if (args.length == 0) {
      System.err.println(getUsage());
      System.exit(1);
    }

    for (int i = 0; i < args.length; i++) {
      try {
        PageCheck p = new PageCheck(args[i]);
        String message = p.check();
        if (message.length() > 0) {
          System.out.println(message);
          p.sendEmail(message);
        }
      }
      catch (ClassNotFoundException e) {
        System.err.println("A ClassNotFoundException occurred when processing" + args[i] + ".\n"
                           + "apparently the indicated data file is invalid:\n" + e.getMessage());
      }
      catch (IOException e) {
        System.err.println("An IOException occurred when processing " + args[i] + ":\n"
                           + e.getMessage());
      }
      catch (MessagingException e) {
        System.err.println("A MessagingException occurred when processing " + args[i] + ":\n"
                           + e.getMessage());
      }
    }
  }

}
