VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsPaymentTypes"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Public Function GetPaymentList(con As Connection) As String
  Dim sTemp As String
  Dim rs As Recordset
  Set rs = New Recordset
  rs.Open "select PaymentTypeID, Type from PaymentTypes", con, adOpenForwardOnly, adLockPessimistic
  Do Until rs.EOF
    sTemp = sTemp & "#" & CStr(rs!PaymentTypeID) & ";" & rs!Type & "|"
    rs.MoveNext
  Loop
  'if there is no PaymentList then this would throw error without the check
  If Len(sTemp) Then GetPaymentList = VBA.Left$(sTemp, Len(sTemp) - 1)
End Function
