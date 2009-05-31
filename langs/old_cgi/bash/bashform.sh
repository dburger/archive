#!/bin/sh
. parselibrary.sh

echo "Content-type: text/html"
echo

parseCGI

echo "<html>"
echo "<head>"
echo "<title></title>"
echo "</head>"
echo "<body bgcolor='green'>"
echo "<h1>Bash Scripting</h1>"
if [ "$FORM_txtName" ]; then
  echo "The following data was given and written to formdata.txt on `date`:<p>"
  echo "Name-> "$FORM_txtName"<br>"  
  echo "Email->"$FORM_txtEmailAddress"<br>"
  echo "Comments->"$FORM_txtComments"<br>"
  echo "Bash,"$FORM_txtName","$FORM_txtEmailAddress","$FORM_txtComments",`date`" >> formdata.txt
else
  echo "<form method='post' action='bashform.sh'>"
  echo "<table border='1'>"
  echo "<tr>"
  echo "<td>Name:</td><td><input type='text' name='txtName' size='40'></td>"
  echo "</tr>"
  echo "<tr>"
  echo "<td>Email Address:</td><td><input type='text' name='txtEmailAddress' size='40'></td>"
  echo "</tr>"
  echo "<tr>"
  echo "<td>Comment:</td><td><textarea name='txtComments' rows='15' cols='40'></textarea></td>"
  echo "</tr>"
  echo "<tr>"
  echo "<td>&nbsp</td><td><input type='submit' name='cmdSubmit' value='Submit'></td>"
  echo "</tr>"
  echo "</table>"
  echo "</form>"
fi
echo "</body>"
echo "</html>"
