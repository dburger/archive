/**
 * Bookstore Administration Project
 * by David J. Burger
 * 06/24/2002 for ICS 415 Dr. Martin
 */
import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 * This servlet functions as a simple administration page for a book store.  It allows for
 * the insertion and deletion of books from the bookstore database.
 */
public class dburger extends HttpServlet {

  private Connection conn; // maintaining a single connection for less overhead

  /**
   * In the init() method the database connection is prepared for use.
   */
  public void init() throws ServletException {
    // try to obtain the JDBC driver and make a connection to the database
    try {
      DriverManager.registerDriver(new org.gjt.mm.mysql.Driver());
      conn = DriverManager.getConnection("jdbc:mysql:///bookstore");
    }
    catch(SQLException e) {
      throw new ServletException("Unable to create database connection.  Please contact" +
                                 " the website administrator", e);
    }
  }

  /**
   * In destroy the database connection is closed.
   */
  public void destroy(){
    try {
      conn.close();
    } catch(SQLException e) {

    }
  }

  /**
   * Post requests are redirected to the renderPage() method.
   * 
   * @param req    request Object
   * @param res    response Object
   * @exception ServletException
   * @exception IOException
   */
  protected void doPost(HttpServletRequest req, HttpServletResponse res)
                        throws ServletException, IOException {
    renderPage(req, res);
  }
          
  /**
   * Get requests are redirected to the renderPage() method.
   * 
   * @param req    request Object
   * @param res    response Object
   * @exception ServletException
   * @exception IOException
   */
  protected void doGet(HttpServletRequest req, HttpServletResponse res)
                       throws ServletException, IOException {
    renderPage(req, res);
  }

  /**
   * The renderPage() method is the workhorse of this Servlet.  GET and POST requests are
   * redirected to this method.  The submit request parameters deleteBook and addBook
   * corresponding to submit buttons are analyzed to see if the processing is for an insertion,
   * deletion, or initial visit to the page.  A status message is displayed at the top of the
   * page corresponding to the previous action.
   * 
   * @param req    request Object
   * @param res    response Object
   * @exception IOException
   */
  private void renderPage(HttpServletRequest req, HttpServletResponse res) throws IOException {
    // set the content type and then get the PrintWriter
    res.setContentType("text/html");
    PrintWriter out = res.getWriter();
    // now write out the top of the HTML page
    out.println("<html><head><title>dburger's ICS 415 project #4</title>");
    // and now the Javascript section of the page
    out.println("<script language='javascript'>");
    out.println("<!--");
    out.println("function validateDelete() {");
    out.println("  var theForm = document.getElementById('booklist');");
    out.println("  if (theForm.books.value=='') {");
    out.println("    alert('Please select a book to delete.')");
    out.println("    return false;");
    out.println("  } else");
    out.println("    return confirm('Are you sure you wish to delete the selected book?')");
    out.println("}");
    out.println("function validateAdd() {");
    out.println("  var theForm = document.getElementById('bookentry');");
    out.println("  if (theForm.isbn.value!='' && " +
                      "theForm.title.value!='' && " +
                      "theForm.price.value!='' && " +
                      "theForm.author.value!='') {");
    out.println("    // all fields filled in, make sure that price is a number");
    out.println("    if (isNaN(theForm.price.value)) {");
    out.println("      alert('The price must be a valid numeric value.');");
    out.println("      theForm.price.focus();");
    out.println("      return false;");
    out.println("    }");
    out.println("    return true;");
    out.println("  } else {");
    out.println("    alert('Please fill in the required fields.');");
    out.println("    if (theForm.price.value=='') theForm.price.focus();");
    out.println("    if (theForm.author.value=='') theForm.author.focus();");
    out.println("    if (theForm.title.value=='') theForm.title.focus();");
    out.println("    if (theForm.isbn.value=='') theForm.isbn.focus();");
    out.println("    return false;");
    out.println("  }");
    out.println("}");
    out.println("//-->");
    out.println("</script>");
    out.println("</head>");
    // here the body of the page is written out
    out.println("<body bgcolor='#cccc00'>");
    // write out the top status table
    out.println("<table border='0' cellpadding='5' bgcolor='#9999cc' align='center'>");
    out.println("<tr><th bgcolor='#cccc99'>STATUS</th></tr><tr><td align='center'>");
    // the contents of the status table come from here
    if (req.getParameter("deleteBook")!=null) {
      try {
        Statement st = conn.createStatement();
        st.executeUpdate("delete from books where isbn='" +
                         req.getParameter("books") + "';");
        out.println("Book with isbn " + req.getParameter("books") +
                    " successfully deleted.");
      } catch(SQLException e) {
        out.println("An error occurred while deleting the book with isbn " +
                    req.getParameter("books"));
      }
    } else if (req.getParameter("addBook")!=null) {
      try {
        Statement st = conn.createStatement();
        st.executeUpdate("insert into books (isbn, title, author, price) values ('" +
                         req.getParameter("isbn") + "', '" +
                         req.getParameter("title") + "', '" +
                         req.getParameter("author") + "', " +
                         req.getParameter("price") + ");");
        out.println("Book with isbn " + req.getParameter("isbn") +
                    " successfully added.");
      } catch(SQLException e) {
        out.println("An error occurred while inserting the book with isbn " +
                    req.getParameter("isbn"));
      }      
    } else {
      out.println("Welcome to the book administration page!");
    }
    out.println("</td></tr></table><p>");
    // the top form containing the book list
    out.println("<form name='booklist' method='post' action='dburger' " +
                "onsubmit='return validateDelete();'>");
    out.println("<table border='0' cellpadding='5' bgcolor='#9999cc' align='center'>");
    out.println("<tr><th bgcolor='#cccc99'>BOOK LIST</th></tr>");
    out.println("<tr><td>");
    // now render the book list
    out.println("<select name='books' size='10' multiple='false'>");
    try {
      Statement st = conn.createStatement();
      ResultSet rs = st.executeQuery("select title, author, price, isbn from books " +
                                     "order by author, title");
      while (rs.next()) {
        out.println("<option value='" + rs.getString(4) + "'>" + rs.getString(1) + ", " +
                    rs.getString(2) + ", " + rs.getDouble(3) + "</option>");
      }
    } catch (SQLException e) {
      out.println("<option>Unable to read book table</option>");
    }
    out.println("</select>");
    out.println("</td></td>");
    out.println("<tr><td align='right'><input type='submit' value='Delete' " +
                "name='deleteBook'></td></tr>");
    out.println("</table>");
    out.println("</form>");
    out.println("<p>");
    // the bottom form containing the book entry area
    out.println("<form name='bookentry' method='post' action='dburger' " +
                "onsubmit='return validateAdd();'>");
    out.println("<table border='0' cellpadding='5' bgcolor='#9999cc' align='center'>");
    out.println("<tr><th bgcolor='#cccc99' colspan='2'>BOOK ENTRY</th></tr>");
    out.println("<tr><td>ISBN:</td><td><input type='text' size='25' name='isbn' " +
                "maxlength='15'></td></tr>");
    out.println("<tr><td>Title:</td><td><input type='text' size='25' name='title' " +
                "maxlength='100'></td></tr>");
    out.println("<tr><td>Author:</td><td><input type='text' size='25' name='author' " +
                "maxlength='30'></td></tr>");
    out.println("<tr><td>Price:</td><td><input type='text' size='25' name='price'></td>" +
                "</tr>");
    out.println("<tr><td align='right' colspan='2'><input type='submit' value='Add' " +
                "name='addBook'>" +
                "<input type='reset' value='Clear'></td></tr>");
    out.println("</table>");
    out.println("</form>");
    // and finally the ending of the page
    out.println("</body></html>");
    out.close();
  }

}
