VERSION 5.00
Begin VB.Form frmSelectListBox 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "frmSelectListBox"
   ClientHeight    =   3300
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3045
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3300
   ScaleWidth      =   3045
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   1800
      TabIndex        =   2
      Top             =   2760
      Width           =   1215
   End
   Begin VB.CommandButton cmdSelect 
      Caption         =   "&Select"
      Default         =   -1  'True
      Enabled         =   0   'False
      Height          =   495
      Left            =   1800
      TabIndex        =   1
      Top             =   2160
      Width           =   1215
   End
   Begin VB.ListBox lstMain 
      Height          =   2010
      ItemData        =   "frmSelectListBox.frx":0000
      Left            =   0
      List            =   "frmSelectListBox.frx":0002
      TabIndex        =   0
      Top             =   0
      Width           =   3015
   End
   Begin VB.Label lblInstructions 
      Caption         =   "The instructions for the selection would go here."
      Height          =   1095
      Left            =   120
      TabIndex        =   3
      Top             =   2160
      Width           =   1335
      WordWrap        =   -1  'True
   End
End
Attribute VB_Name = "frmSelectListBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mnModalResult As VbMsgBoxResult
Private mCon As Connection
Private mRS As Recordset
Public Function SelectID(con As Connection, frm As Form, sSQL As String, sDisplayField As String, sIDField As String, sCaption As String, sInstructions As String) As Long
  'returns 0 on a cancel
  mnModalResult = vbCancel
  Set mCon = con
  FillList lstMain, mCon, sSQL, sDisplayField, sIDField
  Me.Caption = sCaption
  lblInstructions.Caption = sInstructions
  Me.Show vbModal, frm
  If mnModalResult = vbOK Then
    SelectID = lstMain.ItemData(lstMain.ListIndex)
  End If
  Unload Me
End Function
Private Sub cmdCancel_Click()
  Me.Hide
End Sub
Private Sub cmdSelect_Click()
  mnModalResult = vbOK
  Me.Hide
End Sub
Private Sub lstMain_Click()
  cmdSelect.Enabled = True
End Sub
Private Sub lstMain_DblClick()
  cmdSelect_Click
End Sub
