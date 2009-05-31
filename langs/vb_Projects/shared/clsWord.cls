VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsWord"
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private WithEvents mobjWord As Word.Application
Private Sub Class_Initialize()
  On Error GoTo WordNotRunning
  Set mobjWord = GetObject(, Class:="Word.Application")
  On Error GoTo 0
  Exit Sub
WordNotRunning:
  Set mobjWord = New Word.Application
End Sub
Property Get Word() As Word.Application
  'if this could be made the default
  'property this would be great for
  'using when using word to simplify
  'instantiating word
  Set Word = mobjWord
End Property
