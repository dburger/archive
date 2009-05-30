/*
 * Created on Aug 31, 2003
 *
 */
package edu.hawaii.pagecheck;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Contains convinience methods Used to fetch information about a URL that is
 * not directly available from a <code>URLConnection</code>.
 *
 * @author David J. Burger
 */
public class UrlInfo {

  /** The <code>URLConnection</code> object used to fetch information. */
  private URLConnection urlConnection = null;

  /**
   * Constructor which specifies the URL using a <code>String</code>.
   *
   * @param urlString the URL specification to fetch information on
   * @throws IOException
   */
  public UrlInfo(String urlString) throws IOException {
    URL url = new URL(urlString);
    this.urlConnection = url.openConnection();
  }

  /**
   * Constructor which specifies the URL using a <code>URL</code> object.
   *
   * @param url the <code>URL</code> to fetch information on
   * @throws IOException
   */
  public UrlInfo(URL url) throws IOException {
    this.urlConnection = url.openConnection();
  }

  /**
   * Returns the privately held <code>URLConnection</code>.
   *
   * @return the privately held <code>URLConnection</code>
   */
  public URLConnection getConnection() {
    return this.urlConnection;
  }

  /**
   * Returns the hash for the URL resource.
   *
   * @param algorithm for the hash algorithm such as "SHA"
   * @return algorithmic hash for the URL resource
   * @throws NoSuchAlgorithmException if the specified algorithm can't be found
   * @throws IOException if a problem occurs while fetching the <code>URLConnection</code>s data
   */
  public byte[] getHash(String algorithm) throws NoSuchAlgorithmException, IOException {
    MessageDigest digest = MessageDigest.getInstance(algorithm);
    BufferedReader reader =
      new BufferedReader(new InputStreamReader(this.urlConnection.getInputStream()));
    String input;
    while ((input = reader.readLine()) != null) {
      digest.update(input.getBytes());
    }
    return digest.digest();
  }

}
