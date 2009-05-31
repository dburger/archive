#!/usr/bin/perl -Tw

# the T refuses to run code with tainted input
# the w warns about potential problems, would take out for production

# note, Perl will do a lot of the stuff I am doing manually for you
# however, I am just going to use it to help with the retreival of
# posted data

use CGI;
use DBI;

my $table = "visitors";
my $db = "web_data";
my $user = "root";
my $password = "Rockets1";

$q = new CGI;
$txtName = $q->param('txtName');

print "Content-type:text/html\n\n";
print "<html>";
print "<head>";
print "<title></title>";
print "</head>";
print "<body bgcolor=\'#aaffee\'>";
print "<h1>Perl Scripting</h1>";

if ($txtName) {
  $txtEmailAddress = $q->param('txtEmailAddress');
  $txtComments = $q->param('txtComments');
  $time = time();


  print "The following data was given and written to formdata.txt on $time.<p>";
  print "Name-> $txtName<br>";
  print "Email-> $txtEmailAddress<br>";
  print "Comments-> $txtComments<p>";

  $table = "visitors";
  $db = "web_data";
  $user = "root";
  $password = "Rockets1";

  $drh = DBI->install_driver("mysql");
  $dbh = $drh->connect($db, $user, $password);

  $sql_statement = "insert into $table (Name, EmailAddress, Comments) values (\"$txtName\", \"$txtEmailAddress\", \"$txtComments\")";
  $sth = $dbh->do($sql_statement);

  $sql_statement = "select VisitorID, Name, EmailAddress, Comments from $table";

  $sth = $dbh->prepare($sql_statement);

  $how_many = $sth->execute;

  print "<table border='1'>";
  for ($nLoop = 1 ; $nLoop < $how_many ; $nLoop++) {
    ($VisitorID, $Name, $EmailAddress, $Comments) = $sth->fetchrow_array;
    print "<tr><td>$VisitorID</td><td>$Name</td><td>$EmailAddress</td><td>$Comments</td></tr>";
  }
  print "</table>";


} else {
  print "<form method='post' action='perlmysql.pl'>";
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










