<html>
<head>
<title></title>
</head>
<body>

<?
  if ($txtName<>"") {

     $now = date('M d, Y',time()); 
     echo "<h1>PHP3</h1><p>";
     echo "The following data was given and written to formdata.txt on $now.<p>";
     echo "Name-> $txtName<br>";
     echo "Email Address-> $txtEmailAddress<br>";
     echo "Comments-> $txtComments<br>";


     $db = mysql_connect("localhost", "root", "Rockets1");
     mysql_select_db("web_data",$db);

     $sql_statement = "insert into visitors (Name, EmailAddress, Comments) values ('$txtName', '$txtEmailAddress', '$txtComments')";

     $result = mysql_query($sql_statement);

     $sql_statement = "select VisitorID, Name, EmailAddress, Comments from visitors";

     $result = mysql_query($sql_statement);

     if ($myrow = mysql_fetch_array($result)) {

       echo "<p><table border='1'>";

       do {
         // I wanted to do this on on line but the associative array didn't work.
         //within the quotes, and single quotes didn't work
         echo "<tr><td>";
         echo $myrow["VisitorID"];
         echo "</td><td>";
         echo $myrow["Name"];
         echo "</td><td>";
         echo $myrow["EmailAddress"];
         echo "</td><td>";
         echo $myrow["Comments"];
         echo "</td></tr>";
       } while ($myrow = mysql_fetch_array($result));
       echo "</table>";
     }

   } else {

?>

<form method="post" action="php3mysql.php3">
<h1>A Form Handled by PHP3</h1>
<table border="1">
  <tr>
    <td>Name:</td><td><input type="text" name="txtName" size="40"></td>
  </tr>
  <tr>
    <td>Email Address:</td><td><input type="text" name="txtEmailAddress" size="40"></td>
  </tr>
  <tr>
    <td>Comment:</td><td><textarea name="txtComments" rows="15" 
cols="40"></textarea></td>
  </tr>
  <tr>
    <td>&nbsp</td><td><input type="submit" name="cmdSubmit" value="Submit"></td>
  </tr>
</table>
</form>

<? } ?>  

</body>
</html>
