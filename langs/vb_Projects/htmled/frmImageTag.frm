VERSION 5.00
Begin VB.Form frmImageTag 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Image Tag Builder"
   ClientHeight    =   1830
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4560
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1830
   ScaleWidth      =   4560
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox txtAltText 
      Height          =   315
      Left            =   600
      TabIndex        =   7
      Top             =   1320
      Width           =   2505
   End
   Begin VB.TextBox txtWidth 
      Height          =   315
      Left            =   600
      TabIndex        =   3
      Top             =   480
      Width           =   2505
   End
   Begin VB.TextBox txtHeight 
      Height          =   315
      Left            =   600
      TabIndex        =   5
      Top             =   900
      Width           =   2505
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   525
      Left            =   3270
      TabIndex        =   9
      Top             =   660
      Width           =   1245
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   525
      Left            =   3270
      TabIndex        =   8
      Top             =   60
      Width           =   1245
   End
   Begin VB.TextBox txtPath 
      Height          =   315
      Left            =   600
      TabIndex        =   1
      Top             =   60
      Width           =   2505
   End
   Begin VB.Label lblAltText 
      Caption         =   "&Alt Text:"
      Height          =   525
      Left            =   60
      TabIndex        =   6
      Top             =   1320
      Width           =   525
   End
   Begin VB.Label lblWidth 
      Caption         =   "&Width"
      Height          =   315
      Left            =   60
      TabIndex        =   2
      Top             =   480
      Width           =   525
   End
   Begin VB.Label lblHeight 
      Caption         =   "&Height:"
      Height          =   315
      Left            =   60
      TabIndex        =   4
      Top             =   900
      Width           =   525
   End
   Begin VB.Label lblPath 
      Caption         =   "&Path:"
      Height          =   315
      Left            =   60
      TabIndex        =   0
      Top             =   60
      Width           =   525
   End
End
Attribute VB_Name = "frmImageTag"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private msImageTagHTML As String
Public Function ShowfrmImageTag(frmParent As Form) As String
  Me.Show vbModal, frmParent
  ShowfrmImageTag = msImageTagHTML
  Unload Me
End Function
Private Sub cmdCancel_Click()
  Me.Hide
End Sub
Private Sub cmdOK_Click()
  msImageTagHTML = "<img src='" & txtPath.Text & "'"
  If Len(txtHeight.Text) > 0 Then
    msImageTagHTML = msImageTagHTML & " height='" & txtHeight.Text & "'"
  End If
  If Len(txtWidth.Text) > 0 Then
    msImageTagHTML = msImageTagHTML & " width='" & txtWidth.Text & "'"
  End If
  If Len(txtAltText.Text) > 0 Then
    msImageTagHTML = msImageTagHTML & " alt='" & txtAltText.Text & "'"
  End If
  msImageTagHTML = msImageTagHTML & ">"
  Me.Hide
End Sub
