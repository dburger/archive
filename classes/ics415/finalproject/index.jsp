<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>

<%@ page errorPage="bookstoreError.jsp" %>

<%@ page session="true" %>

<%! Connection conn; %>
<%! ArrayList shoppingCart; %>
<%! final int MAX_RECORDS = 10; %>
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
  
  if (request.getParameter("addToCart")!=null) {
    String itemString, isbn, newISBN = request.getParameter("addToCart");
    int commaPos, quantity;
    int i;
    for (i=0;i<shoppingCart.size();i++) {
      itemString = (String)shoppingCart.get(i);
      commaPos = itemString.indexOf(',');
      isbn = itemString.substring(0,commaPos);
      quantity = Integer.parseInt(itemString.substring(commaPos+1));
      if (isbn.equals(newISBN)) {
        quantity++;
        shoppingCart.set(i,isbn + "," + quantity);
        break;
      }
    }
    if (i==shoppingCart.size())
      shoppingCart.add(newISBN + ",1");
  } else if (request.getParameter("clearCart")!=null) {
    shoppingCart = new ArrayList();
    session.setAttribute("shoppingCart",shoppingCart);
  } else if (request.getParameter("login")!=null) {
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery("select * from user where user_id='" +
                                   request.getParameter("user_id") +
                                   "' and password='" +
                                   request.getParameter("password") + "'");
    if (rs.next())
      session.setAttribute("user_id",request.getParameter("user_id"));
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

function validateSearch() {
  var errorString = "";
  var theForm = document.forms['search'];
  if (theForm.searchFor.value=="")
    errorString+="Please enter text to search for.";
  if (errorString.length) {
    theForm.searchFor.focus();
    alert(errorString);
    return false;
  } else
    return true;
}

//-->
</script>
</head>
<body>

<form name="login" method="post" action="index.jsp" onsubmit="return validateLogin();">
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
        out.println("[" + totalQuantity +
                    " items in <a href='viewcart.jsp'>shopping cart</a>]  " +
                    "[<a href='index.jsp?clearCart='>clear cart</a>]");
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
      
        String queryString = "SELECT distinct book.isbn, book.title, book.author_first," +
                             " book.author_last, book.publisher, book.price " +
                             "FROM book, book_category " +
                             "WHERE book.isbn=book_category.isbn";
        int firstRecord = 0;
        
        // NOTE:  login and addToCart was handled above so that the login information and
        // number of items in the cart would be displayed correctly !!!
        if (request.getParameter("search")!=null) { // coming from search form
          queryString += " and book." + request.getParameter("searchWhat");
          queryString += " like '%" + request.getParameter("searchFor") + "%'";                      
          if (!request.getParameter("searchCategory").equals("all")) {
            queryString += " and book_category.category='" +
              request.getParameter("searchCategory") + "'";
          }
          // out.println(queryString); // for debugging
        } else if (request.getParameter("category")!=null) { // from a category click
          queryString += " and book_category.category='" +
            request.getParameter("category") + "'";
        } else if (request.getParameter("lastQuery")!=null) { // moving through set
          queryString = request.getParameter("lastQuery");
          firstRecord = Integer.parseInt(request.getParameter("firstRecord"));
        } else if (request.getParameter("advancedSearch")!=null) {  // advanced search
          queryString = request.getParameter("advancedSearch");
        } else { // coming straight to this page
          // could do something here to decide what to show user on a first visit page
        }
        
        String lastQuery = queryString;        
        queryString += " limit " + firstRecord + "," + (MAX_RECORDS*2); // *2 for leftover
        
        //out.println(queryString);  // used for debugging
                 
        // code here to generate the list of books
        int recordCount = 0;
        try {
          Statement st = conn.createStatement();
          ResultSet rs = st.executeQuery(queryString);
          while (recordCount < MAX_RECORDS && rs.next()) {
            out.println("<table class='bookList'><tr>");
            // hard coded book image for now, fancy implementation has book images
            out.println("<td class='coverImageCell'><img src='images/unavailable.jpg'/>" +
                        "</td>");
            out.println("<td class='bookInfoCell'>");
            out.println("<span class='title'>" + rs.getString("title") + "</span><br/>");
            out.println("<span class='author'>" + rs.getString("author_first") + " " +
                        rs.getString("author_last") + "</span><br/>");
            out.println("<span class='publisher'>" + rs.getString("publisher") +
                        "</span><br/>");
            out.println("ISBN: <span class='isbn'>" + rs.getString("isbn") +
                        "</span><br/>");
            out.println("Price: <span class='price'>" + rs.getDouble("price") +
                        "</span><br/>");
            out.println("<a href='index.jsp?addToCart=" + rs.getString("isbn") +
                        "&lastQuery=" + URLEncoder.encode(lastQuery) + "&firstRecord=" +
                        firstRecord + "'>Add to Cart</a>");
            out.println("</td>");
            out.println("</tr></table>");
            out.println("<hr class='sepBar'/>");            
            recordCount++;
          }
          // now for the << and >> for moving through the ResultSet
          out.println("<p align='center'>");
          // should we do a left arrow ?
          if (firstRecord>0) {
            out.println("<a href='index.jsp?lastQuery=" + URLEncoder.encode(lastQuery) +
                        "&firstRecord=" + (firstRecord-MAX_RECORDS)  + "'>[&lt;&lt;prev "+
                        MAX_RECORDS + " books]</a>");
          }
          // should we do a right arrow ?, and how many for >>
          int leftOverRecords = 0;
          while (rs.next()) leftOverRecords++;
          if (leftOverRecords>0) {
            out.println("<a href='index.jsp?lastQuery=" + URLEncoder.encode(lastQuery) +
                        "&firstRecord=" + (firstRecord+MAX_RECORDS) + "'>[next " +
                        leftOverRecords + " books&gt;&gt;]</a>");
          }
        } catch (SQLException e) {
          out.println("error");                      
        }                      

        if (recordCount==0) out.println("Your search returned 0 books.");
        out.println("</p>");
        
      %>
    
    </td>

    <!-- the search/category cell at the right -->
    <td width="200" valign="top">

      <!-- the search box -->
      <form name="search" method="post" action="index.jsp"
       onsubmit="return validateSearch();">
      <table class="outlineTable" width="100%">
        <tr>
          <td class="outlineCell">
            <table class="innerTable">
              <tr><td><strong>Search for:</strong></td></tr>
              <tr><td class="outlineCell"></td></tr>
              <tr>
                <td><input type="text" name="searchFor" style="width:140pt"/></td>
              </tr>
              <tr>
                <td align="center">
                  <input type="radio" name="searchWhat" value="title" checked>Title
                  </input>
                  <input type="radio" name="searchWhat" value="author_last">Author</input>
                  <input type="radio" name="searchWhat" value="isbn">ISBN</input>
                </td>
              <tr>
                <td>
                  <select name="searchCategory" style="width:140pt">
                    <option value="all">all categories</option>                  
                    <%
                      try {
                        Statement st = conn.createStatement();
                        ResultSet rs = st.executeQuery("SELECT category " +
                                                       "FROM category " +
                                                       "ORDER BY category");
                        while (rs.next()) {
                          out.println("<option value='" + rs.getString("category") + "'>"+
                                      rs.getString("category") + "</option>");
                        }
                      } catch (SQLException e) {
                        out.println("<option>error</option>");                      
                      }                      
                    %>
                  </select>
                </td>
              </tr>
              <tr>
                <td align="right"><a href="advSearch.jsp">advanced</a> 
                <input type="submit" name="search" value="search"/></td>
              </tr>
            </table>
          </td>
        </tr>      
      </table>
      <!-- 
        for some reason hitting enter in the search box doesn't send the value of the
        submit button as the other forms...login for example on this page... this hack
        makes sure it gets that value
      -->                            
      <input type="hidden" value="search" name="search"/>
      </form>
      <p>

      <!-- now the cateogory list -->
      <table class="outlineTable" width="100%">
        <tr>
          <td class="outlineCell">
            <table class="innerTable">
              <tr><td><strong>Browse Categories:</strong></td></tr>
              <tr><td class="outlineCell"></td></tr>
              <tr><td>
                <%
                  try {
                    Statement st = conn.createStatement();
                    ResultSet rs = st.executeQuery("SELECT category " +
                                                   "FROM category " +
                                                   "ORDER BY category");
                    while (rs.next()) {
                      out.println("<a href='index.jsp?category=" +
                                  rs.getString("category") + "'>" +
                                  rs.getString("category") + "<br/>");
                    }
                  } catch (SQLException e) {
                    out.println("error");                      
                  }                      
                %>
              </tr>
            </table>
          </td>
        </tr>      
      </table>
    </td>

  </tr>
</table>

</body>
</html>