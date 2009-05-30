#!/usr/bin/python
#                             -*- Mode: Python -*- 
#  LispXrefer.py -- 
#  Author          : David J. Burger & Bruce Harris
#  Created On      : Wed May  7 09:15:13 2003
#  Last Modified By: David J. Burger
#  Last Modified On: Sat May 10 15:15:26 2003
#  RCS: $Id$
# 
#  Copyright (c) 2003 David J. Burger & Bruce Harris
# 
#  A cross referencer for Lisp code.

import sys
from LispExtensions import LispReader, isList, isString, isSymbol, isInteger
from XrefDb import XrefDb

class LispXrefer:
    "Cross referencing application for Lisp code."
    
    def __init__(self):
        "Creates the database used to store cross referencing information."
        self.__xrefDb = XrefDb()

    def xrefFile(self, filename):
        """Cross references the give file.

        FILENAME is the name of the file to cross reference
        returns the number of defuns in the file, or -1 if an error occurred
        """
        try:
            f = file(filename, "r")
        except:
            return -1
        num_defuns = 0
        lispReader = LispReader(f)
        form = lispReader.read()
        while form != LispReader.SYNTAX_ERROR and \
                  form != LispReader.END_OF_INPUT:
            if isList(form) and form[0] == "defun":
                self.__parseDefun(form, filename)
                num_defuns = num_defuns + 1
            form = lispReader.read()
        f.close()        
        if form == LispReader.SYNTAX_ERROR:
            return -1
        return num_defuns

    def __parseDefun(self, form, filename):
        """Parses a defun form, performing cross referencing.

        FORM is the defun form to parse
        FILENAME is the name of the file containing the defun
        """
        functionName = form[1]
        self.__xrefDb.registerFunction(functionName, filename)
        for f in form[3:]: self.__parseForm(f, functionName)

    def __parseForm(self, form, functionName):
        """Parses a form, performing cross referencing.

        FORM is the form to parse
        FUNCTIONNAME is the name of the function containing the form
        """
        if isString(form) or isSymbol(form) or isInteger(form) or \
               form[0] == "quote" or form[0] == "function":
            pass # ignore
        elif form[0] == "cond":
            self.__parseCond(form, functionName)
        elif form[0] == "condition-case":
            self.__parseConditionCase(form, functionName)
        elif form[0] == "dolist":
            self.__parseDoList(form, functionName)
        elif form[0] == "let":
            self.__parseLet(form, functionName)
        else:
            self.__xrefDb.registerCaller(form[0], functionName)
            for f in form[1:]: self.__parseForm(f, functionName)
            
    def __parseCond(self, form, functionName):
        """Parses a cond form, performing cross referencing.

        FORM is the cond form to parse
        FUNCTIONNAME is the name of the function containing the form
        """
        # parse the cond clauses
        for f in form[1:]:
            for g in f: self.__parseForm(g, functionName)

    def __parseConditionCase(self, form, functionName):
        """Parses a condition-case form, performing cross referencing.

        FORM is the condition-case form to parse
        FUNCTIONNAME is the name of the function containing the form
        """
        # parse the body
        self.__parseForm(form[2], functionName)
        # parse the error handlers
        for f in form[3:]:
            for g in f[1:]: self.__parseForm(g, functionName)

    def __parseDoList(self, form, functionName):
        """Parses a dolist form, performing cross referencing.

        FORM is the dolist form to parse
        FUNCTIONNAME is the name of the function containing the form
        """
        # parse the dolist bindings
        for f in form[1][1:]: self.__parseForm(f, functionName)
        # parse the dolist body
        for f in form[2:]: self.__parseForm(f, functionName)

    def __parseLet(self, form, functionName):
        """Parses a let form, performing cross referencing.

        FORM is the let form to parse
        FUNCTIONNAME is the name of the function containing the form
        """
        # parse the let bindings
        for f in form[1]:
            if type(f) == list: self.__parseForm(f[1], functionName)
        # parse the let body
        for f in form[2:]: self.__parseForm(f, functionName)

    def getDefiningFile(self, function):
        """Retrives the defining file for the given function.

        FUNCTION the name of the function to retrieve the defining file for
        returns the name of the defining file or None if function not found
        """
        return self.__xrefDb.getDefiningFile(function)

    def getCallers(self, function):
        """Retrieves a list of the callers of the given function.

        FUNCTION is the name of the function to retrieve list of callers for
        returns the list of callers, possibly None
        """
        return self.__xrefDb.getCallers(function)

    def getDbString(self, filter):
        """Returns a string representation of the contents in the database.

        FILTER set to true to filter those without a defining file
        returns the database string
        """
        return self.__xrefDb.getDbString(filter)

    def clearDb(self):
        "Clears all entries in the database."
        self.__xrefDb.clearDb()

def demo():
    "Used to demonstrate the functionality of the cross referencer."
    if len(sys.argv) != 2:
        print "Proper usage is %s file" % sys.argv[0]
        print "where file is the file to process"
        sys.exit(1)
    lispXrefer = LispXrefer()
    result = lispXrefer.xrefFile(sys.argv[1])
    if result == -1:
        print "An error occurred while parsing %s" % sys.argv[1]
    else:
        print "%d defuns processed from %s" % (result, sys.argv[1])

def unitTest():
    "Tests the cross referencer, pmj-xref.el must be present."
    lispXrefer = LispXrefer()
    result = lispXrefer.xrefFile("pmj-xref.el")
    if result == -1:
        print "An error occurred while parsing pmj-xref.el"
        return 0
    else:
        print "13 defuns should have been parsed."
        if result != 13:
            print "failure, " + result + " parsed"
            return 0
        else:
            print "check"

        print "defining file of 'pmj-xref-parse-let' should be pmj-xref.el"
        if lispXrefer.getDefiningFile("pmj-xref-parse-let") != "pmj-xref.el":
            print "failure"
            return 0
        else:
            print "check"

        print "callers of 'pmj-xref-trace' should be a long list..."
        callers = lispXrefer.getCallers("pmj-xref-trace")
        if "pmj-xref-parse-defun" not in callers or \
           "pmj-xref-parse-form" not in callers or \
           "pmj-xref-parse-let" not in callers or \
           "pmj-xref-parse-cond" not in callers or \
           "pmj-xref-parse-condition-case" not in callers or \
           len(callers) > 5:
            print "failure"
            return 0
        else:
            print "has: "
            print callers
            print "check"

        print "defining file for 'notHere' should be None"
        if lispXrefer.getDefiningFile("notHere") != None:
            print "failure"
            return 0
        else:
            print "check"

        print "callers of 'notHere' should be None"
        if lispXrefer.getCallers("notHere") != None:
            print "failure"
            return 0
        else:
            print "check"

        return 1

def run():
    "Runs the Lisp cross referencing program."

    def printMenu():
        "Presents the cross referencing menu to the user."
        print "0) xref file"
        print "1) print database string"
        print "2) get defining file"
        print "3) get callers"
        print "4) clear database"
        print "5) quit"

    def getSelection():
        "Returns the users menu selection, or -1 if not int."
        try:
            selection = int(raw_input("enter selection: "))
        except ValueError:
            selection = -1
        return selection

    lispXrefer = LispXrefer()

    # process files passed from command line
    for filename in sys.argv[1:]:
        result = lispXrefer.xrefFile(filename)
        if result >= 0:
            print "%d defuns parsed from %s" % (result, filename)
        else:
            print "An error occurred parsing %s" % filename

    print "====================================================="    
    printMenu()
    selection = getSelection()
    while selection != 5:
        if selection == 0:
            filename = raw_input("Enter filename: ")
            result = lispXrefer.xrefFile(filename)
            if result >= 0:
                print "%d defuns parsed" % result
            else:
                print "An error occurred parsing %s" % filename
        elif selection == 1:
            print lispXrefer.getDbString(1),
        elif selection == 2:
            functionName = raw_input("Enter function name: ")
            print "Defining file for %s is %s" % \
                  (functionName, lispXrefer.getDefiningFile(functionName))
        elif selection == 3:
            functionName = raw_input("Enter function name: ")
            print "Callers of %s are %s" % \
                  (functionName, lispXrefer.getCallers(functionName))
        elif selection == 4:
            lispXrefer.clearDb()
        else:
            print "Unknown selection"
        print "====================================================="
        printMenu()
        selection = getSelection()

# if __name__ == "__main__": demo()
# if __name__ == "__main__": print unitTest()
if __name__ == "__main__": run()
