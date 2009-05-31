VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsProductList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public Function GetProductList(con As Connection) As String
  Dim sTemp As String
  Dim rs As Recordset
  Set rs = New Recordset
  rs.Open "select ProductListID, Description, UnitPrice from ProductList", con, adOpenForwardOnly, adLockPessimistic
  Do Until rs.EOF
    'throw in the unit price?
    sTemp = sTemp & "#" & CStr(rs!ProductListID) & ";" & rs!Description & vbTab & FormatCurrency(rs!UnitPrice, 2, vbTrue, vbFalse, vbTrue) & "|"
    rs.MoveNext
  Loop
  'if there is no ProductList then this would throw error
  If Len(sTemp) Then GetProductList = VBA.Left$(sTemp, Len(sTemp) - 1)
End Function
