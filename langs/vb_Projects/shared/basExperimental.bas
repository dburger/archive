Attribute VB_Name = "basExperimental"
Option Explicit
Public Function CByteStrToLong(sText As String) As Long
  'this function will take a string of 1s and 0s
  'and convert it into a base ten value
  'normally this would be done to convert byte strings
  'into bytes
  Dim lLeftMostValue As Long
  Dim nLoop As Integer
  Dim lTemp As Long
  Dim nCharacters As Integer
  nCharacters = Len(sText)
  lBitValue = 2 ^ (nCharacters - 1)
  For nLoop = 1 To nCharacters
    lTemp = lTemp + CInt(Mid$(sText, nLoop, 1)) * lBitValue
    lBitValue = lBitValue / 2
  Next nLoop
  DBCByte = lTemp
End Function
Public Function GenerateRandCharSequence(nCharacters As Integer) As String
  Dim nLoop As Integer
  Dim nType As Integer
  Dim nASCIIChar As Integer
  Dim nLowerBound As Integer
  Dim nUpperBound As Integer
  Dim sTemp As String
  Randomize
  For nLoop = 1 To nCharacters
    nType = Int((3) * Rnd + 1)
    Select Case nType
      Case 1 'upper case letters
        nUpperBound = 90
        nLowerBound = 65
      Case 2 'lower case letters
        nUpperBound = 122
        nLowerBound = 97
      Case 3 'numbers
        nUpperBound = 57
        nLowerBound = 49
    End Select
    nASCIIChar = Int((nUpperBound - nLowerBound + 1) * Rnd + nLowerBound)
    sTemp = sTemp + Chr$(nASCIIChar)
  Next nLoop
  GenerateRandCharSequence = sTemp
End Function
