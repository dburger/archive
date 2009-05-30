REBOL [
	Title:	"Check Mail Routine"
	Author: "David Burger"
	Email:	dburger@aloha.net
	Date:	12-Jul-1999
	
	Purpose: {
		The purpose of this script is to keep checking my email.
	}
] 

nMessageCount: 1

sUserName: ask "Username?"
sPassword: ask/hide "Password?"
loop 1200 [

  messages: read join pop:// [sUserName ":" sPassword "@mail.aloha.net"]

  foreach message messages [
    print "Received " nMessageCount
    nMessageCount: nMessageCount + 1
  ]
  print "No new messages"
  wait 00:00:30
]