VERSION 5.00
Begin VB.Form frmSplash 
   BorderStyle     =   3  'Fixed Dialog
   ClientHeight    =   4215
   ClientLeft      =   45
   ClientTop       =   45
   ClientWidth     =   6270
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4215
   ScaleWidth      =   6270
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Height          =   375
      Left            =   4920
      TabIndex        =   0
      Top             =   3720
      Visible         =   0   'False
      Width           =   1215
   End
   Begin VB.Image Image1 
      Height          =   4230
      Left            =   0
      Picture         =   "frmSplash.frx":0000
      Top             =   0
      Width           =   6255
   End
End
Attribute VB_Name = "frmSplash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public Sub ShowSplash()
  Me.Show vbModeless
  Me.Refresh
End Sub
Public Sub EndSplash()
  Unload Me
End Sub
Public Sub ShowAbout(frmParent As Form)
  cmdOK.Visible = True
  Me.Show vbModal, frmParent
End Sub
Private Sub cmdOK_Click()
  Unload Me
End Sub
Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
  If KeyCode = vbKeyEscape Then Unload Me
End Sub
