VERSION 5.00
Begin VB.Form frmSearchDepth 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Search Depth"
   ClientHeight    =   990
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3870
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   990
   ScaleWidth      =   3870
   ShowInTaskbar   =   0   'False
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   510
      Left            =   2655
      TabIndex        =   3
      Top             =   450
      Width           =   1185
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   510
      Left            =   1125
      TabIndex        =   2
      Top             =   450
      Width           =   1185
   End
   Begin VB.ComboBox cboSearchDepth 
      Height          =   315
      ItemData        =   "frmSearchDepth.frx":0000
      Left            =   1125
      List            =   "frmSearchDepth.frx":0013
      TabIndex        =   1
      Top             =   45
      Width           =   2715
   End
   Begin VB.Label lblSearchDepth 
      Caption         =   "Search Depth:"
      Height          =   285
      Left            =   45
      TabIndex        =   0
      Top             =   45
      Width           =   1050
   End
End
Attribute VB_Name = "frmSearchDepth"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mnModalResult As VbMsgBoxResult
Public Function ShowSearchDepth(ByRef sSearchDepth As String, frmParent As Form) As Boolean
  mnModalResult = vbCancel
  ShowSearchDepth = False
  cboSearchDepth.Text = sSearchDepth
  PositionWindow frmParent
  Me.Show vbModal, frmParent
  If mnModalResult = vbOK Then
    sSearchDepth = cboSearchDepth.Text
    ShowSearchDepth = True
  End If
  Unload Me
End Function
Private Sub PositionWindow(frmParent As Form)
  Dim nLeft As Integer
  Dim nTop As Integer
  nLeft = frmParent.Left + frmParent.Width - Me.Width
  nTop = frmParent.Top + frmParent.Height - frmParent.sbMain.Height - Me.Height
  If nLeft > -1 Then Me.Left = nLeft
  If nTop > -1 Then Me.Top = nTop
End Sub
Private Sub cmdCancel_Click()
  Me.Hide
End Sub
Private Sub cmdOK_Click()
  If DataValidates Then
    mnModalResult = vbOK
    Me.Hide
  End If
End Sub
Private Function DataValidates() As Boolean
  Dim sSearchDepth As String
  DataValidates = True
  sSearchDepth = cboSearchDepth.Text
  If sSearchDepth = "unlimited" Or IsInteger(sSearchDepth) Then
    'AOK
  Else
    DataValidates = False
  End If
End Function
