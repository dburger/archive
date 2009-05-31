VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmFontBuilder 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Font Builder"
   ClientHeight    =   1185
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4485
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1185
   ScaleWidth      =   4485
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   525
      Left            =   3180
      TabIndex        =   8
      Top             =   600
      Width           =   1245
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   525
      Left            =   3180
      TabIndex        =   7
      Top             =   30
      Width           =   1245
   End
   Begin VB.TextBox txtFontColor 
      Height          =   315
      Left            =   570
      TabIndex        =   5
      Top             =   810
      Width           =   2205
   End
   Begin VB.TextBox txtSize 
      Height          =   315
      Left            =   570
      TabIndex        =   3
      Top             =   420
      Width           =   2505
   End
   Begin VB.CommandButton cmdFontColorPicker 
      Caption         =   "..."
      Height          =   315
      Left            =   2790
      TabIndex        =   6
      Top             =   810
      Width           =   315
   End
   Begin VB.TextBox txtFace 
      Height          =   315
      Left            =   570
      TabIndex        =   1
      Top             =   30
      Width           =   2505
   End
   Begin MSComDlg.CommonDialog cdMain 
      Left            =   0
      Top             =   360
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Label lblFontColor 
      Caption         =   "&Color:"
      Height          =   315
      Left            =   30
      TabIndex        =   4
      Top             =   810
      Width           =   525
   End
   Begin VB.Label lblSize 
      Caption         =   "&Size:"
      Height          =   315
      Left            =   30
      TabIndex        =   2
      Top             =   420
      Width           =   525
   End
   Begin VB.Label lblFace 
      Caption         =   "&Face:"
      Height          =   315
      Left            =   30
      TabIndex        =   0
      Top             =   30
      Width           =   525
   End
End
Attribute VB_Name = "frmFontBuilder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private msFontHTML As String
Private msSelection As String
Public Function ShowfrmFontBuilder(frmParent As Form, sSelection As String) As String
  msSelection = sSelection
  Me.Show vbModal, frmParent
  ShowfrmFontBuilder = msFontHTML
  Unload Me
End Function
Private Sub cmdCancel_Click()
  Me.Hide
End Sub
Private Sub cmdFontColorPicker_Click()
  Dim lColor As Long
  cdMain.ShowColor
  lColor = cdMain.Color
  If lColor Then
    txtFontColor.Text = "#" & Hex$(lColor)
  End If
End Sub
Private Sub cmdOK_Click()
  msFontHTML = "<font"
  If Len(txtFace.Text) > 0 Then
    msFontHTML = msFontHTML & " face='" & txtFace.Text & "'"
  End If
  If Len(txtSize.Text) > 0 Then
    msFontHTML = msFontHTML & " size='" & txtSize.Text & "'"
  End If
  If Len(txtFontColor.Text) > 0 Then
    msFontHTML = msFontHTML & " color='" & txtFontColor.Text & "'"
  End If
  msFontHTML = msFontHTML & ">" & msSelection & "</font>"
  Me.Hide
End Sub
