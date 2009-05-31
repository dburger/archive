VERSION 5.00
Begin VB.Form frmConfigure 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "RezMan Configuration Settings"
   ClientHeight    =   2070
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7380
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2070
   ScaleWidth      =   7380
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.OptionButton optSixtyMinutes 
      Caption         =   "&Sixty Minutes"
      Height          =   255
      Left            =   2400
      TabIndex        =   9
      Top             =   1680
      Width           =   1575
   End
   Begin VB.OptionButton optThirtyMinutes 
      Caption         =   "&Thirty Minutes"
      Height          =   255
      Left            =   2400
      TabIndex        =   8
      Top             =   1320
      Width           =   1575
   End
   Begin VB.OptionButton optTenMinutes 
      Caption         =   "&Ten Minutes"
      Height          =   255
      Left            =   2400
      TabIndex        =   7
      Top             =   960
      Width           =   1215
   End
   Begin VB.OptionButton optFiveMinutes 
      Caption         =   "&Five Minutes"
      Height          =   255
      Left            =   2400
      TabIndex        =   6
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "&Browse"
      Height          =   285
      Left            =   6000
      TabIndex        =   5
      Top             =   120
      Width           =   1335
   End
   Begin VB.CheckBox chkAllowOverbooking 
      Caption         =   "&Allow Overbooking"
      Height          =   495
      Left            =   5640
      TabIndex        =   4
      Top             =   600
      Width           =   1695
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   6120
      TabIndex        =   3
      Top             =   1560
      Width           =   1215
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   495
      Left            =   4800
      TabIndex        =   2
      Top             =   1560
      Width           =   1215
   End
   Begin VB.TextBox txtDataSource 
      Height          =   285
      Left            =   2400
      TabIndex        =   1
      Top             =   120
      Width           =   3615
   End
   Begin VB.Label lblDataSourceLocation 
      Caption         =   "&Data Source Location:"
      Height          =   285
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   2175
   End
End
Attribute VB_Name = "frmConfigure"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mobjAppSettings As clsAppSettings
Private mobjDataSourceLocation As clsDataLocation
Private mnModalResult As VbMsgBoxResult
Public bDataSourceLocationChanged As Boolean
Public bAllowOverbookingChanged As Boolean
Public bGranularityChanged As Boolean
Public Function ShowConfigure(frm As Form, objAppSettings As clsAppSettings) As Boolean
  mnModalResult = vbCancel
  Set mobjAppSettings = objAppSettings
  Set mobjDataSourceLocation = New clsDataLocation
  txtDataSource.Text = mobjDataSourceLocation.DataSourceLocation
  If mobjAppSettings.AllowOverbooking Then chkAllowOverbooking.Value = vbChecked
  Select Case mobjAppSettings.Granularity
    Case 5
      optFiveMinutes.Value = True
    Case 10
      optTenMinutes.Value = True
    Case 30
      optThirtyMinutes.Value = True
    Case 60
      optSixtyMinutes.Value = True
  End Select
  Me.Show vbModal, frm
  If mnModalResult = vbOK Then ShowConfigure = True
End Function
Private Sub cmdBrowse_Click()
  Dim sFilename As String
  Dim objFileDialog As clsFileDialog
  Set objFileDialog = New clsFileDialog
  sFilename = objFileDialog.GetOpenFileName(Me.hwnd, "All Files" & vbNullChar & "*.*" & vbNullChar & "Rezman Files" & vbNullChar & "*.rzm" & vbNullChar, 2, "rez", "rzm", "Choose Data Source Location", App.Path & "\data")
  MsgBox "here is where check if exists and ask if want to create"
  If Len(sFilename) > 0 Then txtDataSource.Text = sFilename
End Sub
Private Sub cmdCancel_Click()
  Unload Me
End Sub
Private Sub cmdOK_Click()
  Dim nGranularity As Integer
  If DataValidates Then
    If txtDataSource.Text <> mobjDataSourceLocation.DataSourceLocation Then
      bDataSourceLocationChanged = True
      mobjDataSourceLocation.DataSourceLocation = txtDataSource.Text
    End If
    If mobjAppSettings.AllowOverbooking Then
      If chkAllowOverbooking.Value = vbUnchecked Then
        bAllowOverbookingChanged = True
        mobjAppSettings.AllowOverbooking = False
      End If
    Else
      If chkAllowOverbooking.Value = vbChecked Then
        bAllowOverbookingChanged = True
        mobjAppSettings.AllowOverbooking = True
      End If
    End If
    If optFiveMinutes.Value = True Then nGranularity = 5
    If optTenMinutes.Value = True Then nGranularity = 10
    If optThirtyMinutes.Value = True Then nGranularity = 30
    If optSixtyMinutes.Value = True Then nGranularity = 60
    If mobjAppSettings.Granularity <> nGranularity Then
      mobjAppSettings.Granularity = nGranularity
      bGranularityChanged = True
    End If
    If mobjAppSettings.Dirty Then mobjAppSettings.SaveSettings
    If mobjDataSourceLocation.Dirty Then mobjDataSourceLocation.SaveSettings
    mnModalResult = vbOK
    Unload Me
  End If
End Sub
Private Function DataValidates() As Boolean
  'pooper
  MsgBox "Not implemented, asssumed true"
  DataValidates = True
End Function
