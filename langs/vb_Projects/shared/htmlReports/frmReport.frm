VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "SHDOCVW.DLL"
Begin VB.Form frmReport 
   Caption         =   "ActiveX EXE Report"
   ClientHeight    =   4470
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5400
   Icon            =   "frmReport.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   4470
   ScaleWidth      =   5400
   StartUpPosition =   3  'Windows Default
   Begin SHDocVwCtl.WebBrowser wbMain 
      Height          =   2265
      Left            =   1590
      TabIndex        =   10
      Top             =   0
      Width           =   3030
      ExtentX         =   5345
      ExtentY         =   3995
      ViewMode        =   0
      Offline         =   0
      Silent          =   0
      RegisterAsBrowser=   0
      RegisterAsDropTarget=   0
      AutoArrange     =   0   'False
      NoClientEdge    =   0   'False
      AlignLeft       =   0   'False
      NoWebView       =   0   'False
      HideFileNames   =   0   'False
      SingleClick     =   0   'False
      SingleSelection =   0   'False
      NoFolders       =   0   'False
      Transparent     =   0   'False
      ViewID          =   "{0057D0E0-3573-11CF-AE69-08002B2E1262}"
      Location        =   "http:///"
   End
   Begin VB.CommandButton cmdLast 
      Caption         =   ">|"
      Height          =   495
      Left            =   3450
      TabIndex        =   8
      Top             =   3960
      Width           =   615
   End
   Begin VB.CommandButton cmdNext 
      Caption         =   ">"
      Height          =   495
      Left            =   2820
      TabIndex        =   7
      Top             =   3960
      Width           =   615
   End
   Begin VB.CommandButton cmdPrevious 
      Caption         =   "<"
      Height          =   495
      Left            =   2190
      TabIndex        =   6
      Top             =   3960
      Width           =   615
   End
   Begin VB.CommandButton cmdFirst 
      Caption         =   "|<"
      Height          =   495
      Left            =   1560
      TabIndex        =   5
      Top             =   3960
      Width           =   615
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Height          =   495
      Left            =   60
      TabIndex        =   4
      Top             =   2220
      Width           =   1215
   End
   Begin VB.CommandButton cmdZoomOut 
      Caption         =   "Zoom &Out"
      Height          =   495
      Left            =   60
      TabIndex        =   3
      Top             =   1680
      Width           =   1215
   End
   Begin VB.CommandButton cmdZoomIn 
      Caption         =   "Zoom &In"
      Height          =   495
      Left            =   60
      TabIndex        =   2
      Top             =   1140
      Width           =   1215
   End
   Begin VB.CommandButton cmdPageSetup 
      Caption         =   "Page &Setup"
      Height          =   495
      Left            =   60
      TabIndex        =   1
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton cmdPrint 
      Caption         =   "&Print"
      Height          =   495
      Left            =   60
      TabIndex        =   0
      Top             =   60
      Width           =   1215
   End
   Begin VB.Label lblPageStatus 
      Caption         =   "PAGE STATUS"
      Height          =   285
      Left            =   4110
      TabIndex        =   9
      Top             =   3960
      Width           =   2115
   End
End
Attribute VB_Name = "frmReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub cmdClose_Click()
  Unload Me
End Sub
Private Sub Form_Initialize()
  wbMain.Navigate "about:blank"
End Sub
Private Sub Form_Resize()
  Dim lNewButtonTop As Long
  Dim lNewwbMainHeight As Long
  Dim lNewwbMainWidth As Long
  lNewwbMainHeight = Me.ScaleHeight - cmdFirst.Height
  lNewwbMainWidth = Me.ScaleWidth - wbMain.Left
  If lNewwbMainHeight > 0 Then wbMain.Height = lNewwbMainHeight
  If lNewwbMainWidth > 0 Then wbMain.Width = lNewwbMainWidth
  lNewButtonTop = Me.ScaleHeight - cmdFirst.Height
  If lNewButtonTop > 0 Then
    cmdFirst.Top = lNewButtonTop
    cmdPrevious.Top = lNewButtonTop
    cmdNext.Top = lNewButtonTop
    cmdLast.Top = lNewButtonTop
    lblPageStatus.Top = lNewButtonTop
  End If
End Sub
