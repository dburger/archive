<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.NumberFormat" %>

<%@ page errorPage="bookstoreError.jsp" %>

<%@ page session="true" %>

<%! Connection conn; %>
<%! ArrayList shoppingCart; %>
<%! String userID = ""; %>
<%! String password = ""; %>
<%! String firstName = ""; %>
<%! String lastName = ""; %>
<%! String address1 = ""; %>
<%! String address2 = ""; %>
<%! String city = ""; %>
<%! String state = ""; %>
<%! String zip = ""; %>
<%! String country = ""; %>
<%! String submitText = "Join"; %>
<%! String status = ""; %>

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
  
  status = "";
  
  if (request.getParameter("submit")!=null) {
    if (session.getAttribute("user_id")!=null) {
      // code here to do update query of the user that is logged in
      // create and execute an update sql statement
      // NOTE, we have a real problem with the user changing his user_id !!!      
      // if we let them change the user_id then we need to do our own cascading updates
      // OR...we can let another field that is never shown be the primary key for the
      // user table and then relate tables with that key, allowing them to change the
      // user_id
      // ALSO NOTE, if we allow change of user_id we must check to make sure that user_id
      // doesn't already exist before running this update !!
      try {
        String queryString = "update user set " +
                              " password='" + request.getParameter("password1") + "'," +
                              " first_name='" + request.getParameter("first_name") + "',"+
                              " last_name='" + request.getParameter("last_name") + "'," +
                              " address_1='" + request.getParameter("address_1") + "'," +        
                              " address_2='" + request.getParameter("address_2") + "'," +
                              " city='" + request.getParameter("city") + "'," +
                              " state='" + request.getParameter("state") + "'," +
                              " zip='"  + request.getParameter("zip") + "'," +
                              " country='" + request.getParameter("country") + "' " +
                              " where user_id='" + session.getAttribute("user_id") +"';";
        Statement st = conn.createStatement();
        st.executeUpdate(queryString);
      } catch (SQLException e) {
        // figure out what to do in case of error
      }
      status = "Your information has been modified and is shown below.";
    } else {
      // code here to create the new user and ...
      // create and execute an insert sql statement
      // at the end of this session.setAttribute("user_id", the new user id);
      // ALSO needs to check if the user_id already exists
      try {
        String queryString = "insert into user (user_id,password,first_name,last_name," +
                             "address_1,address_2,city,state,zip,country) values ('" +
                             request.getParameter("user_id") + "','" +
                             request.getParameter("password1") + "','" +
                             request.getParameter("first_name") + "','" +
                             request.getParameter("last_name") + "','" +
                             request.getParameter("address_1") + "','" +
                             request.getParameter("address_2") + "','" +
                             request.getParameter("city") + "','" +
                             request.getParameter("state") + "','" +
                             request.getParameter("zip") + "','" +
                             request.getParameter("country") + "');";
        Statement st = conn.createStatement();
        st.executeUpdate(queryString);
        session.setAttribute("user_id",request.getParameter("user_id"));
      } catch (SQLException e) {
        // figure out what to do in case of error        
      }
      status = "You have been entered as a new user and your information is shown below.";
    }
  } else if (request.getParameter("clearCart")!=null) {
    shoppingCart = new ArrayList();
    session.setAttribute("shoppingCart",shoppingCart);
  } else if (request.getParameter("login")!=null) {
    try {
      Statement st = conn.createStatement();
      ResultSet rs = st.executeQuery("SELECT * from user where user_id='" +
                                     request.getParameter("user_id") + "' and password='"+
                                     request.getParameter("password") + "'");
      if (rs.next())
        session.setAttribute("user_id",request.getParameter("user_id"));      
    } catch (SQLException e) {
      // figure out what to do in case of error
    }
  } else if (request.getParameter("logout")!=null) {
    session.removeAttribute("user_id");
    session.setAttribute("user_id",null);  // weird behavior, needed to do both
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
 
  function validateInformation() {
     //need to check the user information,
     //textfields should be filled except address_2
     var errorString = "";
     var thisForm = document.forms['information'];
     if (thisForm.user_id.value=="")
        errorString += "Please enter a user id.";
     if (thisForm.first_name.value=="")
        errorString += "\nPlease enter user's first name.";
     if (thisForm.last_name.value=="")
        errorString += "\nPlease enter user's last name.";
     if (thisForm.password1.value=="")
        errorString += "\nPlease enter a password.";
     if (thisForm.password2.value=="")
        errorString += "\nPlease re-enter a user password.";
     if (thisForm.password2.value != thisForm.password1.value)
        errorString += "\nPassword re-entered must be the same as previous one.";
     if (thisForm.address_1.value=="")
        errorString += "\nPlease enter user's address first line.";
     if (thisForm.city.value=="")
        errorString += "\nPlease enter a city name.";
     if (thisForm.state.value=="")
        errorString += "\nPlease enter a state name.";
     if (thisForm.zip.value=="")
        errorString += "\nPlease enter a zip code.";
     if (thisForm.country.value=="")
        errorString += "\nPlease enter a country name.";
     if (errorString.length) {
      // go reverse so first has focus
        if (thisForm.country.value=="") thisForm.country.focus();
        if (thisForm.zip.value=="") thisForm.zip.focus();
        if (thisForm.state.value=="") thisForm.state.focus();
        if (thisForm.city.value=="") thisForm.city.focus();
        if (thisForm.address_1.value=="") thisForm.address_1.focus();
        if (thisForm.password2.value=="") thisForm.password2.focus();
        if (thisForm.password1.value=="") thisForm.password1.focus();
        if (thisForm.last_name.value=="") thisForm.last_name.focus();
        if (thisForm.first_name.value=="") thisForm.first_name.focus();
        if (thisForm.user_id.value=="") thisForm.user_id.focus();
        alert(errorString);
        return false;
     } else
          return true;
   }
  
  //-->
  </script>
</head>
<body>

<form name="login" method="POST" action="userinfo.jsp" onsubmit="return validateLogin();">
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
                    "cart</a>]  [<a href='userinfo.jsp?clearCart='>clear cart</a>]");
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
    
      <%
        // here determine if someone is logged in and if they are,
        // set all the variables...firstName, lastName, password, etc.
                
        if (session.getAttribute("user_id")==null) {
          // this shouldn't be necessary as the variables are declared to "" above,
          // but it was still filling in the fields !!! really!
          userID = "";
          password = "";
          firstName = "";
          lastName = "";
          address1 = "";
          address2 = "";
          city = "";
          state = "";
          zip = "";
          country = "";
          submitText = "Join";
        } else {
          String queryString = "SELECT user_id, password, first_name, last_name, " +
                               "address_1, address_2, city, state, zip, country " +
                               "FROM user " +
                               "WHERE user_id = '" + session.getAttribute("user_id") +
                               "';";
          Statement st = conn.createStatement();
          ResultSet rs = st.executeQuery(queryString);
          if (rs.next()) {
            userID = rs.getString("user_id");
            password = rs.getString("password");
            firstName = rs.getString("first_name");
            lastName = rs.getString("last_name");
            address1 = rs.getString("address_1");
            address2 = rs.getString("address_2");
            city = rs.getString("city");
            state = rs.getString("state");
            zip = rs.getString("zip");
            country = rs.getString("country");
            submitText = "Modify";
          }        
        }
        
        if (address2==null) address2 = "";
        
        out.println(status);
      
      %>     
      
      <!-- code here...here is where the form goes -->
      <form name="information" method="post" action="userinfo.jsp"
       onsubmit="return validateInformation();">
        <table class='outerTable'>        
          <tr>
            <td class='outlineCell'>
              <table class='innerTable'>
                <tr><td colspan='2'><strong>User Information:</strong></td></tr>
                <tr><td colspan='2' class="outlineCell"></td></tr>
                <tr>
                  <td >User ID:</td>
                  <td >
                    <%
                      // not allowing them to change the user_id
                      if (session.getAttribute("user_id")==null)
                        out.println("<input type='text' name='user_id' size='20'/>");
                      else {
                        out.println(session.getAttribute("user_id"));
                        // and so the validation javascript can still get the user_id so
                        // it doesn't have to be made specific logged in / not logged in
                        out.println("<input type='hidden' name='user_id' value='" +
                                    session.getAttribute("user_id") + "'/>");
                      }
                    %>
                  </td>
                </tr>                
                <tr>
                  <td >First Name:</td>
                  <td >
                    <input type='text' name='first_name' size='20'
                     value='<%=firstName%>'/>
                  </td>
                </tr>
                <tr>
                  <td>Last Name:</td>
                  <td>
                    <input type='text'name='last_name' size='20' value='<%=lastName%>'/>
                  </td>
                </tr>                
                <tr>
                  <td >Password:</td>
                  <td >
                    <input type='password' name='password1' size='20'
                     value='<%=password%>'/>
                  </td>
                </tr>

                <tr>
                  <td >Re-type Password:</td>
                  <td >
                    <input type='password' name='password2' size='20'
                     value='<%=password%>'/>
                  </td>
                </tr>
                <tr>
                  <td>Address_1:</td>
                  <td>
                    <input type='text' name='address_1' size='20' value='<%=address1%>'/>
                  </td>
                </tr>
                <tr>
                  <td>Address_2:</td>
                  <td>
                    <input type='text' name='address_2' size='20' value='<%=address2%>'/>
                  </td>
                </tr>
                <tr>
                  <td>City:</td>
                  <td>
                    <input type='text' name='city' size='20' value='<%=city%>'/>
                  </td>
                </tr>
                <tr>
                  <td>State:</td>
                  <td>
                    <input type='text' name='state' size='20' value='<%=state%>'/>
                  </td>
                </tr>
                <tr>
                  <td>Zip Code:</td>
                  <td>
                    <input type='text' name='zip' size='20' value='<%=zip%>'/>
                  </td>
                </tr>
                <tr>
                  <td>Country:</td>
                  <td>
                    <input type='text' name='country' size='20' value='<%=country%>'/>
                  </td>
                </tr>
                <tr>
                  <td colspan='2' align='right'>
                    <input type='submit' name='submit' value='<%=submitText%>'/>
                    <input type='reset' name='clear' value='Clear'/>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </form>
      
     <%
       if (session.getAttribute("user_id")!=null) {
         Statement st = conn.createStatement();
         ResultSet rs = st.executeQuery("SELECT * FROM user, orders, order_detail, book " +
                                        "WHERE user.user_id=orders.user_id " +
                                        "AND orders.order_id=order_detail.order_id " +
										"AND order_detail.isbn=book.isbn " +
                                        "AND user.user_id='" +
                                        session.getAttribute("user_id") + "' " +
                                        "ORDER BY orders.order_id;");
         int prevOrderId = 0;
         int line=0;
		 double shippingCost=0,totalCost=0;
         while (rs.next()) {
           if (prevOrderId!=rs.getInt("order_id")) {
             line = 0; // reset even odd tracker
			 if (prevOrderId!=0) {// need to close off last table
               out.println("<tr><td colspan='5' align='right'>shipping: </td>" +
                           "<td align='right'><span class='price'>" +
                           NumberFormat.getCurrencyInstance(Locale.US).format(
                             shippingCost) +
                           "</span></td></tr>");
               out.println("<tr><td colspan='5' align='right'>Grand Total:</td>" +
                           "<td align='right'><span class='price'>" +
                           NumberFormat.getCurrencyInstance(Locale.US).format(totalCost) +
                           "</span></td></tr>");
			   out.println("</table></td></tr></table><p>");
             } else
			   out.println("Order history:<p>");

             // start the new table
			 out.println("<table class='outerTable'><tr><td class='outlineCell'>" +
                         "<table class='innerTable'><tr><td colspan='6'><strong>" +
                         rs.getString("date_ordered") + "</strong></td></tr><tr>" +
                         "<td colspan='6' class='outlineCell'></td></tr><tr>" +
                         "<th>Quantity</th><th>isbn</th><th>Title</th>" +
                         "<th>Publisher</th><th>Unit<br/>Price</th>" +
                         "<th>Extended<br/>Price</th></tr>");
			 prevOrderId = rs.getInt("order_id");
			 shippingCost = rs.getDouble("shipping_cost");
			 totalCost = rs.getDouble("total_cost");
           }
           out.println("<tr ");
           if (line % 2 == 0)
             out.println("class='evenDetailRow'>");
           else
             out.println("class='oddDetailRow'>");
           out.println("<td align='right'>" + rs.getInt("order_detail.quantity") +
                       "</td>");
           out.println("<td><span class='isbn'>" + rs.getString("isbn") + "</span></td>");
           out.println("<td><span>" + rs.getString("title") + "</span></td>");
           out.println("<td><span class='publisher'>" + rs.getString("publisher") +
                       "</span></td>");
           out.println("<td align='right'><span class='price'>" + rs.getString("price") +
                       "</span></td>");
           out.println("<td align='right'><span class='price'>" +
                       NumberFormat.getCurrencyInstance(Locale.US).format(
                         rs.getInt("order_detail.quantity") * rs.getDouble("price")) +
                       "</span></td>");
           line++;
         }
		 if (prevOrderId!=0) {
           out.println("<tr><td colspan='5' align='right'>shipping: </td>" +
                       "<td align='right'><span class='price'>" +
                       NumberFormat.getCurrencyInstance(Locale.US).format(shippingCost) +
                       "</span></td></tr>");
           out.println("<tr><td colspan='5' align='right'>Grand Total:</td>" +
                       "<td align='right'><span class='price'>" +
                       NumberFormat.getCurrencyInstance(Locale.US).format(totalCost) +
                       "</span></td></tr>");
           out.println("</table></td></tr></table><p>");
         }
       }
     %>
    </td>
    <!-- the cell at the right -->
    <td width="200" valign="top">
      <!-- this is the right column --></td>

  </tr>
</table>

</body>
</html>
