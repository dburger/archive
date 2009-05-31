<html>
<head>
<title></title>
</head>
<body>

<? if ($txtName<>"") {

     $now = date('M d, Y',time()); 
     echo "<h1>PHP3</h1><p>";
     echo "The following data was given and written to formdata.txt on $now.<p>";
     echo "Name-> $txtName<br>";
     echo "Email Address-> $txtEmailAddress<br>";
     echo "Comments-> $txtComments<br>";

     $fp = fopen("../cgi-bin/formdata.txt", "a");
     $retval = fwrite($fp, "PHP3,$txtName,$txtEmailAddress,$txtComments,$now\n");
 
   } else {

?>

<form method="post" action="php3form.php3">
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
