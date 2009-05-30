#!/usr/bin/python
#                             -*- Mode: Python -*- 
#  XrefDb.py -- 
#  Author          : David J. Burger & Bruce Harris
#  Created On      : Wed May  7 09:16:23 2003
#  Last Modified By: David J. Burger
#  Last Modified On: Thu May  8 17:56:58 2003
#  RCS: $Id$
# 
#  Copyright (c) 2003 David J. Burger
# 
#  A database for code cross referencing systems.

from LispExtensions import pushNew

class XrefInfo:
    "Data structure for representing function in the cross reference database"
    
    def __init__(self, filename, caller):
        """Initializes the XrefInfo with given filename and caller.

        FILENAME is the filename in which the function is defined
        CALLER is a caller of the function
        """
        self.__filename = filename
        self.__callers = []
        if caller != None: self.__callers.append(caller)
            
    def setDefiningFile(self, filename):
        """Sets the defining file.

        FILENAME is the new defining file
        """
        self.__filename = filename

    def getDefiningFile(self):
        "Returns the defining file."
        return self.__filename
        
    def addCaller(self, caller):
        """Adds the given caller to the list of callers.

        CALLER is a caller to add.
        """
        pushNew(caller, self.__callers)

    def getCallers(self):
        "Returns the list of callers."
        return self.__callers

class XrefDb:
    "Provides a database to hold cross referencing information."

    def __init__(self):
        "Creates the dictionary used to store the cross reference data."
        self.__database = {}

    def registerFunction(self, function, filename):
        """Registers the given function in the database.

        FUNCTION is the name of the function to register
        FILENAME is the name of the file the function is defined in
        """
        if self.__database.has_key(function):
            entry = self.__database[function]
            entry.setDefiningFile(filename)
        else:
            entry = XrefInfo(filename, None)
            self.__database[function] = entry

    def registerCaller(self, function, caller):
        """Registers the given caller as a caller of the given function

        FUNCTION is the name of the function being called
        CALLER is a name of the function calling function
        """
        if self.__database.has_key(function):
            entry = self.__database[function]
            entry.addCaller(caller)
        else:
            entry = XrefInfo(None, caller)
            self.__database[function] = entry

    def getDefiningFile(self, function):
        """Returns the name of the defining file for function.

        FUNCTION is the name of the function to return the defining file for
        returns the defining file or None if function not present/not defined
        """
        if self.__database.has_key(function):
            entry = self.__database[function]
            return entry.getDefiningFile()
        else:
            return None

    def getCallers(self, function):
        """Returns the list of callers of the given function.

        FUNCTION is the name of the function to return the list of callers for
        returns the list of callers or None if not present/no callers defined
        """
        if self.__database.has_key(function):
            entry = self.__database[function]
            return entry.getCallers()
        else:
            return None

    def getDbString(self, filter):
        """Returns a string representation of the contents in the database.

        FILTER set to true to filter those without a defining file
        returns the database string
        """
        result = "%-30s%-30s%-25s\n" % ("Function", "Defined in", "Called by")
        for function in self.__database.iterkeys():
            entry = self.__database[function]
            filename = entry.getDefiningFile()
            callers = entry.getCallers()
            if filter and not filename: continue
            result = result + "%-30s%-30s%-25s\n" % (function, filename, callers)
        return result

    def clearDb(self):
        "Clears all entries in the database"
        self.__database.clear()

def unitTest():
    """Performs unit testing for this module.

    returns 1 if successful, 0 otherwise
    """
    print "Creating an XrefDb"
    xrefDb= XrefDb()
    
    print "Registering function 'foo' called in 'test.el'"
    xrefDb.registerFunction("foo", "test.el")
    print "Registering 'aoo', 'boo', 'coo' as callers of 'foo'"
    xrefDb.registerCaller("foo", "aoo")
    xrefDb.registerCaller("foo", "boo")
    xrefDb.registerCaller("foo", "coo")
    
    print "Registering function 'doo' called in None"
    xrefDb.registerFunction("doo", None)
    print "Registering 'eoo', 'foo', 'goo' as callers of 'doo'"
    xrefDb.registerCaller("doo", "eoo")
    xrefDb.registerCaller("doo", "foo")
    xrefDb.registerCaller("doo", "goo")

    print "Now checking for database consistency..."
    
    print "Defining file for 'foo' should be 'test.el'"
    if xrefDb.getDefiningFile("foo") != "test.el":
        print "failure"
        return 0
    else:
        print "check"

    print "Callers of 'foo' should be ['coo', 'boo', 'aoo']"
    if xrefDb.getCallers("foo") != ['coo', 'boo', 'aoo']:
        print "failure"
        return 0
    else:
        print "check"

    print "Defining file for 'doo' should be None"
    if xrefDb.getDefiningFile("doo") != None:
        print "failure"
        return 0
    else:
        print "check"

    print "Callers of 'doo' should be ['goo', 'foo', 'eoo']"
    if xrefDb.getCallers("doo") != ['goo', 'foo', 'eoo']:
        print "failure"
        return 0
    else:
        print "check"

    print "Defining file of 'notHere' should be None"
    if xrefDb.getDefiningFile("notHere") != None:
        print "failure"
        return 0
    else:
        print "check"

    print "Callers of 'notHere' should be None"
    if xrefDb.getCallers("notHere") != None:
        print "failure"
        return 0
    else:
        print "check"

    # success
    return 1
    
if __name__ == "__main__": print unitTest()
