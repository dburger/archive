<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%@ page errorPage="bookstoreError.jsp" %>

<%@ page session="true" %>

<%! Connection conn; %>
<%! ArrayList shoppingCart; %>

<%
  conn = (Connection)application.getAttribute("connection");
  if (conn==null) {
    try {
      DriverManager.registerDriver(new org.gjt.mm.mysql.Driver());
      conn = DriverManager.getConnection("jdbc:mysql:///bookstore");
      application.setAttribute("connection",conn);
    } catch (SQLException e) {
      throw new ServletException("Unable to create a connection to the database.",e);
    }
  }

  shoppingCart = (ArrayList)session.getAttribute("shoppingCart");
  if (shoppingCart==null) {
    shoppingCart = new ArrayList();
    session.setAttribute("shoppingCart",shoppingCart);
  }
  
  if (request.getParameter("removeISBN")!=null) {
    String itemString, isbn, removeISBN = request.getParameter("removeISBN");
    int commaPos;
    for (int i=0;i<shoppingCart.size();i++) {
      itemString = (String)shoppingCart.get(i);
      commaPos = itemString.indexOf(',');
      isbn = itemString.substring(0,commaPos);
      if (isbn.equals(removeISBN)) {
        shoppingCart.remove(i);
        break;
      }
    }
  } else if (request.getParameter("clearCart")!=null) {
    shoppingCart = new ArrayList();
    session.setAttribute("shoppingCart",shoppingCart);
  } else if (request.getParameter("login")!=null) {
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery("select user_id from user where user_id='" +
                                   request.getParameter("user_id") +
                                   "' and password='" + request.getParameter("password") +
                                   "'");
    if (rs.next())
      session.setAttribute("user_id",request.getParameter("user_id"));      
  } else if (request.getParameter("logout")!=null) {
    session.removeAttribute("user_id");
    session.setAttribute("user_id",null);  // weird behavior, needed to do both    
  } else if (request.getParameter("update")!=null) {
    String itemString,isbn;
    int commaPos, newQuantity;
    // going in reverse to avoid the skip over problem when removing an item
    for (int i=shoppingCart.size()-1;i>=0;i--) {
      itemString = (String)shoppingCart.get(i);
      commaPos = itemString.indexOf(',');
      isbn = itemString.substring(0,commaPos);
      try {
        newQuantity = Integer.parseInt((String)request.getParameter(isbn));
      } catch (NumberFormatException e) {
        // they entered non-numeric value not caught by validater, just leave same value
        newQuantity = Integer.parseInt(itemString.substring(commaPos+1));
      }
      if (newQuantity>0)
        shoppingCart.set(i,isbn + "," + newQuantity);
      else
        shoppingCart.remove(i);
    }
  }
  
%>
<html>
<head>
<title>rdbwbooks.com</title>
<style type = "text/css">
  <!--
  @import url(stylesheet/bookstore.css);
  -->
</style>
<script language="javascript">
<!--

function validateLogin() {
  //need to check the data entered by the user
  var errorString = "";
  var theForm = document.forms['login'];
  if (theForm.user_id.value=="")
    errorString += "Please enter a user id.";
  if (theForm.password.value=="")
    errorString += "\nPlease enter a password.";
  if (errorString.length) {
    // go reverse so first has focus
    if (theForm.password.value=="") theForm.password.focus();
    if (theForm.user_id.value=="") theForm.user_id.focus();
    alert(errorString);
    return false;
  } else
    return true;
}

//-->
</script>
</head>
<body>

<form name="login" method="POST" action="viewcart.jsp" onsubmit="return validateLogin();">
<!-- this table extends across the top of the page with logo left, login right -->
<table width="100%">
  <tr>
    <td align="left"><img src="images/logo_small.gif" width="148" height="27"
                      alt="rdbwbooks.com"></td>
    <td align="right">
      <%
        // this is right side top
        String itemString;
        int commaPos, totalQuantity = 0;
        for (int i=0;i<shoppingCart.size();i++) {
          itemString = (String)shoppingCart.get(i);
          commaPos = itemString.indexOf(',');
          totalQuantity += Integer.parseInt(itemString.substring(commaPos+1));
        }
        out.println("[" + totalQuantity + " items in <a href='viewcart.jsp'>shopping " +
                    "cart</a>]  [<a href='viewcart.jsp?clearCart='>clear cart</a>]");
      %>
    </td>
  </tr>
</table>

<!-- this is the "red bar" table at the top -->
<table width="100%" cellpadding="5" cellspacing="0">
  <tr class="mainBar">
    <td>
      <a href="index.jsp"><img src="images/home.gif" width='83' height='28' border="0"
                           alt="home"/></a>
      <a href="viewcart.jsp"><img src="images/viewcart.gif" width='153' height='28'
                              border="0" alt="view cart"/></a>
      <%
        if (session.getAttribute("user_id")!=null)
          out.println("<a href='userinfo.jsp'><img src='images/userinfo.gif' " +
                      "width='105' height='28' border='0' alt='user information'/></a>");
        else
         out.println("<a href='userinfo.jsp'><img src='images/signup.gif' width='105' " +
                     "height='28' border='0' alt='sign up'/></a>");
      %>
      
    </td>
    <td align="right" nowrap>
      <!-- code here to determine if they are already logged in
        -- if yes, then don't display the login stuff, display
        -- you are logged in as blah...                         -->
      <%
        if (session.getAttribute("user_id")==null) {
          out.println("User ID:");
          out.println("<input type='text' name='user_id' size='10'>");
          out.println("Password:");
          out.println("<input type='password' name='password' size='10'>");
          out.println("<input type='submit' name='login' value='login'/>");
        } else {
          out.println("Logged in as: <a href='userinfo.jsp'>" +
                      session.getAttribute("user_id") + "</a>");
          out.println("<input type='submit' name='logout' value='logout'/>");
        }
      %>
    </td>
  </tr>
</table>
</form>

<!-- the main table that has right column for search/category and main left column -->
<table width="100%">
  <tr>

    <!-- this is the main left column -->
    <td valign="top">
      
      <form method="post" action="viewcart.jsp">
      <table class='outerTable'>        
        <tr>
          <td class='outlineCell'>
            <table class='innerTable'>
              <tr><td colspan='7'><strong>Shopping Cart Contents:</strong></td></tr>
              <tr><td colspan='7' class="outlineCell"></td></tr>
              <tr><th></th><th>Quantity<br/>
              <input type="submit" name="update" value="update"/>
              </th>
              <th>isbn</th><th>Title</th><th>Publisher</th><th>Unit<br/>Price</th>
              <th>Extended<br/>Price</th></tr>
                <%        
                  String isbn;
                  int quantity;
                  double totalPrice = 0;
                  if (shoppingCart.size()==0) {        
                    out.println("<tr><td colspan='7'>There are no books in your " +
                                "shopping cart.</td></tr>");
                  } else {
                    int line = 0;
                    for (int i=0;i<shoppingCart.size();i++) {
                      itemString = (String)shoppingCart.get(i);
                      commaPos = itemString.indexOf(',');
                      isbn = itemString.substring(0,commaPos);
                      quantity = Integer.parseInt(itemString.substring(commaPos+1));
                      Statement st = conn.createStatement();
                      ResultSet rs = st.executeQuery("select title, publisher, price " +
                                                     "from book where isbn='" + isbn +
                                                     "';");
                      if (rs.next()) {
                        out.println("<tr ");
                        if (line % 2 == 0)
                          out.println("class='evenDetailRow'>");
                        else
                          out.println("class='oddDetailRow'>");
                        out.println("<td><a href='viewcart.jsp?removeISBN=" +
                                    isbn + "'>delete</a></td>");
                        out.println("<td><input type='text' style='text-align:right' " +
                                    "name='" + isbn + "' value ='" +
                                    quantity + "' size='6'/></td>");
                        out.println("<td><span class='isbn'>" + isbn + "</span></td>");
                        out.println("<td><span>" + rs.getString("title") +
                                    "</span></td>");
                        out.println("<td><span class='publisher'>" +
                                    rs.getString("publisher") + "</span></td>");
                        out.println("<td align='right'><span class='price'>" +
                                    rs.getString("price") + "</span></td>");
                        out.println("<td align='right'><span class='price'>" +
                                    NumberFormat.getCurrencyInstance(Locale.US).format(
                                      quantity * rs.getDouble("price")) + "</span></td>");
                        totalPrice += quantity * rs.getDouble("price");
                        line++;
                      } else {
                        // isbn in cart not located in database
                        shoppingCart.remove(i);
                      }
                    }
                    out.println("<tr><td colspan='7' align='right'>Total: " +
                                "<span class='price'>" +
                                NumberFormat.getCurrencyInstance(Locale.US).format(
                                  totalPrice) +
                                "</span></td></tr>");
                    if (session.getAttribute("user_id")==null) {
                      out.println("<tr><td colspan='6' align='right'>" +
                                  "Before you can check out you need to login above or:" +
                                  " </td><td><a href='userinfo.jsp'>" +
                                  "<img src='images/signup.gif' width='105' height='28'" +
                                  " border='0' alt='sign up' align='right'/></a>" +
                                  "</td></tr>");
                    } else {
                      out.println("<tr><td colspan='7' align='right'>" +
                                  "<a href='checkout.jsp'>" +
                                  "<img src='images/checkout.gif' width='105' " +
                                  "height='28' border='0'/></a></td></tr>");
                    }
                  }
                %>
              </table>
            </td>
          </tr>
        </table>
        </form>

    </td>

    <!-- the cell at the right -->
    <td width="200" valign="top">
      <!-- this is the right column -->
    </td>

  </tr>
</table>

</body>
</html>