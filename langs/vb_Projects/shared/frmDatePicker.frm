VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form frmDatePicker 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Pick a Date"
   ClientHeight    =   2955
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2685
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2955
   ScaleWidth      =   2685
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   510
      Left            =   1440
      TabIndex        =   0
      Top             =   2430
      Width           =   1230
   End
   Begin VB.CommandButton cmdSelect 
      Caption         =   "&Select"
      Default         =   -1  'True
      Height          =   510
      Left            =   45
      TabIndex        =   1
      Top             =   2430
      Width           =   1230
   End
   Begin MSComCtl2.MonthView mvMain 
      CausesValidation=   0   'False
      Height          =   2370
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Width           =   2700
      _ExtentX        =   4763
      _ExtentY        =   4180
      _Version        =   393216
      ForeColor       =   -2147483630
      BackColor       =   -2147483633
      Appearance      =   1
      StartOfWeek     =   24379393
      CurrentDate     =   36633
   End
End
Attribute VB_Name = "frmDatePicker"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mnModalResult As VbMsgBoxResult
Public Function GetDate(frmParent As Form) As Date
  mnModalResult = vbCancel
  Me.Show vbModal, frmParent
  If mnModalResult <> vbCancel Then
    GetDate = mvMain.Value
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
Private Sub mvMain_DateDblClick(ByVal DateDblClicked As Date)
  mnModalResult = vbOK
  Me.Hide
End Sub
