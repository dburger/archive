VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   510
      Left            =   225
      TabIndex        =   0
      Top             =   180
      Width           =   1185
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub Command1_Click()
  Dim obj As htmlReport.clsReport
  Set obj = New htmlReport.clsReport
  obj.BodyHTML = "<h2>dakine</h2>"
  obj.AppendHTML "<hr color='ffccoo'>"
  obj.BGColor = "#ffeeff"
  obj.ShowReport
End Sub
