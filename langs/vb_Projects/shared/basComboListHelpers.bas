Attribute VB_Name = "basComboListHelpers"
Option Explicit
Public Type TComboBoxItem
  Item As String
  ItemData As Long
End Type
Private Declare Function SendMessageByString Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByVal lParam As String) As Long
Private Const CB_FINDSTRINGEXACT = &H158
Public Sub ComboFetchByText(cbo As ComboBox, sValue As String)
  'if not found sets ListIndex to -1
  Dim nRet As Integer
  nRet = SendMessageByString(cbo.hwnd, CB_FINDSTRINGEXACT, -1, sValue)
  cbo.ListIndex = nRet
End Sub
Public Sub ComboFetchByItemData(cbo As ComboBox, lItemData As Long)
  'if not found it sets the combo to no selection (-1)
  Dim nCounter As Integer
  For nCounter = 0 To cbo.ListCount - 1
    If cbo.ItemData(nCounter) = lItemData Then
      cbo.ListIndex = nCounter
      Exit Sub
    End If
  Next nCounter
  cbo.ListIndex = -1
End Sub
Public Sub LoadComboFromArray(cbo As ComboBox, ascbo() As String)
  Dim nLoop As Integer
  cbo.Clear
  For nLoop = LBound(ascbo) To UBound(ascbo)
    cbo.AddItem ascbo(nLoop)
    cbo.ItemData(cbo.NewIndex) = nLoop
  Next nLoop
End Sub

'Public Sub LoadComboFromArray(cbo As ComboBox, ascbo() As String)
'  Dim nLoop As Integer
'  cbo.Clear
'  For nLoop = LBound(acbo) To UBound(acbo)
'    cbo.AddItem acbo(nLoop).Item
'    cbo.ItemData(cbo.NewIndex) = acbo(nLoop).ItemData
'  Next nLoop
'End Sub
