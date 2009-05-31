VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmHTMLSkeleton 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "HTML Skeleton Builder"
   ClientHeight    =   3195
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin MSComDlg.CommonDialog cdMain 
      Left            =   0
      Top             =   2730
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdbgcolorPicker 
      Caption         =   "..."
      Height          =   315
      Left            =   2970
      TabIndex        =   6
      Top             =   480
      Width           =   315
   End
   Begin VB.TextBox txtbgcolor 
      Height          =   315
      Left            =   960
      TabIndex        =   5
      Top             =   480
      Width           =   2025
   End
   Begin VB.TextBox Text1 
      Height          =   315
      Left            =   930
      TabIndex        =   3
      Top             =   60
      Width           =   2355
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   525
      Left            =   3330
      TabIndex        =   1
      Top             =   930
      Width           =   1245
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   525
      Left            =   3330
      TabIndex        =   0
      Top             =   360
      Width           =   1245
   End
   Begin VB.Label lblbgcolor 
      Caption         =   "&Background Color:"
      Height          =   435
      Left            =   60
      TabIndex        =   4
      Top             =   480
      Width           =   915
   End
   Begin VB.Label lblTitle 
      Caption         =   "&Title"
      Height          =   315
      Left            =   60
      TabIndex        =   2
      Top             =   60
      Width           =   795
   End
End
Attribute VB_Name = "frmHTMLSkeleton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private msHTMLSkeleton As String
Private mfrmParent As Form
Public Function ShowfrmHTMLSkeleton(frmParent As Form) As String
  Set mfrmParent = frmParent
  Me.Show vbModal, frmParent
  ShowfrmHTMLSkeleton = msHTMLSkeleton
  Unload Me
End Function
Private Sub cmdbgcolorPicker_Click()
  Dim lColor As Long
  cdMain.ShowColor
  lColor = cdMain.Color
  If lColor Then
    txtbgcolor.Text = "#" & Hex$(lColor)
  End If
End Sub
Private Sub cmdCancel_Click()
  Me.Hide
End Sub
Private Sub cmdOK_Click()
  msHTMLSkeleton = "<html>" & vbCrLf
  msHTMLSkeleton = msHTMLSkeleton & "<head>" & vbCrLf
  msHTMLSkeleton = msHTMLSkeleton & "<title></title>" & vbCrLf
  msHTMLSkeleton = msHTMLSkeleton & "</head>" & vbCrLf
  msHTMLSkeleton = msHTMLSkeleton & "<body"
  If Len(txtbgcolor.Text) > 0 Then
    msHTMLSkeleton = msHTMLSkeleton & " bgcolor='" & txtbgcolor.Text & "'"
  End If
  msHTMLSkeleton = msHTMLSkeleton & ">" & vbCrLf & vbCrLf
  msHTMLSkeleton = msHTMLSkeleton & "</body>" & vbCrLf
  msHTMLSkeleton = msHTMLSkeleton & "</html>"
  Me.Hide
End Sub

