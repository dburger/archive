<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%@ page import="bookstore.admin.OrderManager" %>

<%@ page errorPage="bookstoreError.jsp" %>

<%@ page session="true" %>

<%! Connection conn; %>
<%! ArrayList shoppingCart; %>
<%! final double SHIP_COST = 9.99; %>
<%! String status = ""; %>

<%

  status = "";

  // users not logged in are not allowed to get to this checkout page!
  if (session.getAttribute("user_id")==null) response.sendRedirect("viewcart.jsp");

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

  // they shouldn't be allowed on this page with an empty cart
  if (shoppingCart.size()==0) response.sendRedirect("viewcart.jsp");
  
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
    // this page has a purchase button on it...don't let them on this page without books
    response.sendRedirect("viewcart.jsp");
  } else if (request.getParameter("login")!=null) {
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery("select user_id from user where user_id='" +
                                   request.getParameter("user_id") + "' and password='" +
                                   request.getParameter("password") + "'");
    if (rs.next())
      session.setAttribute("user_id",request.getParameter("user_id"));      
  } else if (request.getParameter("logout")!=null) {
    session.removeAttribute("user_id");
    session.setAttribute("user_id",null);  // weird behavior, needed to do both    
    // don't let them on this page not logged in
    response.sendRedirect("viewcart.jsp");
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
  } else if (request.getParameter("purchase")!=null) {
    // Order going into system...once again a real implemenation would need to do some
    // serious credit card validation and processing.  For this demo we leave the
    // credit card processing alone.
    String itemString, isbn;
    int commaPos, quantity=0, totalItems=0;
    double totalPrice=0;
    OrderManager orderMan = new OrderManager(conn);
    Statement st = conn.createStatement();
    ResultSet rs;
    // will have to update shipping and total cost after we know them
    int orderId = orderMan.insertOrder((String)session.getAttribute("user_id"),0,0);
    for (int i=0;i<shoppingCart.size();i++) {
      itemString = (String)shoppingCart.get(i);
      commaPos = itemString.indexOf(',');
      isbn = itemString.substring(0,commaPos);
      quantity = Integer.parseInt(itemString.substring(commaPos+1));
      rs = st.executeQuery("select price from book where isbn='" + isbn + "';");
      if (rs.next()) {
        orderMan.insertOrderDetail(orderId, isbn, quantity, rs.getDouble("price"));
        totalItems += quantity;
        totalPrice += quantity * rs.getDouble("price");
      } else {
        // this could occur if the book was deleted out from under them, we might want
        // to invalidate the order if this were to happen, giving them a message and
        // sending the back to the shopping cart
      }
    }
    // now update the shipping and total cost in the order
    st.executeUpdate("UPDATE orders " + 
                     "SET total_cost=" + (totalPrice + SHIP_COST) + ", " +
                     "shipping_cost=" + SHIP_COST + " " +
                     "WHERE order_id=" + orderId + ";");
    // clear the shopping cart
    shoppingCart = new ArrayList();
    session.setAttribute("shoppingCart",shoppingCart);
    // and now...thank you!
    response.sendRedirect("thankyou.jsp");
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

// This function returns a Date object given a dateString in the
// mm/dd/yyyy format.  If the dateString is invalid null is returned.
function parseDate(dateString) {
  var month, day, year, parsedDate;
  parsedDate = dateString.split("/");
  if (parsedDate.length==2) {
    month = parsedDate[0];
    day = 1; // assuming first of the month expiration
    year = parsedDate[1];
  } else if (parsedDate.length==3) {
    month = parsedDate[0];
    day = parsedDate[1];
    year = parsedDate[2];
  } else
    return null;
  if (isNaN(month) || isNaN(day) || isNaN(year)) return null;
  // 70 is the earliest year the Date() object will handle
  if (month<1 || month>12 || day<1 || day>31 || year<70) return null;
  month--; //month is zero based for the Date object
  // create the Date object
  var theDate = new Date(year,month,day);
  // if the constructor changed the day...the dateString wasn't valid
  // from a number of days in month perspective (30 vs. 31, leap year etc.)
  if (theDate.getDate()!=day)
    return null;
  else
    return theDate;
}

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

function validateCreditCard() {
  // a real implementation would have to carefully validate the credit card info.
  // using validation algorithms and then electronic credit card lookup stuff,
  // for this example bookstore we will just check that they have filled in the
  // fields
  var theForm = document.forms['checkout'];
  var errorString = "";
  if (theForm.cardNumber.value=="")
    errorString += "Please enter the card number.";
  if (theForm.expireDate.value=="")
    errorString += "\nPlease enter an expiration date.";
  // first check to see if they filled in the required fields
  if (errorString.length) {
    alert(errorString);
    if (theForm.expireDate.value=="") theForm.expireDate.focus();
    if (theForm.cardNumber.value=="") theForm.cardNumber.focus();
    return false;
  }

  // simple minded validation of the credit card number
  if (theForm.cardNumber.value.length!=16 || isNaN(theForm.cardNumber.value)) {
    alert("Please enter the card number as a continuous\n" +
          "number with no spaces or dashes.");
    theForm.cardNumber.focus();
    return false;
  }

  // checking for valid expiration date
  var expireDate = parseDate(theForm.expireDate.value);
  if (expireDate==null) {
    alert("Please enter a valid expiration date.");
    theForm.expireDate.focus();
    return false;
  }
  // now check if date is in the future
  var now = new Date();
  if (expireDate.getTime()<now.getTime()) {
    alert("The expiration date must be a future date.");
    theForm.expireDate.focus();
    return false;
  }
  return true;
}

//-->
</script>
</head>
<body>

<form name="login" method="POST" action="checkout.jsp" onsubmit="return validateLogin();">
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
        out.println("[" + totalQuantity + " items in <a href='viewcart.jsp'>" +
                    "shopping cart</a>]  [<a href='checkout.jsp?clearCart='>" +
                    "clear cart</a>]");
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

<!-- main table that has a right column for search/category and the main left column -->
<table width="100%">
  <tr>

    <!-- this is the main left column -->
    <td valign="top">
      
      <form method="post" name="checkout" action="checkout.jsp"
       onsubmit="return validateCreditCard();">
      <table class='outerTable'>        
        <tr>
          <td class='outlineCell'>
            <table class='innerTable'>
              <tr><td colspan='6'><strong>Shopping Cart Contents:</strong></td></tr>
              <tr><td colspan='6' class="outlineCell"></td></tr>
              <tr><th>Quantity</th><th>isbn</th><th>Title</th><th>Publisher</th>
                <th>Unit<br/>Price</th><th>Extended<br/>Price</th></tr>
                <%        
                  String isbn;
                  int quantity;
                  double totalPrice = 0;
                  if (shoppingCart.size()==0) {        
                    out.println("<tr><td colspan='6'>There are no books in your " +
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
                        out.println("<td align='right'>" + quantity + "</td>");
                        out.println("<td><span class='isbn'>" + isbn + "</span></td>");
                        out.println("<td><span>" + rs.getString("title") +
                                    "</span></td>");
                        out.println("<td><span class='publisher'>" +
                                    rs.getString("publisher") + "</span></td>");
                        out.println("<td align='right'><span class='price'>" +
                                    rs.getString("price") + "</span></td>");
                        out.println("<td align='right'><span class='price'>" +
                                    NumberFormat.getCurrencyInstance(Locale.US).format(
                                      quantity * rs.getDouble("price")) +
                                    "</span></td>");
                        totalPrice += quantity * rs.getDouble("price");
                        line++;
                      } else {
                        // isbn in cart not located in database
                        shoppingCart.remove(i);
                      }
                    }
                    out.println("<tr><td colspan='5' align='right'>subtotal: </td>" +
                                "<td align='right'><span class='price'>" +
                                NumberFormat.getCurrencyInstance(Locale.US).format(
                                  totalPrice) +
                                "</span></td></tr>");
                    out.println("<tr><td colspan='5' align='right'>shipping: </td>" +
                                "<td align='right'><span class='price'>" +
                                NumberFormat.getCurrencyInstance(Locale.US).format(
                                  SHIP_COST) +
                                "</span></td></tr>");
                    out.println("<tr><td colspan='5' align='right'>Grand Total:</td>" +
                                "<td align='right'><span class='price'>" +
                                NumberFormat.getCurrencyInstance(Locale.US).format(
                                  totalPrice+SHIP_COST) +
                                "</span></td></tr>");
                    out.println("<tr><td>Credit Card:</td><td colspan='5' align='right'" +
                                " nowrap>Type:" +
                                "<select name='cardType'>" +
                                "<option value='visa'>Visa</option>" +
                                "<option value='mastercard'>Master Card</option>" +
                                "<option value='discover'>Discover</option>" +
                                "<option value='amex'>American Express</option>" +
                                "</select>" +
                                "Number:<input type='text' name='cardNumber' size='12'/>"+
                                "Expires:<input type='text' name='expireDate' size='5'/>"+
                                "</td></tr>");                                  
                    out.println("<tr><td colspan='5' align='right' nowrap> To modify " +
                                "your order choose <a href='viewcart.jsp'>view cart" +
                                "</a>.  To place your order click here: </td>" +
                                "<td><input type='submit' name='purchase' " +
                                "value='Purchase'></td></tr>");
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