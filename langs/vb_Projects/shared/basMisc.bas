Attribute VB_Name = "basMiscRoutines"
Option Explicit
Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Private Const SW_SHOWNORMAL = 1
'Public Function GetOrderedIndexMapping(lElements As Long) As Long()
'  Dim lLoop As Long
'  ReDim al(1 To lElements) As Long
'  For lLoop = 1 To lElements
'    al(lLoop) = lLoop
'  Next lLoop
'  GetOrderedIndexMapping = al
'End Function
'Public Function GetRandomIndexMapping(lElements As Long) As Long()
'  'this function returns an array in which the indices are mapped
'  'to a random ordering of the indices
'  Dim lLoop As Long
'  Dim lTemp As Long
'  Dim lRandomPos As Long
'  Dim al() As Long
'  al = GetOrderedIndexMapping(lElements)
'  Randomize
'  For lLoop = 1 To (lElements - 1)
'    lRandomPos = Int((lElements - lLoop + 1) * Rnd + lLoop)
'    lTemp = al(lLoop)
'    al(lLoop) = al(lRandomPos)
'    al(lRandomPos) = lTemp
'  Next lLoop
'  GetRandomIndexMapping = al
'End Function
Public Sub LaunchAppByAssociation(hwnd As Long, sFilePath As String, sParameters As String)
  'will launch a file file it's file association
  Dim lRet As Long
  lRet = ShellExecute(hwnd, vbNullString, sFilePath, sParameters, vbNullString, SW_SHOWNORMAL)
End Sub
Public Function dbGetObject(sClassName As String) As Object
  'this function will automatically either return the running instance,
  'or start an instance and return that if one is not running
  On Error GoTo AppNotRunning
  Set dbGetObject = GetObject(, Class:=sClassName)
  On Error GoTo 0
  Exit Function
AppNotRunning:
  Set dbGetObject = CreateObject(sClassName)
End Function
Public Function StrToField(sValue As String) As Variant
  If Len(sValue) = 0 Then
    StrToField = Null
  Else
    StrToField = sValue
  End If
End Function
'the following hasn't been working
'so I have been using the Format$
'function instead
'Public Function FieldToStr(fField As Field) As String
'  If fField = Null Then
'    FieldToStr = ""
'  Else
'    FieldToStr = fField
'  End If
'End Function
Public Function ExtractFromDelimitedList(sList As String, nIndex As Integer, sSeperator As String) As String
  'this function accepts a delimited list of values seperated
  'by sSeperator and returns the nIndex item
  'the is a ZERO BASED FUNCTION
  Dim astr() As String
  astr = Split(sList, sSeperator)
  ExtractFromDelimitedList = astr(nIndex)
End Function
Public Function DaysInMonth(dt As Date) As Integer
  Dim nMonth As Integer
  Dim nYear As Integer
  nMonth = Month(dt)
  Select Case nMonth
    Case 1, 3, 5, 7, 8, 10, 12
      DaysInMonth = 31
    Case 4, 6, 9, 11
      DaysInMonth = 30
    Case 2
      nYear = Year(dt)
      If nYear Mod 4 = 0 Then
        DaysInMonth = 29
      Else
        DaysInMonth = 28
      End If
  End Select
End Function
Public Function IsInteger(vData As Variant) As Boolean
  Dim nTest As Integer
  On Error GoTo ErrorTrap
  nTest = CInt(vData)
  IsInteger = True
  Exit Function
ErrorTrap:
  IsInteger = False
End Function
Public Function IsCurrency(vData As Variant) As Boolean
  Dim cTest As Currency
  On Error GoTo ErrorTrap
  cTest = CCur(vData)
  IsCurrency = True
  Exit Function
ErrorTrap:
  IsCurrency = False
End Function
Public Function IsLong(vData As Variant) As Boolean
  Dim lTest As Long
  On Error GoTo ErrorTrap
  lTest = CLng(vData)
  IsLong = True
  Exit Function
ErrorTrap:
  IsLong = False
End Function
Public Function IsByte(vData As Variant) As Boolean
  Dim bTest As Byte
  On Error GoTo ErrorTrap
  bTest = CByte(vData)
  IsByte = True
  Exit Function
ErrorTrap:
  IsByte = False
End Function
Public Function IsSingle(vData As Variant) As Boolean
  Dim fTest As Single
  On Error GoTo ErrorTrap
  fTest = CSng(vData)
  IsSingle = True
  Exit Function
ErrorTrap:
  IsSingle = False
End Function
Public Function ExtractRowFromDataString(sDataString As String, sKey As String) As String()
  'originally this routine was written to parse data from
  'a vsFlexGrids ColComboList property that is written in
  'the form:
  
  '#key;data;data;data|#key;data;data;data
  
  'where key would be the PrimaryKey ID of the row and | seperate rows
  'and ; seperate fields
  
  'since this routine made it handy to retreive any of the values that
  'were displayed in the ColComboList based upon the Key I decided to
  'start using it in other ways such as data stuck in a .Tag property
  
  'it will return the row in an array of strings that matches the key
  'passed in in sKey
  
  'the array of strings returned will be zero based with astr(0) = the key
  
  Dim nLoop As Integer
  Dim sProductID As String
  Dim sTemp As String
  Dim nSemicolonPos As Integer
  Dim astr() As String
  astr = Split(sDataString, "|")
    For nLoop = 0 To UBound(astr)
      'find the ;
      nSemicolonPos = InStr(1, astr(nLoop), ";")
      'skip the # sign and get the key
      sTemp = VBA.Mid$(astr(nLoop), 2, nSemicolonPos - 2)
      If sTemp = sKey Then
        'get the rest of the string
        sTemp = VBA.Mid$(astr(nLoop), nSemicolonPos + 1)
        'split it
        astr = Split(sTemp, vbTab)
        'return the column they wanted
        ExtractRowFromDataString = astr
        Exit Function
      End If
    Next nLoop
End Function
Public Function YesNo(bValue As Boolean) As String
  If bValue Then
    YesNo = "Yes"
  Else
    YesNo = "No"
  End If
End Function
