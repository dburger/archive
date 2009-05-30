#!/usr/bin/python
#                             -*- Mode: Python -*- 
#  LispExtensions.py -- 
#  Author          : David J. Burger & Bruce Harris
#  Created On      : Wed May  7 09:13:13 2003
#  Last Modified By: David J. Burger
#  Last Modified On: Sat May 10 15:15:18 2003
#  RCS: $Id$
# 
#  Copyright (c) 2003 David J. Burger & Bruce Harris
# 
# Extends Python with Classes and Functions with Lisp like capabilities

import sys

class LispReader:
    "Implementation of a Lisp reader."
   
    # lexing constants
    __STRING_CODE = 0
    __SYMBOL_CODE = 1
    __NUMBER_CODE = 2
    __LEFT_PAREN_CODE = 3
    __RIGHT_PAREN_CODE = 4
    __SINGLE_QUOTE_CODE = 5
    __POUND_QUOTE_CODE = 6
    
    # these two also used to pass status back to client
    SYNTAX_ERROR = 7
    END_OF_INPUT = 8

    def __init__(self, file):
        """Initializes the reader with the file handle to read from.

        FILE is the file handle to read from
        """
        self.__file = file
        self.__lexeme = ""
        self.__nextToken = LispReader.SYNTAX_ERROR
        self.__nextChar = self.__file.read(1)
        self.__lex()

    def read(self):
        "Reads the next form from the file."
        return self.__form()

    def __getChar(self):
        "Reads the next character from the file."
        self.__nextChar = self.__file.read(1)
        
    def __addChar(self):
        "Appends __nextChar to the end of __lexeme."
        self.__lexeme = self.__lexeme + self.__nextChar

    def __lex(self):
        "Lexes the next lexeme and assigns the token code."
        self.__nextToken = LispReader.SYNTAX_ERROR
        self.__lexeme = ""

        # loop that consumes whitespace and comments before the next lexeme
        while self.__nextChar != "" and self.__nextChar.isspace() or \
                  self.__nextChar == ";":
            if self.__nextChar == ";":
                while self.__nextChar != "" and self.__nextChar != "\n":
                    self.__getChar()
                self.__getChar()
            else:
                self.__getChar()

        # check to see if reached the end of the file with no next lexeme
        if self.__nextChar == "":
            self.__nextToken = LispReader.END_OF_INPUT
        elif self.__nextChar == "(":
            self.__addChar()
            self.__nextToken = LispReader.__LEFT_PAREN_CODE
            self.__getChar()
        elif self.__nextChar == ")":
            self.__addChar()
            self.__nextToken = LispReader.__RIGHT_PAREN_CODE
            self.__getChar()
        elif self.__nextChar == "'":
            self.__addChar()
            self.__nextToken = LispReader.__SINGLE_QUOTE_CODE
            self.__getChar()
        elif self.__nextChar == "#":
            self.__addChar()
            self.__getChar()
            if self.__nextChar == "'":
                self.__addChar()
                self.__nextToken = LispReader.__POUND_QUOTE_CODE
                self.__getChar()
            # else leave self.__nextToken == LispReader.SYNTAX_ERROR
        elif self.__nextChar == "\"":
            # look for the end of the quoted string
            prevChar = "\\"
            while self.__nextChar != "":
                if self.__nextChar == "\"" and prevChar != "\\":
                    self.__addChar()
                    self.__getChar()
                    self.__nextToken = LispReader.__STRING_CODE
                    break
                self.__addChar()
                prevChar = self.__nextChar
                self.__getChar()
        elif isSymbolChar(self.__nextChar):
            if self.__nextChar.isdigit():
                self.__nextToken = LispReader.__NUMBER_CODE
            else:
                self.__nextToken = LispReader.__SYMBOL_CODE
            # look for the end of the symbol
            while isSymbolChar(self.__nextChar):
                if not self.__nextChar.isdigit():
                    self.__nextToken = LispReader.__SYMBOL_CODE
                self.__addChar()
                self.__getChar()
        # else leave self.__nextToken == LispReader.SYNTAX_ERROR

    def __form(self):
        "Reads and returns the next form from the file."
        if self.__nextToken == LispReader.SYNTAX_ERROR:
            return LispReader.SYNTAX_ERROR
        elif self.__nextToken == LispReader.END_OF_INPUT:
            return LispReader.END_OF_INPUT
        elif self.__nextToken == LispReader.__STRING_CODE or \
                 self.__nextToken == LispReader.__SYMBOL_CODE or \
                 self.__nextToken == LispReader.__NUMBER_CODE:
            current_lexeme = self.__lexeme
            self.__lex()
            return current_lexeme
        elif self.__nextToken == LispReader.__SINGLE_QUOTE_CODE or \
                 self.__nextToken == LispReader.__POUND_QUOTE_CODE:
            new_list = []
            if self.__nextToken == LispReader.__SINGLE_QUOTE_CODE:
                new_list.append("quote")
            else:
                new_list.append("function")
            self.__lex()
            new_list.append(self.__form())
            return new_list
        elif self.__nextToken == LispReader.__LEFT_PAREN_CODE:
            # loop to the end of list, appending forms
            self.__lex()
            new_list = []
            while self.__nextToken != LispReader.__RIGHT_PAREN_CODE:
                if self.__nextToken == LispReader.SYNTAX_ERROR or \
                       self.__nextToken == LispReader.END_OF_INPUT:
                    # end of list not found
                    return LispReader.SYNTAX_ERROR
                elif self.__nextToken == LispReader.__STRING_CODE or \
                         self.__nextToken == LispReader.__SYMBOL_CODE or \
                         self.__nextToken == LispReader.__NUMBER_CODE:
                    new_list.append(self.__lexeme)
                    self.__lex()
                elif self.__nextToken == LispReader.__SINGLE_QUOTE_CODE or \
                         self.__nextToken == LispReader.__POUND_QUOTE_CODE:
                    quote_list = []
                    if self.__nextToken == LispReader.__SINGLE_QUOTE_CODE:
                        quote_list.append("quote")
                    else:
                        quote_list.append("function")
                    self.__lex()
                    # recursive call to append nested form
                    quote_list.append(self.__form())
                    new_list.append(quote_list)
                elif self.__nextToken == LispReader.__LEFT_PAREN_CODE:
                    # recursive call to append nested form
                    new_list.append(self.__form())
            self.__lex()
            return new_list
        else:
            return LispReader.SYNTAX_ERROR

    def lexAll(self):
        """Demonstration loop that lexes and prints every lexeme in the file.

        Used for extra credit 1
        """
        while self.__lexeme != "":
            print self.__lexeme
            self.__lex()

# helper functions that work like functions available in Lisp

def pushNew(element, list):
    """Places element at the head of list if not already in list.

    ELEMENT is the element to add to the list
    LIST is the list to add to
    """
    if element not in list:
        list.insert(0, element)

def isList(form):
    """Determines is form is a list.

    FORM is object to determine if a list
    returns 1 if form is a list, otherwise 0
    """
    return type(form) == list or form == "nil"

def isSymbolChar(c):
    """Determines if c is a symbol character for Lisp symbols.

    C is the character to check
    returns 1 if c is a symbol character, otherwise 0
    """
    return c.isalnum() or \
           c in ["+","-","*","/","@","$","%","^","&",
                 "_","\\","<",">","~",".","=",":"]

def isString(form):
    """Determines if form is a string.

    FORM is anything
    returns 1 if form is a string, otherwise 0
    """
    return type(form) == str and form[0] == "\""

def isInteger(form):
    """Determines if form is an integer.

    FORM is anything
    returns 1 if form is an integer, otherwise 0
    """
    # ok, so actually need to check all characters as digits
    return type(form) == str and form[0].isdigit()

def isSymbol(form):
    """Determines if form is a symbol.

    FORM is anything
    returns 1 if form is a symbol, otherwise 0
    """
    return type(form) == str and form[0].isalpha()

# functions used to demonstrate the code

def demo():
    "Demo entry point, parses command line and calls sub-demo."
    if len(sys.argv) != 3:
        print "Proper usage is %s file demo" % sys.argv[0]
        print "where file is the file to process,"
        print "and demo is \"lex\" or \"read\""
        sys.exit(1)
    try:
        demo_file = file(sys.argv[1], "r")
    except IOError:
        print "Unable to open %s" % sys.argv[1]
        sys.exit(1)
    if sys.argv[2] == "lex":
        lexDemo(demo_file)
    elif sys.argv[2] == "read":
        readDemo(demo_file)
    else:
        print "Demo option %s not understood" % sys.argv[2]
    demo_file.close()
    
def lexDemo(lex_file):
    """Demonstrates the lexer by printing out every token in the file.
    
    LEX_FILE is the file to fully lex
    """
    lispReader = LispReader(lex_file)
    lispReader.lexAll()

def readDemo(read_file):
    """Demonstrates the reader by printing out every form in the file.
    
    READ_FILE is the file to fully read.
    """
    lispReader = LispReader(read_file)
    form = lispReader.read()
    while form != LispReader.SYNTAX_ERROR and form != LispReader.END_OF_INPUT:
        print form
        print "=============================================================="
        form = lispReader.read()
    if form == LispReader.SYNTAX_ERROR:
        print "A syntax error occurred!"
    else:
        print "End of Input."

def unitTest():
    "Tests the integrity of the reader, file pmj-xref.el must be present."
    try:
        unitTestFile = file("pmj-xref.el", "r")
    except IOError:
        print "Unable to open pmj-xref.el"
        return 0
    lispReader = LispReader(unitTestFile)
    form = lispReader.read()
    while form != LispReader.SYNTAX_ERROR and form != LispReader.END_OF_INPUT:
        # loop for the last defun
        if form[1] == "pmj-xref-unit-test": break
        form = lispReader.read()
        
    unitTestFile.close()
    
    if form == LispReader.SYNTAX_ERROR or form == LispReader.END_OF_INPUT:
        print "The last defun, 'pmj-xref-unit-test', was not found."
        return 0
    else:
        print "checking that the third item is a list"
        if not isList(form[2]):
            print "failure"
            return 0
        else:
            print "check"

        print "checking that the sixth item is an and"
        if not isList(form[5]) or form[5][0] != "and":
            print "failure"
            return 0
        else:
            print "check"

        print "checking that the third item of the and is an equal"
        if not isList(form[5][2]) or form[5][2][0] != "equal":
            print "failure"
            return 0
        else:
            print "check"

        return 1

# can uncomment the demo or unitTest
if __name__ == "__main__": demo()
# if __name__ == "__main__": print unitTest()
