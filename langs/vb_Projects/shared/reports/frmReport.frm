VERSION 5.00
Object = "{7E00A3A2-8F5C-11D2-BAA4-04F205C10000}#1.0#0"; "VSVIEW6.OCX"
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
   Begin VB.CommandButton cmdLast 
      Caption         =   ">|"
      Height          =   495
      Left            =   3450
      TabIndex        =   9
      Top             =   3960
      Width           =   615
   End
   Begin VB.CommandButton cmdNext 
      Caption         =   ">"
      Height          =   495
      Left            =   2820
      TabIndex        =   8
      Top             =   3960
      Width           =   615
   End
   Begin VB.CommandButton cmdPrevious 
      Caption         =   "<"
      Height          =   495
      Left            =   2190
      TabIndex        =   7
      Top             =   3960
      Width           =   615
   End
   Begin VB.CommandButton cmdFirst 
      Caption         =   "|<"
      Height          =   495
      Left            =   1560
      TabIndex        =   6
      Top             =   3960
      Width           =   615
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Close"
      Height          =   495
      Left            =   60
      TabIndex        =   5
      Top             =   2220
      Width           =   1215
   End
   Begin VB.CommandButton cmdZoomOut 
      Caption         =   "Zoom &Out"
      Height          =   495
      Left            =   60
      TabIndex        =   4
      Top             =   1680
      Width           =   1215
   End
   Begin VB.CommandButton cmdZoomIn 
      Caption         =   "Zoom &In"
      Height          =   495
      Left            =   60
      TabIndex        =   3
      Top             =   1140
      Width           =   1215
   End
   Begin VB.CommandButton cmdPageSetup 
      Caption         =   "Page &Setup"
      Height          =   495
      Left            =   60
      TabIndex        =   2
      Top             =   600
      Width           =   1215
   End
   Begin VB.CommandButton cmdPrint 
      Caption         =   "&Print"
      Height          =   495
      Left            =   60
      TabIndex        =   1
      Top             =   60
      Width           =   1215
   End
   Begin VSVIEW6Ctl.VSPrinter vspMain 
      Height          =   1485
      Left            =   1590
      TabIndex        =   0
      Top             =   0
      Width           =   3255
      _cx             =   4200045
      _cy             =   4196923
      Appearance      =   1
      BorderStyle     =   1
      Enabled         =   -1  'True
      MousePointer    =   0
      BackColor       =   -2147483643
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty HdrFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "Courier New"
         Size            =   14.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      _ConvInfo       =   -1
      AutoRTF         =   -1  'True
      Preview         =   -1  'True
      DefaultDevice   =   0   'False
      PhysicalPage    =   -1  'True
      AbortWindow     =   -1  'True
      AbortWindowPos  =   0
      AbortCaption    =   "Printing..."
      AbortTextButton =   "Cancel"
      AbortTextDevice =   "on the %s on %s"
      AbortTextPage   =   "Now printing Page %d of"
      FileName        =   ""
      MarginLeft      =   1440
      MarginTop       =   1440
      MarginRight     =   1440
      MarginBottom    =   1440
      MarginHeader    =   0
      MarginFooter    =   0
      IndentLeft      =   0
      IndentRight     =   0
      IndentFirst     =   0
      IndentTab       =   720
      SpaceBefore     =   0
      SpaceAfter      =   0
      LineSpacing     =   100
      Columns         =   1
      ColumnSpacing   =   180
      ShowGuides      =   2
      LargeChangeHorz =   300
      LargeChangeVert =   300
      SmallChangeHorz =   30
      SmallChangeVert =   30
      Track           =   0   'False
      ProportionalBars=   -1  'True
      Zoom            =   5.96590909090909
      ZoomMode        =   3
      ZoomMax         =   400
      ZoomMin         =   10
      ZoomStep        =   5
      MouseZoom       =   2
      MouseScroll     =   -1  'True
      MousePage       =   -1  'True
      EmptyColor      =   -2147483636
      TextColor       =   0
      HdrColor        =   0
      BrushColor      =   0
      BrushStyle      =   0
      PenColor        =   0
      PenStyle        =   0
      PenWidth        =   0
      PageBorder      =   0
      Header          =   ""
      Footer          =   ""
      TableSep        =   "|;"
      TableBorder     =   7
      TablePen        =   0
      TablePenLR      =   0
      TablePenTB      =   0
      HTMLStyle       =   1
   End
   Begin VB.Label lblPageStatus 
      Caption         =   "PAGE STATUS"
      Height          =   285
      Left            =   4110
      TabIndex        =   10
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
Private Sub cmdFirst_Click()
  vspMain.PreviewPage = 1
  UpdatePageStatus
End Sub
Private Sub cmdLast_Click()
  vspMain.PreviewPage = vspMain.PageCount
  UpdatePageStatus
End Sub
Private Sub cmdNext_Click()
  vspMain.PreviewPage = vspMain.PreviewPage + 1
  UpdatePageStatus
End Sub
Private Sub cmdPrevious_Click()
  vspMain.PreviewPage = vspMain.PreviewPage - 1
  UpdatePageStatus
End Sub
Private Sub cmdPageSetup_Click()
  On Error GoTo ErrorHandler
  vspMain.PrintDialog pdPageSetup
  Exit Sub
ErrorHandler:
  MsgBox Err.Description, vbOKOnly + vbInformation, "Error:  " & CStr(Err.Number)
End Sub
Private Sub cmdPrint_Click()
  On Error GoTo ErrorHandler
  vspMain.PrintDoc
  Exit Sub
ErrorHandler:
  MsgBox Err.Description, vbOKOnly + vbInformation, "Error:  " & CStr(Err.Number)
End Sub
Private Sub cmdZoomIn_Click()
  vspMain.Zoom = vspMain.Zoom + 5
End Sub
Private Sub cmdZoomOut_Click()
  vspMain.Zoom = vspMain.Zoom - 5
End Sub
Private Sub Form_Resize()
  Dim lNewButtonTop As Long
  Dim lNewvspMainHeight As Long
  Dim lNewvspMainWidth As Long
  lNewvspMainHeight = Me.ScaleHeight - cmdFirst.Height
  lNewvspMainWidth = Me.ScaleWidth - vspMain.Left
  If lNewvspMainHeight > 0 Then vspMain.Height = lNewvspMainHeight
  If lNewvspMainWidth > 0 Then vspMain.Width = lNewvspMainWidth
  lNewButtonTop = Me.ScaleHeight - cmdFirst.Height
  If lNewButtonTop > 0 Then
    cmdFirst.Top = lNewButtonTop
    cmdPrevious.Top = lNewButtonTop
    cmdNext.Top = lNewButtonTop
    cmdLast.Top = lNewButtonTop
    lblPageStatus.Top = lNewButtonTop
  End If
End Sub
Public Sub UpdatePageStatus()
  lblPageStatus.Caption = "Page " & vspMain.PreviewPage & " of " & vspMain.PageCount
End Sub
