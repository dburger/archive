Attribute VB_Name = "basAPIHelpers"
Option Explicit
Public Function APIToVBStr(sAPIString As String) As String
  'the API function return strings with a Null character chr$(0)
  'indicating the end of the string
  APIToVBStr = VBA.Left$(sAPIString, InStr(sAPIString, vbNullChar) - 1)
End Function
Public Function VBToAPIStr(sVBString As String, nLength As Integer)
  'some API function require padded strings, in this routine
  'we pad to nLenght will Null characters
  VBToAPIStr = sVBString & VBA.String(nLength - Len(sVBString), vbNullChar)
End Function
