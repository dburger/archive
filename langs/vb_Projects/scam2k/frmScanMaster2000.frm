VERSION 5.00
Begin VB.Form frmScamMaster2000 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Scam Master 2k"
   ClientHeight    =   1440
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   2865
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   1440
   ScaleWidth      =   2865
   StartUpPosition =   2  'CenterScreen
   Begin VB.CheckBox chkRandomizer 
      Caption         =   "&Randomizer"
      Height          =   465
      Left            =   1620
      TabIndex        =   3
      Top             =   405
      Width           =   1185
   End
   Begin VB.ComboBox cboCycleDuration 
      Height          =   315
      ItemData        =   "frmScanMaster2000.frx":0000
      Left            =   1620
      List            =   "frmScanMaster2000.frx":000A
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   45
      Width           =   1215
   End
   Begin VB.Timer tmrMain 
      Left            =   2340
      Top             =   405
   End
   Begin VB.CommandButton cmdStartScamming 
      Caption         =   "&Start Scamming"
      Height          =   510
      Left            =   1620
      TabIndex        =   0
      Top             =   900
      Width           =   1185
   End
   Begin VB.Label lblNextDuration 
      Caption         =   "Next Duration:"
      Height          =   465
      Left            =   45
      TabIndex        =   4
      Top             =   585
      Width           =   1365
   End
   Begin VB.Label lblCycleDuration 
      Caption         =   "Cycle Duration:  (Seconds)"
      Height          =   510
      Left            =   45
      TabIndex        =   1
      Top             =   45
      Width           =   1185
   End
End
Attribute VB_Name = "frmScamMaster2000"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Const SW_NORMAL = 1
Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Private mbRunning As Boolean
Private Sub cmdStartScamming_Click()
  If cmdStartScamming.Caption = "&Start Scamming" Then
    Dim lSeconds As Long
    'first, get things going
    tmrMain_Timer
    lSeconds = CInt(cboCycleDuration.Text)
    'actually, we pass milliseconds
    lSeconds = lSeconds * 1000
    tmrMain.Interval = lSeconds
    tmrMain.Enabled = True
    cmdStartScamming.Caption = "&Take a Break"
  Else
    tmrMain.Enabled = False
    mbRunning = False
    cmdStartScamming.Caption = "&Start Scamming"
  End If
End Sub
Private Sub Form_Initialize()
  cboCycleDuration.ListIndex = 0
  Randomize Timer
End Sub
Private Sub tmrMain_Timer()
  Static asSites() As String
  Dim hFile As Long
  Dim lRet As Long
  Dim sSiteFileText As String
  Dim lRandomSeconds As Integer
  Dim lSeconds As Long
  Dim nPlusMinus As Integer
  Static nIndexPointer As Integer
  On Error GoTo ErrorHandler
  If Not mbRunning Then
    hFile = FreeFile
    Open App.Path & "\sites.txt" For Input As hFile
    sSiteFileText = Input(LOF(hFile), hFile)
    Close hFile
    asSites = Split(sSiteFileText, vbCrLf)
    nIndexPointer = 0
    mbRunning = True
  End If
  lRet = ShellExecute(0, "open", asSites(nIndexPointer), vbNullString, "", SW_NORMAL)
  nIndexPointer = nIndexPointer + 1
  If nIndexPointer > UBound(asSites) Then nIndexPointer = 0
  If chkRandomizer.Value = vbChecked Then
    tmrMain.Enabled = False
    nPlusMinus = Int((Rnd * 2))
    If nPlusMinus = 0 Then nPlusMinus = -1
    lRandomSeconds = Int((Rnd * 5) + 1) * 1000 * nPlusMinus
    lSeconds = CInt(cboCycleDuration.Text)
    'actually, we pass milliseconds
    lSeconds = lSeconds * 1000
    tmrMain.Interval = lSeconds + lRandomSeconds
    lblNextDuration.Caption = "Next Duration:  " & CStr((lSeconds + lRandomSeconds) / 1000)
    tmrMain.Enabled = True
  End If
  Exit Sub
ErrorHandler:
  If Err.Number = 53 Then 'file not found
    MsgBox "You need to create a text file called sites.txt and place it in the same directory as the Scam Master 2000 executable.  In the text file put all of the web sites you would like SM2k to cycle through each on a seperate line.", vbInformation, "sites.txt file not found"
  Else
    MsgBox Err.Description, vbCritical, "Error:  " & CStr(Err.Number)
  End If
End Sub
