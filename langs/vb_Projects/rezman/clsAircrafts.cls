VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsResources"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Function GetRecordset(con As Connection) As Recordset
  Dim sSQL As String
  Dim rs As Recordset
  sSQL = "select * from resources"
  Set rs = New Recordset
  rs.Open sSQL, con, adOpenForwardOnly, adLockReadOnly
  Set GetRecordset = rs
End Function

