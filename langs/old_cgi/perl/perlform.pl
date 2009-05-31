#!/usr/bin/perl -Tw

# the T refuses to run code with tainted input
# the w warns about potential problems, would take out for production

# note, Perl will do a lot of the stuff I am doing manually for you
# however, I am just going to use it to help with the retreival of
# posted data

use CGI;
$q = new CGI;

$txtName = $q->param('txtName');

print<<HTMLSTART;
Content-type:text/html

<html>
<head>
<title></title>
</head>
<body bgcolor=\'#aaffee\'>
<h1>Perl Scripting</h1>
HTMLSTART
if ($txtName) {
  $txtEmailAddress = $q->param('txtEmailAddress');
  $txtComments = $q->param('txtComments');
  $time = time();
  print "The following data was given and written to formdata.txt on $time.<p>";
  print "Name-> $txtName<br>";
  print "Email-> $txtEmailAddress<br>";
  print "Comments-> $txtComments<br>";
  # no error handling on fileop
  open(fp, ">>formdata.txt");
  print fp "\nPerl,$txtName,$txtEmailAddress,$txtComments,$time";
  close(fp);
} else {
  print "<form method='post' action='perlform.pl'>";
  print "<table border='1'>";
  print "<tr>";
  print "<td>Name:</td><td><input type='text' name='txtName' size='40'></td>";
  print "</tr>";
  print "<tr>";
  print "<td>Email Address:</td><td><input type='text' name='txtEmailAddress' size='40'></td>";
  print "</tr>";
  print "<tr>";
  print "<td>Comment:</td><td><textarea name='txtComments' rows='15' cols='40'></textarea></td>";
  print "</tr>";
  print "<tr>";
  print "<td>&nbsp</td><td><input type='submit' name='cmdSubmit' value='Submit'></td>";
  print "</tr>";
  print "</table>";
  print "</form>";
}
print<<HTMLEND;
</body>
</html>
HTMLEND
