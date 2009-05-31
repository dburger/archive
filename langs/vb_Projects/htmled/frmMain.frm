VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "SHDOCVW.DLL"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmMain 
   Caption         =   "Burger's HTML Editor"
   ClientHeight    =   3195
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   4680
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog cdMain 
      Left            =   0
      Top             =   2700
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.TextBox txtHTML 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1005
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   0
      Width           =   1485
   End
   Begin SHDocVwCtl.WebBrowser wbPreview 
      Height          =   1065
      Left            =   0
      TabIndex        =   1
      Top             =   0
      Width           =   1575
      ExtentX         =   2778
      ExtentY         =   1879
      ViewMode        =   0
      Offline         =   0
      Silent          =   0
      RegisterAsBrowser=   0
      RegisterAsDropTarget=   1
      AutoArrange     =   0   'False
      NoClientEdge    =   0   'False
      AlignLeft       =   0   'False
      ViewID          =   "{0057D0E0-3573-11CF-AE69-08002B2E1262}"
      Location        =   ""
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileOpen 
         Caption         =   "&Open..."
      End
      Begin VB.Menu mnuFileSave 
         Caption         =   "&Save"
      End
      Begin VB.Menu mnuFileSaveAs 
         Caption         =   "Save &As..."
      End
      Begin VB.Menu mnuFilePreview 
         Caption         =   "&Preview"
      End
      Begin VB.Menu mnuSepBar3 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "&Edit"
      Begin VB.Menu mnuEditUndo 
         Caption         =   "&Undo"
      End
      Begin VB.Menu mnuEditCut 
         Caption         =   "Cu&t"
         Shortcut        =   ^X
      End
      Begin VB.Menu mnuEditCopy 
         Caption         =   "&Copy"
         Shortcut        =   ^C
      End
      Begin VB.Menu mnuEditPaste 
         Caption         =   "&Paste"
         Shortcut        =   ^V
      End
      Begin VB.Menu mnuEditSelectAll 
         Caption         =   "Select &All"
         Shortcut        =   ^A
      End
   End
   Begin VB.Menu mnuFormat 
      Caption         =   "F&ormat"
      Begin VB.Menu mnuFormatFont 
         Caption         =   "&Font"
      End
      Begin VB.Menu mnuSepBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFormatBold 
         Caption         =   "&Bold"
      End
      Begin VB.Menu mnuFormatHyperlink 
         Caption         =   "&Hyperlink"
      End
      Begin VB.Menu mnuFormatItalics 
         Caption         =   "&Italics"
      End
      Begin VB.Menu mnuFormatUnderline 
         Caption         =   "&Underline"
      End
      Begin VB.Menu mnuSepBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFormatLeft 
         Caption         =   "&Left"
      End
      Begin VB.Menu mnuFormatCenter 
         Caption         =   "&Center"
      End
      Begin VB.Menu mnuFormatRight 
         Caption         =   "&Right"
      End
   End
   Begin VB.Menu mnuInsert 
      Caption         =   "&Insert"
      Begin VB.Menu mnuInsertHTMLSkeleton 
         Caption         =   "HTML &Skeleton"
      End
      Begin VB.Menu mnuInsertImage 
         Caption         =   "&Image"
      End
      Begin VB.Menu mnuInsertParagraphBreak 
         Caption         =   "&Paragraph Break"
      End
      Begin VB.Menu mnuInsertRegularBreak 
         Caption         =   "&Regular Break"
      End
      Begin VB.Menu mnuInsertTable 
         Caption         =   "&Table"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mbDirty As Boolean
Private msFilename As String
Private Const EM_CANUNDO = &HC6
Private Const EM_UNDO = &HC7
Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  Dim nRet As VbMsgBoxResult
  If mbDirty Then
    nRet = MsgBox("Changes to this document have not been saved, are you sure you wish to exit?", vbYesNo, "Exit?")
    If nRet = vbNo Then Cancel = True
  End If
End Sub
Private Sub Form_Resize()
  Dim lWidth As Long
  Dim lHeight As Long
  lWidth = Me.ScaleWidth
  lHeight = Me.ScaleHeight
  txtHTML.Width = lWidth
  txtHTML.Height = lHeight
  wbPreview.Width = lWidth
  wbPreview.Height = lHeight
End Sub
Private Sub mnuEdit_Click()
  Dim bHasSelection As Boolean
  Dim lRet As Long
  If mnuFilePreview.Checked = True Then
    mnuEditCut.Enabled = False
    mnuEditCopy.Enabled = False
    mnuEditPaste.Enabled = False
    mnuEditUndo.Enabled = False
  Else
    bHasSelection = (txtHTML.SelLength > 0)
    mnuEditCut.Enabled = bHasSelection
    mnuEditCopy.Enabled = bHasSelection
    mnuEditPaste.Enabled = Clipboard.GetFormat(vbCFText) = True
    mnuEditUndo.Enabled = (SendMessage(txtHTML.hwnd, EM_CANUNDO, 0, 0) <> 0)
  End If
End Sub
Private Sub mnuEditCopy_Click()
  Clipboard.SetText txtHTML.SelText, vbCFText
End Sub
Private Sub mnuEditCut_Click()
  Clipboard.SetText txtHTML.Text, vbCFText
  txtHTML.SelText = ""
End Sub
Private Sub mnuEditPaste_Click()
  Dim sText As String
  sText = Clipboard.GetText
  txtHTML.SelText = sText
End Sub
Private Sub mnuEditSelectAll_Click()
  txtHTML.SelStart = 0
  txtHTML.SelLength = Len(txtHTML.Text)
  txtHTML.Refresh
End Sub
Private Sub mnuEditUndo_Click()
  Dim lRet As Long
  lRet = SendMessage(txtHTML.hwnd, EM_UNDO, 0, 0)
End Sub
Private Sub mnuFileExit_Click()
  Unload Me
End Sub
Private Sub mnuFileOpen_Click()
  'did not use the FileSystemObject of the scripting library
  'because did not want overhead of installation
  Dim hFile As Integer
  Dim sFilename As String
  Dim sHTML As String
  cdMain.ShowOpen
  sFilename = cdMain.FileName
  If Len(sFilename) > 0 Then
    hFile = FreeFile
    Open sFilename For Input As hFile
    sHTML = Input(LOF(hFile), hFile)
    Close hFile
    txtHTML.Text = sHTML
    mbDirty = False
  End If
End Sub
Private Sub mnuFilePreview_Click()
  If mnuFilePreview.Checked = True Then
    mnuFilePreview.Checked = False
    wbPreview.ZOrder 1
    mnuEdit.Enabled = True
    mnuFormat.Enabled = True
    mnuInsert.Enabled = True
  Else
    Dim sTempFilename As String
    Dim lRet As Long
    Dim hFile As Integer
    sTempFilename = GetTempFilename
    hFile = FreeFile
    Open sTempFilename For Output As #hFile
    Print #hFile, txtHTML.Text
    Close hFile
    wbPreview.Navigate "file://" & sTempFilename
    mnuFilePreview.Checked = True
    txtHTML.ZOrder 1
    mnuEdit.Enabled = False
    mnuFormat.Enabled = False
    mnuInsert.Enabled = False
  End If
End Sub
Private Sub mnuFileSave_Click()
  'did not use the FileSystemObject of the scripting library
  'because did not want overhead of installation
  Dim hFile As Integer
  Dim sFilename As String
  If Len(msFilename) > 0 Then
    sFilename = msFilename
  Else
    cdMain.ShowSave
    sFilename = cdMain.FileName
  End If
  If Len(sFilename) > 0 Then
    hFile = FreeFile
    Open sFilename For Output As #hFile
    Print #hFile, txtHTML.Text
    Close hFile
    msFilename = sFilename
    mbDirty = False
  End If
End Sub
Private Sub mnuFileSaveAs_Click()
  Dim hFile As Integer
  Dim sFilename As String
  cdMain.ShowSave
  sFilename = cdMain.FileName
  If Len(sFilename) > 0 Then
    hFile = FreeFile
    Open sFilename For Output As #hFile
    Print #hFile, txtHTML.Text
    Close hFile
    msFilename = sFilename
    mbDirty = False
  End If
End Sub
Private Sub mnuFormatBold_Click()
  txtHTML.SelText = "<b>" & txtHTML.SelText & "</b>"
End Sub
Private Sub mnuFormatCenter_Click()
  txtHTML.SelText = "<p align='center'>" & txtHTML.SelText & "</p>"
End Sub
Private Sub mnuFormatFont_Click()
  Dim sNewHTML As String
  Dim frmNew As frmFontBuilder
  Set frmNew = New frmFontBuilder
  sNewHTML = frmNew.ShowfrmFontBuilder(Me, txtHTML.SelText)
  If Len(sNewHTML) > 0 Then
    txtHTML.SelText = sNewHTML
  End If
End Sub
Private Sub mnuFormatHyperlink_Click()
  Dim sNewHTML As String
  Dim frmNew As frmHyperlink
  Set frmNew = New frmHyperlink
  sNewHTML = frmNew.ShowfrmHyperlink(Me, txtHTML.SelText)
  If Len(sNewHTML) > 0 Then
    txtHTML.SelText = sNewHTML
  End If
End Sub
Private Sub mnuFormatItalics_Click()
  txtHTML.SelText = "<i>" & txtHTML.SelText & "</i>"
End Sub
Private Sub mnuFormatLeft_Click()
  txtHTML.SelText = "<p align='left'>" & txtHTML.SelText & "</p>"
End Sub
Private Sub mnuFormatRight_Click()
  txtHTML.SelText = "<p align='right'>" & txtHTML.SelText & "</p>"
End Sub
Private Sub mnuFormatUnderline_Click()
  txtHTML.SelText = "<u>" & txtHTML.SelText & "</u>"
End Sub
Private Sub mnuInsert_Click()
  If Len(txtHTML.Text) > 0 Then
    mnuInsertHTMLSkeleton.Enabled = False
  Else
    mnuInsertHTMLSkeleton.Enabled = True
  End If
End Sub
Private Sub mnuInsertHTMLSkeleton_Click()
  Dim sNewHTML As String
  Dim frmNew As frmHTMLSkeleton
  Set frmNew = New frmHTMLSkeleton
  sNewHTML = frmNew.ShowfrmHTMLSkeleton(Me)
  If Len(sNewHTML) > 0 Then
    txtHTML.SelText = sNewHTML
  End If
End Sub
Private Sub mnuInsertImage_Click()
  Dim sNewHTML As String
  Dim frmNew As frmImageTag
  Set frmNew = New frmImageTag
  sNewHTML = frmNew.ShowfrmImageTag(Me)
  If Len(sNewHTML) > 0 Then
    txtHTML.SelText = sNewHTML
  End If
End Sub
Private Sub mnuInsertParagraphBreak_Click()
  txtHTML.SelText = "<p>"
End Sub
Private Sub mnuInsertRegularBreak_Click()
  txtHTML.SelText = "<br>"
End Sub
Private Sub mnuInsertTable_Click()
  Dim sNewHTML As String
  Dim frmNew As frmTableBuilder
  Set frmNew = New frmTableBuilder
  sNewHTML = frmNew.ShowfrmTableBuilder(Me)
  If Len(sNewHTML) > 0 Then
    txtHTML.SelText = sNewHTML
  End If
End Sub
Private Sub txtHTML_Change()
  mbDirty = True
End Sub
