#!/usr/bin/python

import commands, dbm, os, string, sys

if len(sys.argv) != 3: sys.exit("Usage is %s links dbm\n" % sys.argv[0])

linkFilename, dbmFilename = sys.argv[1:]

linkFile = open(linkFilename)
urls = linkFile.readlines()
linkFile.close()

urls = [url.rstrip() for url in urls]

message = ""

dbmFile = dbm.open(dbmFilename, "c")

for url in urls:
 newhash = commands.getoutput("curl -fs %s | md5sum" % url)
 oldhash = dbmFile[url]

 if newhash == "d41d8cd98f00b204e9800998ecf84e  -\n":
  message += "%s failed\n" % url
 elif newhash != oldhash:
  message += "%s changed\n" % url

 dbmFile[url] = newhash

dbmFile.close()

if len(message) &gt; 0:
 print message

 pipe = os.popen("mail -s 'page report' someone@email.com -- " + \
   "-F'You Name' --fsomeone@email.com", "w")
 pipe.write(message);
 exitcode = pipe.close()
 if exitcode: print "Exit code: %s" % exitcode
