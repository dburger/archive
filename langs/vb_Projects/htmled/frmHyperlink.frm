VERSION 5.00
Begin VB.Form frmHyperlink 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Hyperlink Builder"
   ClientHeight    =   1230
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3780
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1230
   ScaleWidth      =   3780
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "Cancel"
      Height          =   525
      Left            =   2430
      TabIndex        =   3
      Top             =   630
      Width           =   1245
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   525
      Left            =   990
      TabIndex        =   2
      Top             =   630
      Width           =   1245
   End
   Begin VB.TextBox txtHyperlinkTo 
      Height          =   315
      Left            =   1170
      TabIndex        =   0
      Top             =   120
      Width           =   2505
   End
   Begin VB.Label lblHyperlinkTo 
      Caption         =   "&Hyperlink to:"
      Height          =   315
      Left            =   90
      TabIndex        =   1
      Top             =   120
      Width           =   1035
   End
End
Attribute VB_Name = "frmHyperlink"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private msHyperlinkHTML As String
Private msSelection As String
Public Function ShowfrmHyperlink(frmParent As Form, sSelection As String) As String
  msSelection = sSelection
  Me.Show vbModal, frmParent
  ShowfrmHyperlink = msHyperlinkHTML
  Unload Me
End Function
Private Sub cmdCancel_Click()
  Me.Hide
End Sub
Private Sub cmdOK_Click()
  msHyperlinkHTML = "<a href='" & txtHyperlinkTo.Text & "'>" & msSelection & "</a>"
  Me.Hide
End Sub

