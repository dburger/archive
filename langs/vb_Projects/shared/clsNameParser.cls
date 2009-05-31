VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsNameParser"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public Event ParsingError(sName As String)
Public Function ParseName(ByVal sName) As String
  'this function takes a name as in FirstName LastName and
  'converts it to LastName, FirstName
  'if it encounters problems, such as an "Erin Sue Coloma"
  'or "Brooke Dela Cruz" it fires an event
  Dim sParsingErrorName As String
  Dim lSpacePos As Long
  lSpacePos = InStr(1, sName, " ")
  If (lSpacePos > 1) And (InStr(lSpacePos + 1, sName, " ") = 0) Then
    'if has space at position > 0 and only one space
    ParseName = Right$(sName, Len(sName) - lSpacePos) & ", " & Left$(sName, lSpacePos - 1)
  Else
    'raise a parsing error and let the program decide
    sParsingErrorName = sName
    RaiseEvent ParsingError(sParsingErrorName)
    ParseName = sParsingErrorName
  End If
End Function
