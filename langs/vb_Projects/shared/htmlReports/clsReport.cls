VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Dim mfrmReport As frmReport
Private Sub Class_Initialize()
  Set mfrmReport = New frmReport
End Sub
Public Property Let BodyHTML(sHTML As String)
  mfrmReport.wbMain.Document.Body.innerhtml = sHTML
End Property
Public Property Get BodyHTML() As String
  BodyHTML = mfrmReport.wbMain.Document.Body.innerhtml
End Property
Public Property Let BGColor(sBGColor As String)
  mfrmReport.wbMain.Document.Body.BGColor = sBGColor
End Property
Public Sub AppendHTML(sHTML As String)
  mfrmReport.wbMain.Document.Body.innerhtml = mfrmReport.wbMain.Document.Body.innerhtml & sHTML
End Sub
Public Sub ShowReport()
  mfrmReport.Show
End Sub
Private Sub Class_Terminate()
  Set mfrmReport = Nothing
End Sub
