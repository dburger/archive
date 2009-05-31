VERSION 5.00
Begin VB.Form frmFind 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Find"
   ClientHeight    =   2040
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3735
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2040
   ScaleWidth      =   3735
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   2040
      TabIndex        =   7
      Top             =   1440
      Width           =   1215
   End
   Begin VB.CommandButton cmdFind 
      Caption         =   "&Find"
      Default         =   -1  'True
      Height          =   495
      Left            =   360
      TabIndex        =   6
      Top             =   1440
      Width           =   1215
   End
   Begin VB.TextBox txtText 
      Height          =   375
      Left            =   1440
      TabIndex        =   5
      Top             =   840
      Width           =   2175
   End
   Begin VB.ComboBox cboComparison 
      Height          =   315
      Left            =   1440
      TabIndex        =   3
      Top             =   480
      Width           =   2175
   End
   Begin VB.ComboBox cboField 
      Height          =   315
      Left            =   1440
      TabIndex        =   0
      Top             =   120
      Width           =   2175
   End
   Begin VB.Label lblText 
      Caption         =   "&Text:"
      Height          =   255
      Left            =   120
      TabIndex        =   4
      Top             =   840
      Width           =   1335
   End
   Begin VB.Label lblComparison 
      Caption         =   "&Comparison:"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   1335
   End
   Begin VB.Label lblField 
      Caption         =   "&Field:"
      Height          =   255
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   615
   End
End
Attribute VB_Name = "frmFind"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mRS As Recordset
Private mnModalResult As VbMsgBoxResult
Public Function ShowFind(rs As Recordset) As Recordset
  Dim fld As Field
  Dim sSQL As String
  Dim sWhereClause As String
  Dim rsNew As Recordset
  Set mRS = rs
  For Each fld In mRS.Fields
    cboField.AddItem fld.Name
  Next fld
  cboComparison.AddItem "equals"
  cboComparison.AddItem "starts with"
  cboComparison.AddItem "contains"
  cboComparison.ListIndex = 0
  Me.Show vbModal
  If mnModalResult = vbOK Then
    Set rsNew = mRS
    Select Case cboComparison.Text
      Case "equals"
        rsNew.Filter = cboField.Text & " = '" & txtText.Text & "'"
      Case "starts with"
      
      Case "contains"
      
    End Select
  End If
  Set ShowFind = rsNew
  Unload Me
End Function
Private Sub cmdCancel_Click()
  mnModalResult = vbCancel
  Me.Hide
End Sub
Private Sub cmdFind_Click()
  mnModalResult = vbOK
  Me.Hide
End Sub
Private Function GetFieldList(rs As Recordset) As String
  Dim sTemp As String
  Dim fld As Field
  For Each fld In rs.Fields
    sTemp = sTemp & "[" & fld.Name & "], "
  Next fld
  GetFieldList = Left$(sTemp, Len(sTemp) - 2)
End Function
