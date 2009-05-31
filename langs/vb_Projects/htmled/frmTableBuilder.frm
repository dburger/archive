VERSION 5.00
Begin VB.Form frmTableBuilder 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Table Builder"
   ClientHeight    =   1245
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4500
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1245
   ScaleWidth      =   4500
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   525
      Left            =   3210
      TabIndex        =   5
      Top             =   60
      Width           =   1245
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   525
      Left            =   3210
      TabIndex        =   4
      Top             =   660
      Width           =   1245
   End
   Begin VB.TextBox txtColumns 
      Height          =   315
      Left            =   600
      TabIndex        =   2
      Top             =   510
      Width           =   2505
   End
   Begin VB.TextBox txtRows 
      Height          =   315
      Left            =   600
      TabIndex        =   0
      Top             =   60
      Width           =   2505
   End
   Begin VB.Label lblColumns 
      Caption         =   "&Columns"
      Height          =   315
      Left            =   60
      TabIndex        =   3
      Top             =   510
      Width           =   525
   End
   Begin VB.Label lblRows 
      Caption         =   "&Rows:"
      Height          =   315
      Left            =   60
      TabIndex        =   1
      Top             =   60
      Width           =   525
   End
End
Attribute VB_Name = "frmTableBuilder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private msTableHTML As String
Public Function ShowfrmTableBuilder(frmParent As Form) As String
  Me.Show vbModal, frmParent
  ShowfrmTableBuilder = msTableHTML
  Unload Me
End Function
Private Sub cmdCancel_Click()
  Me.Hide
End Sub
Private Sub cmdOK_Click()
  Dim nColCounter As Integer
  Dim nColumns As Integer
  Dim nRowCounter As Integer
  Dim nRows As Integer
  nColumns = CInt(txtColumns.Text)
  nRows = CInt(txtRows.Text)
  msTableHTML = "<table>" & vbCrLf
  For nRowCounter = 1 To nRows
    msTableHTML = msTableHTML & "  <tr>" & vbCrLf
    For nColCounter = 1 To nColumns
      msTableHTML = msTableHTML & "    <td>" & vbCrLf
      msTableHTML = msTableHTML & "    </td>" & vbCrLf
    Next nColCounter
    msTableHTML = msTableHTML & "  </tr>" & vbCrLf
  Next nRowCounter
  msTableHTML = msTableHTML & "</table>"
  Me.Hide
End Sub

