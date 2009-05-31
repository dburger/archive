#!/usr/bin/rebol -cs
REBOL [

]

print "Content-type: text/html^/"
print "<html>"
print "<head>"
print "<title></title>"
print "</head>"
print "<body bgcolor=#ffcc00>"
print "<h1>Rebol Scripting</h1>"

posteddata: input

either posteddata [

  posteddata: make object! decode-cgi posteddata
  print ["The following data was given and written to formdata.txt on" now".<p>"]
  print ["Name->" posteddata/txtName"<br>"]
  print ["Email->" posteddata/txtEmailAddress"<br>"]
  print ["Comments->" posteddata/txtComments"<br>"]
  write/append %formdata.txt reduce ["REBOL," posteddata/txtName "," posteddata/txtEmailAddress "," posteddata/txtComments "," now newline]

] [

  print "<form method='post' action='rebolform.r'>"
  print "<table border='1'>"
  print "<tr>"
  print "<td>Name:</td><td><input type='text' name='txtName' size='40'></td>"
  print "</tr>"
  print "<tr>"
  print "<td>Email Address:</td><td><input type='text' name='txtEmailAddress' size='40'></td>"
  print "</tr>"
  print "<tr>"
  print "<td>Comment:</td><td><textarea name='txtComments' rows='15' cols='40'></textarea></td>"
  print "</tr>"
  print "<tr>"
  print "<td>&nbsp</td><td><input type='submit' name='cmdSubmit' value='Submit'></td>"
  print "</tr>"
  print "</table>"
  print "</form>"

]

print "</body>"
print "</html>"
