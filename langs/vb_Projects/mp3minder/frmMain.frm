VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmMain 
   Caption         =   "mp3 minder 1.0b"
   ClientHeight    =   6225
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   6720
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6225
   ScaleWidth      =   6720
   Begin VB.CommandButton cmdDelete 
      Caption         =   "Delete"
      Height          =   305
      Left            =   4050
      TabIndex        =   12
      Top             =   315
      Width           =   1320
   End
   Begin VB.CommandButton cmdCopy 
      Caption         =   "Copy"
      Height          =   305
      Left            =   2700
      TabIndex        =   11
      Top             =   315
      Width           =   1320
   End
   Begin VB.CommandButton cmdMove 
      Caption         =   "Move"
      Height          =   305
      Left            =   1350
      TabIndex        =   10
      Top             =   315
      Width           =   1320
   End
   Begin VB.CommandButton cmdRename 
      Caption         =   "Rename"
      Height          =   305
      Left            =   0
      TabIndex        =   9
      Top             =   315
      Width           =   1320
   End
   Begin VB.CommandButton cmdSaveAsPlaylist 
      Caption         =   "Save &as Playlist"
      Height          =   305
      Left            =   5400
      TabIndex        =   8
      Top             =   0
      Width           =   1320
   End
   Begin VB.CommandButton cmdEditID3Info 
      Caption         =   "&Edit ID3 Info"
      Height          =   305
      Left            =   4050
      TabIndex        =   7
      Top             =   0
      Width           =   1320
   End
   Begin VB.CommandButton cmdPlaySelected 
      Caption         =   "&Play Selected"
      Height          =   305
      Left            =   2700
      TabIndex        =   6
      Top             =   0
      Width           =   1320
   End
   Begin MSComctlLib.StatusBar sbMain 
      Align           =   2  'Align Bottom
      Height          =   375
      Left            =   0
      TabIndex        =   5
      Top             =   5850
      Width           =   6720
      _ExtentX        =   11853
      _ExtentY        =   661
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   2
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   8784
            Key             =   "directory"
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Text            =   "unlimited"
            TextSave        =   "unlimited"
            Key             =   "searchdepth"
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.TabStrip tbsMain 
      Height          =   375
      Left            =   0
      TabIndex        =   4
      Top             =   610
      Width           =   1500
      _ExtentX        =   2646
      _ExtentY        =   661
      _Version        =   393216
      BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
         NumTabs         =   2
         BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "&MP3s"
            Key             =   "mp3s"
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
            Caption         =   "&Playlists"
            Key             =   "playlists"
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
   Begin MSComctlLib.ListView lvMP3s 
      Height          =   1455
      Left            =   135
      TabIndex        =   2
      Top             =   2025
      Width           =   1500
      _ExtentX        =   2646
      _ExtentY        =   2566
      View            =   3
      LabelEdit       =   1
      Sorted          =   -1  'True
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   0   'False
      AllowReorder    =   -1  'True
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.CommandButton cmdClear 
      Caption         =   "&Clear"
      Height          =   305
      Left            =   1350
      TabIndex        =   1
      Top             =   0
      Width           =   1320
   End
   Begin VB.CommandButton cmdSearch 
      Caption         =   "&Search"
      Height          =   305
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   1320
   End
   Begin MSComctlLib.TreeView tvPlaylists 
      Height          =   1455
      Left            =   1800
      TabIndex        =   3
      Top             =   2025
      Width           =   1545
      _ExtentX        =   2725
      _ExtentY        =   2566
      _Version        =   393217
      HideSelection   =   0   'False
      LabelEdit       =   1
      LineStyle       =   1
      Sorted          =   -1  'True
      Style           =   6
      FullRowSelect   =   -1  'True
      Appearance      =   1
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Const TOP_BORDER_HEIGHT = 985
Dim WithEvents objFileSearch As clsFileFinder
Attribute objFileSearch.VB_VarHelpID = -1
Private Sub cmdSearch_Click()
  Dim sSearchDirectory As String
  Dim sMaxSearchDepth As String
  Dim nMaxSearchDepth As Integer
  sSearchDirectory = sbMain.Panels.Item("directory").Text
  If Len(sSearchDirectory) = 0 Then
    sbMain.Panels.Item("directory").Text = "C:\"
    sSearchDirectory = "C:\"
  End If
  sMaxSearchDepth = sbMain.Panels.Item("searchdepth").Text
  If sMaxSearchDepth = "unlimited" Then
    nMaxSearchDepth = -1
  ElseIf IsInteger(sMaxSearchDepth) Then
    nMaxSearchDepth = CInt(sMaxSearchDepth)
  Else
    'go for the full depth sentinel
    nMaxSearchDepth = -1
  End If
  Set objFileSearch = New clsFileFinder
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
      objFileSearch.FindFilesNonRecursive sSearchDirectory, "*.mp3", nMaxSearchDepth
    Case "playlists"
      objFileSearch.FindFilesNonRecursive sSearchDirectory, "*.m3u", nMaxSearchDepth
  End Select
  sbMain.Panels.Item("directory").Text = sSearchDirectory
End Sub
Private Sub cmdClear_Click()
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
      lvMP3s.ListItems.Clear
    Case "playlists"
      tvPlaylists.Nodes.Clear
  End Select
End Sub
Private Sub cmdPlaySelected_Click()
  Dim objPlaylist As clsPlaylist
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
        If Not lvMP3s.SelectedItem Is Nothing Then
          Set objPlaylist = New clsPlaylist
          objPlaylist.InitFromListView lvMP3s
          objPlaylist.Play
        End If
    Case "playlists"
      If Not tvPlaylists.SelectedItem Is Nothing Then
        Dim sKey As String
        sKey = tvPlaylists.SelectedItem.Key
        If IsTreeViewPlaylist(sKey) Then
          Set objPlaylist = New clsPlaylist
          objPlaylist.InitFromTreeViewNode tvPlaylists.SelectedItem
          objPlaylist.Play
        Else 'is an individual song
          LaunchAppByAssociation Me.hwnd, ExtractSongFilenameFromTreeNodeChildKey(sKey), ""
        End If
      End If
  End Select
End Sub
Private Sub cmdEditID3Info_Click()
  Dim objMP3Info As clsMP3Info
  Dim frmNew As frmMP3Information
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
      If Not lvMP3s.SelectedItem Is Nothing Then
        Set objMP3Info = New clsMP3Info
        objMP3Info.init lvMP3s.SelectedItem.Key
        Set frmNew = New frmMP3Information
        If frmNew.ShowAttributes(objMP3Info, Me) Then
          With lvMP3s.SelectedItem
            .ListSubItems("title").Text = objMP3Info.Title
            .ListSubItems("artist").Text = objMP3Info.Artist
            .ListSubItems("album").Text = objMP3Info.Album
            .ListSubItems("year").Text = objMP3Info.Year
            .ListSubItems("comment").Text = objMP3Info.Comment
            .ListSubItems("genre").Text = objMP3Info.GenreString
          End With
        End If
      End If
    Case "playlists"
      If Not tvPlaylists.SelectedItem Is Nothing Then
        Dim sKey As String
        sKey = tvPlaylists.SelectedItem.Key
        If IsTreeViewSong(sKey) Then
          Set objMP3Info = New clsMP3Info
          objMP3Info.init ExtractSongFilenameFromTreeNodeChildKey(sKey)
          Set frmNew = New frmMP3Information
          frmNew.ShowAttributes objMP3Info, Me
        Else
          'no id3 info for the playlist
        End If
      End If
  End Select
End Sub
Private Sub cmdSaveAsPlaylist_Click()
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
      Dim objPlaylist As clsPlaylist
      Set objPlaylist = New clsPlaylist
      objPlaylist.InitFromListView lvMP3s
      If objPlaylist.HasSongs Then
        Dim objFileDialog As clsFileDialog
        Dim sFilename As String
        Set objFileDialog = New clsFileDialog
        sFilename = objFileDialog.GetSaveAsFileName(Me.hwnd, "*.m3u", 0, "", "m3u", "Save As Playlist")
        If Len(sFilename) > 0 Then
          objPlaylist.FullPath = sFilename
          objPlaylist.Save
        End If
      End If
    Case "playlists"
      'can't select on the playlist tab and then save as a playlist, not multi-select
  End Select
End Sub
Private Sub cmdRename_Click()
  Dim sNewFilename As String
  Dim sOldFilename As String
  Dim sOldFullPath As String
  Dim sPath As String
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
      If Not lvMP3s.SelectedItem Is Nothing Then
        Dim objPlaylist As clsPlaylist
        Set objPlaylist = New clsPlaylist
        objPlaylist.InitFromListView lvMP3s
        If Not objPlaylist.MoreThanOneSong Then
          sNewFilename = InputBox$("Please enter the new name for the file.", "Rename", GetFilenameFromFullPath(objPlaylist.Playlist))
          If Len(sNewFilename) > 0 Then
            sPath = GetPathFromFullPath(objPlaylist.Playlist)
            If Not APIFileCopy(objPlaylist.Playlist, sPath & "\" & sNewFilename, True) Then
              MsgBox "Unable to rename " & objPlaylist.Playlist & ".", vbOKOnly + vbCritical, "Rename Error"
            Else
              lvMP3s.SelectedItem.Text = sNewFilename
              lvMP3s.SelectedItem.Key = sPath & "\" & sNewFilename
              Kill objPlaylist.Playlist
            End If
          End If
        Else
          MsgBox "Please select one file to rename", vbOKOnly + vbInformation, "One File"
        End If
      End If
    Case "playlists"
      If Not tvPlaylists.SelectedItem Is Nothing Then
        sOldFullPath = tvPlaylists.SelectedItem.Key
        If IsTreeViewSong(sOldFullPath) Then
          'they have an individual song selected in a playlist
          'no renaming is allowed
        Else
          'they have a playlist selected
          sOldFilename = GetFilenameFromFullPath(sOldFullPath)
          sPath = GetPathFromFullPath(sOldFullPath)
          sNewFilename = InputBox$("Please enter the new name for the file.", "Rename", sOldFilename)
          If Len(sNewFilename) > 0 Then
            If Not APIFileCopy(sOldFullPath, sPath & "\" & sNewFilename, True) Then
              MsgBox "Unable to rename " & sOldFilename & ".", vbOKOnly + vbCritical, "Rename Error"
            Else
              tvPlaylists.SelectedItem.Text = sPath & "\" & sNewFilename
              tvPlaylists.SelectedItem.Key = sPath & "\" & sNewFilename
              Kill sOldFullPath
            End If
          End If
        End If
      End If
  End Select
End Sub
Private Sub cmdMove_Click()
  Dim sNewPath As String
  Dim sFilename As String
  Dim objPlaylist As clsPlaylist
  Dim objDirectoryChooser As clsDirectoryChooser
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
      If Not lvMP3s.SelectedItem Is Nothing Then
        Set objPlaylist = New clsPlaylist
        objPlaylist.InitFromListView lvMP3s
        Set objDirectoryChooser = New clsDirectoryChooser
        sNewPath = objDirectoryChooser.GetDirectory(Me)
        If Len(sNewPath) > 0 Then
          Dim astr() As String
          astr = Split(objPlaylist.Playlist, vbCrLf)
          Dim nLoop As Integer
          For nLoop = LBound(astr) To UBound(astr)
            sFilename = GetFilenameFromFullPath(astr(nLoop))
            If Not APIFileCopy(astr(nLoop), sNewPath & "\" & sFilename, True) Then
              MsgBox "Unable to move " & sFilename & ".", vbOKOnly + vbCritical, "Copy Error"
            Else
              lvMP3s.ListItems.Item(astr(nLoop)).Text = sNewPath & "\" & sFilename
              lvMP3s.ListItems.Item(astr(nLoop)).Key = sNewPath & "\" & sFilename
              Kill astr(nLoop)
            End If
          Next nLoop
        End If
      End If
    Case "playlists"
      If Not tvPlaylists.SelectedItem Is Nothing Then
        Dim sKey As String
        sKey = tvPlaylists.SelectedItem.Key
        If IsTreeViewPlaylist(sKey) Then
          Set objPlaylist = New clsPlaylist
          objPlaylist.InitFromTreeViewNode tvPlaylists.SelectedItem
          sFilename = GetFilenameFromFullPath(objPlaylist.FullPath)
          Set objDirectoryChooser = New clsDirectoryChooser
          sNewPath = objDirectoryChooser.GetDirectory(Me)
          If Len(sNewPath) > 0 Then
            If Not APIFileCopy(objPlaylist.FullPath, sNewPath & "\" & sFilename, True) Then
              MsgBox "Unable to move " & sFilename & ".", vbOKOnly + vbCritical, "Rename Error"
            Else
              tvPlaylists.SelectedItem.Text = sNewPath & "\" & sFilename
              tvPlaylists.SelectedItem.Key = sNewPath & "\" & sFilename
              Kill objPlaylist.FullPath
            End If
          End If
        Else 'they have a child song of a playlist selected
          Dim frmNew As frmPlaylistPicker
          Set frmNew = New frmPlaylistPicker
          sFilename = frmPlaylistPicker.ShowPlaylists(tvPlaylists, Me)
          If Len(sFilename) > 0 Then
            Dim sParentKey As String
            sParentKey = ExtractPlaylistFilenameFromTreeNodeChildKey(sKey)
            Dim sSongToMove As String
            sSongToMove = ExtractSongFilenameFromTreeNodeChildKey(sKey)
            Dim ndParent As Node
            Set ndParent = tvPlaylists.Nodes.Item(sFilename)
            'save it into the new playlist
            Set objPlaylist = New clsPlaylist
            objPlaylist.InitFromTreeViewNode ndParent
            objPlaylist.Playlist = objPlaylist.Playlist & sSongToMove
            objPlaylist.Save
            'and add it to the playlist it was added to in the treeview
            tvPlaylists.Nodes.Add Relative:=ndParent, Relationship:=tvwChild, Key:=sFilename & "|" & sSongToMove, Text:=sSongToMove
            'remove the song from the old playlist in the treeview
            tvPlaylists.Nodes.Remove sKey
            Set ndParent = tvPlaylists.Nodes.Item(sParentKey)
            'and then save it without that key present to remove it from the playlist
            objPlaylist.InitFromTreeViewNode ndParent
            objPlaylist.Save
          End If
        End If
      End If
  End Select
End Sub
Private Sub cmdCopy_Click()
  Dim sNewPath As String
  Dim sFilename As String
  Dim objPlaylist As clsPlaylist
  Dim objDirectoryChooser As clsDirectoryChooser
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
      If Not lvMP3s.SelectedItem Is Nothing Then
        Set objPlaylist = New clsPlaylist
        objPlaylist.InitFromListView lvMP3s
        Set objDirectoryChooser = New clsDirectoryChooser
        sNewPath = objDirectoryChooser.GetDirectory(Me)
        If Len(sNewPath) > 0 Then
          Dim astr() As String
          astr = Split(objPlaylist.Playlist, vbCrLf)
          Dim nLoop As Integer
          For nLoop = LBound(astr) To UBound(astr)
            sFilename = GetFilenameFromFullPath(astr(nLoop))
            If Not APIFileCopy(astr(nLoop), sNewPath & "\" & sFilename, True) Then
              MsgBox "Unable to move " & sFilename & ".", vbOKOnly + vbCritical, "Copy Error"
            Else
              'this is copy so we don't change the keys or text nor do we kill
              'lvMP3s.ListItems.Item(astr(nLoop)).Text = sNewPath & "\" & sFilename
              'lvMP3s.ListItems.Item(astr(nLoop)).Key = sNewPath & "\" & sFilename
              'Kill astr(nLoop)
            End If
          Next nLoop
        End If
      End If
    Case "playlists"
      If Not tvPlaylists.SelectedItem Is Nothing Then
        Dim sKey As String
        sKey = tvPlaylists.SelectedItem.Key
        If IsTreeViewPlaylist(sKey) Then
          Set objPlaylist = New clsPlaylist
          objPlaylist.InitFromTreeViewNode tvPlaylists.SelectedItem
          sFilename = GetFilenameFromFullPath(objPlaylist.FullPath)
          Set objDirectoryChooser = New clsDirectoryChooser
          sNewPath = objDirectoryChooser.GetDirectory(Me)
          If Len(sNewPath) > 0 Then
            If Not APIFileCopy(objPlaylist.FullPath, sNewPath & "\" & sFilename, True) Then
              MsgBox "Unable to move " & sFilename & ".", vbOKOnly + vbCritical, "Rename Error"
            Else
              tvPlaylists.SelectedItem.Text = sNewPath & "\" & sFilename
              tvPlaylists.SelectedItem.Key = sNewPath & "\" & sFilename
              Kill objPlaylist.FullPath
            End If
          End If
        Else 'they have a child song of a playlist selected
          Dim frmNew As frmPlaylistPicker
          Set frmNew = New frmPlaylistPicker
          sFilename = frmPlaylistPicker.ShowPlaylists(tvPlaylists, Me)
          If Len(sFilename) > 0 Then
            Dim sParentKey As String
            sParentKey = ExtractPlaylistFilenameFromTreeNodeChildKey(sKey)
            Dim sSongToCopy As String
            sSongToCopy = ExtractSongFilenameFromTreeNodeChildKey(sKey)
            Set objPlaylist = New clsPlaylist
            objPlaylist.InitFromFile sFilename
            objPlaylist.Playlist = objPlaylist.Playlist & sSongToCopy
            objPlaylist.Save
            'and add it to the playlist it was added to in the treeview
            Dim ndParent As Node
            Set ndParent = tvPlaylists.Nodes.Item(sFilename)
            tvPlaylists.Nodes.Add Relative:=ndParent, Relationship:=tvwChild, Key:=sFilename & "|" & sSongToCopy, Text:=sSongToCopy
          End If
        End If
      End If
  End Select
End Sub
Private Sub cmdDelete_Click()
  Dim nRet As VbMsgBoxResult
  Dim sFileList As String
  Dim objPlaylist As clsPlaylist
'  On Error GoTo ErrorTrap
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
      Set objPlaylist = New clsPlaylist
      objPlaylist.InitFromListView lvMP3s
      If objPlaylist.HasSongs Then
        nRet = MsgBox("Are you sure you want to delete the selected files?", vbYesNo + vbQuestion, "Delete?")
        If nRet = vbYes Then
          Dim astr() As String
          astr = Split(objPlaylist.Playlist, vbCrLf)
          Dim nLoop As Integer
          For nLoop = LBound(astr) To UBound(astr)
            Kill astr(nLoop)
            lvMP3s.ListItems.Remove astr(nLoop)
          Next nLoop
        End If
      End If
    Case "playlists"
      If Not tvPlaylists.SelectedItem Is Nothing Then
      Dim sKey As String
      sKey = tvPlaylists.SelectedItem.Key
      If IsTreeViewPlaylist(sKey) Then
        Set objPlaylist = New clsPlaylist
        objPlaylist.InitFromTreeViewNode tvPlaylists.SelectedItem
        nRet = MsgBox("Are you sure you want to delete the selected playlist?", vbYesNo + vbQuestion, "Delete?")
        If nRet = vbYes Then
          Kill objPlaylist.FullPath
          tvPlaylists.Nodes.Remove objPlaylist.FullPath
        End If
      Else 'they have an individual song selected
        nRet = MsgBox("Are you sure you want to delete the selected song from the playlist?", vbYesNo + vbQuestion, "Delete?")
        If nRet = vbYes Then
          'remove it from the tree view
          tvPlaylists.Nodes.Remove sKey
          Dim sParentKey As String
          sParentKey = ExtractPlaylistFilenameFromTreeNodeChildKey(sKey)
          Set objPlaylist = New clsPlaylist
          objPlaylist.InitFromTreeViewNode tvPlaylists.Nodes.Item(sParentKey)
          objPlaylist.Save
        End If
      End If
    End If
  End Select
  Exit Sub
ErrorTrap:
  MsgBox Err.Description, vbCritical, "Error:  " & Err.Number
End Sub
Private Sub tbsMain_Click()
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
      lvMP3s.ZOrder 0
      cmdSaveAsPlaylist.Enabled = True
    Case "playlists"
      tvPlaylists.ZOrder 0
      cmdSaveAsPlaylist.Enabled = False
  End Select
End Sub
Private Sub Delete_Click()
  MsgBox "Not Implemented"
End Sub
Private Sub Form_Initialize()
  Dim objWindowPosition As clsWindowPosition
  Dim sBaseDirectory As String
  Dim sLimitSearchDepth As String
  Dim sMaxSearchDepth As String
  Dim sTrackResolution As String
  Set objWindowPosition = New clsWindowPosition
  objWindowPosition.AppName = "djbsMP3s"
  objWindowPosition.PositionWindow Me
  sBaseDirectory = objWindowPosition.RetrieveCustom("BaseDirectory")
  If Len(sBaseDirectory) Then sbMain.Panels.Item("directory").Text = sBaseDirectory
  sMaxSearchDepth = objWindowPosition.RetrieveCustom("MaxSearchDepth")
  sTrackResolution = objWindowPosition.RetrieveCustom("TrackResolution")
  If Len(sMaxSearchDepth) > 0 Then
    sbMain.Panels.Item("searchdepth").Text = sMaxSearchDepth
  Else
    sbMain.Panels.Item("searchdepth").Text = "unlimited"
  End If
  SetUpGenres
  Dim ch As ColumnHeader
  Set ch = lvMP3s.ColumnHeaders.Add(, "filename", "Filename")
  Set ch = lvMP3s.ColumnHeaders.Add(, "directory", "Directory")
  Set ch = lvMP3s.ColumnHeaders.Add(, "title", "Title")
  Set ch = lvMP3s.ColumnHeaders.Add(, "artist", "Artist")
  Set ch = lvMP3s.ColumnHeaders.Add(, "album", "Album")
  Set ch = lvMP3s.ColumnHeaders.Add(, "year", "Year")
  Set ch = lvMP3s.ColumnHeaders.Add(, "comment", "Comment")
  Set ch = lvMP3s.ColumnHeaders.Add(, "genre", "Genre")
  Set ch = lvMP3s.ColumnHeaders.Add(, "size", "Size")
  Set ch = lvMP3s.ColumnHeaders.Add(, "audioversion", "Audio Version")
  Set ch = lvMP3s.ColumnHeaders.Add(, "layerdescription", "Layer Desc.")
  Set ch = lvMP3s.ColumnHeaders.Add(, "protection", "Protection")
  Set ch = lvMP3s.ColumnHeaders.Add(, "bitrate", "Bitrate")
  Set ch = lvMP3s.ColumnHeaders.Add(, "frequency", "Frequency")
  Set ch = lvMP3s.ColumnHeaders.Add(, "padding", "Padding")
  Set ch = lvMP3s.ColumnHeaders.Add(, "channelmode", "Channel Mode")
  Set ch = lvMP3s.ColumnHeaders.Add(, "intensitystereo", "Intensity Stereo")
  Set ch = lvMP3s.ColumnHeaders.Add(, "msstereo", "MS Stereo")
  Set ch = lvMP3s.ColumnHeaders.Add(, "copyright", "Copyright")
  Set ch = lvMP3s.ColumnHeaders.Add(, "original", "Original")
  Set ch = lvMP3s.ColumnHeaders.Add(, "emphasis", "Emphasis")
  Set ch = Nothing
  Dim sPos As String
  Dim sWidth As String
  For Each ch In lvMP3s.ColumnHeaders
    sPos = objWindowPosition.RetrieveCustom(ch.Key & "pos")
    sWidth = objWindowPosition.RetrieveCustom(ch.Key & "width")
    If IsInteger(sPos) Then
      ch.Position = CInt(sPos)
    End If
    If IsInteger(sWidth) Then
      ch.Width = CInt(sWidth)
    End If
  Next ch
End Sub
Private Sub Form_Resize()
  Dim lNewlstMP3sHeight As Long
  Dim lWidth As Long
  lvMP3s.Top = TOP_BORDER_HEIGHT
  tvPlaylists.Top = TOP_BORDER_HEIGHT
  lvMP3s.Left = 0
  tvPlaylists.Left = 0
  lWidth = Me.ScaleWidth
  lvMP3s.Width = lWidth
  tvPlaylists.Width = lWidth
  tbsMain.Width = lWidth
  lNewlstMP3sHeight = Me.ScaleHeight - TOP_BORDER_HEIGHT - sbMain.Height
  If lNewlstMP3sHeight > 0 Then
    lvMP3s.Height = lNewlstMP3sHeight
    tvPlaylists.Height = lNewlstMP3sHeight
  End If
End Sub
Private Sub Form_Unload(Cancel As Integer)
  Dim objWindowPosition As clsWindowPosition
  Set objWindowPosition = New clsWindowPosition
  objWindowPosition.AppName = "djbsMP3s"
  objWindowPosition.SavePosition Me
  objWindowPosition.SaveCustom "BaseDirectory", sbMain.Panels.Item("directory").Text
  objWindowPosition.SaveCustom "MaxSearchDepth", sbMain.Panels.Item("searchdepth").Text
  Dim ch As ColumnHeader
  For Each ch In lvMP3s.ColumnHeaders
    objWindowPosition.SaveCustom ch.Key & "pos", ch.Position
    objWindowPosition.SaveCustom ch.Key & "width", ch.Width
  Next ch
End Sub
Private Sub lvMP3s_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
  If lvMP3s.SortKey = ColumnHeader.Index - 1 Then
    If lvMP3s.SortOrder = lvwAscending Then
      lvMP3s.SortOrder = lvwDescending
    Else
      lvMP3s.SortOrder = lvwAscending
    End If
  Else
    lvMP3s.SortKey = ColumnHeader.Index - 1
    lvMP3s.Sorted = True
  End If
End Sub
Private Sub lvMP3s_DblClick()
  cmdPlaySelected_Click
End Sub
Private Sub objFileSearch_DirectoryChange(sDirectory As String)
  sbMain.Panels.Item("directory").Text = "Searching:  " & sDirectory
End Sub
Private Sub objFileSearch_FileFound(sDirectory As String, sFilename As String)
  Dim sParentDirectory As String
  Dim nLeftSlash As Integer
  Dim nRightSlash As Integer
  Dim objMP3Info As clsMP3Info
  Select Case tbsMain.SelectedItem.Key
    Case "mp3s"
      'trial version
      If lvMP3s.ListItems.Count >= 30 Then Exit Sub
      Dim li As ListItem
      Dim si As ListSubItem
      On Error Resume Next
      Set li = lvMP3s.ListItems.Add(lvMP3s.ListItems.Count + 1, sDirectory & sFilename, sFilename)
      If Err.Number = 35602 Then
        On Error GoTo 0
        'skip this item, already in the list
      Else
        On Error GoTo 0
        Set si = li.ListSubItems.Add(, "directory", sDirectory)
        Set objMP3Info = New clsMP3Info
        objMP3Info.init sDirectory & sFilename
        If objMP3Info.HasTag Then
          Set si = li.ListSubItems.Add(, "title", objMP3Info.Title)
          Set si = li.ListSubItems.Add(, "artist", objMP3Info.Artist)
          Set si = li.ListSubItems.Add(, "album", objMP3Info.Album)
          Set si = li.ListSubItems.Add(, "year", objMP3Info.Year)
          Set si = li.ListSubItems.Add(, "comment", objMP3Info.Comment)
          Set si = li.ListSubItems.Add(, "genre", objMP3Info.GenreString)
        Else
          Set si = li.ListSubItems.Add(, "title", "")
          Set si = li.ListSubItems.Add(, "artist", "")
          Set si = li.ListSubItems.Add(, "album", "")
          Set si = li.ListSubItems.Add(, "year", "")
          Set si = li.ListSubItems.Add(, "comment", "")
          Set si = li.ListSubItems.Add(, "genre", "")
        End If
        Set si = li.ListSubItems.Add(, "size", objMP3Info.Size)
        Set si = li.ListSubItems.Add(, "audioversion", objMP3Info.Version)
        Set si = li.ListSubItems.Add(, "layerdescription", objMP3Info.LayerDescription)
        Set si = li.ListSubItems.Add(, "protection", objMP3Info.ProtectionBit)
        Set si = li.ListSubItems.Add(, "bitrate", objMP3Info.Bitrate)
        Set si = li.ListSubItems.Add(, "frequency", objMP3Info.Frequency)
        Set si = li.ListSubItems.Add(, "padding", YesNo(objMP3Info.IsPadded))
        Set si = li.ListSubItems.Add(, "channelmode", objMP3Info.ChannelMode)
        Set si = li.ListSubItems.Add(, "intensitystereo", YesNo(objMP3Info.IntensityStereo))
        Set si = li.ListSubItems.Add(, "msstereo", YesNo(objMP3Info.MSStereo))
        Set si = li.ListSubItems.Add(, "copyright", YesNo(objMP3Info.Copyrighted))
        Set si = li.ListSubItems.Add(, "original", YesNo(objMP3Info.OriginalMedia))
        Set si = li.ListSubItems.Add(, "emphasis", objMP3Info.Emphasis)
      End If
    Case "playlists"
      'trial version
      If tvPlaylists.Nodes.Count >= 30 Then Exit Sub
      Dim tn As Node
      On Error Resume Next
      Set tn = tvPlaylists.Nodes.Add(Key:=sDirectory & sFilename, Text:=sDirectory & sFilename)
      If Err.Number = 35602 Then
        On Error GoTo 0
        'skip this item, already in treeview
      Else
        On Error GoTo 0
        'read the files from the playlist and populate as child nodes
        Dim hFile As Integer
        Dim sLine As String
        hFile = FreeFile
        Open sDirectory & sFilename For Input As hFile
        While Not EOF(hFile)
          Line Input #hFile, sLine
          Set tn = tvPlaylists.Nodes.Add(Relative:=sDirectory & sFilename, Relationship:=tvwChild, Text:=sLine, Key:=sDirectory & sFilename & "|" & sLine)
        Wend
        Close hFile
      End If
  End Select
End Sub
Private Sub sbMain_PanelDblClick(ByVal Panel As MSComctlLib.Panel)
  Select Case Panel.Key
    Case "directory"
      Dim objDirectoryChooser As clsDirectoryChooser
      Dim sPath As String
      Set objDirectoryChooser = New clsDirectoryChooser
      sPath = objDirectoryChooser.GetDirectory(Me)
      If Len(sPath) > 0 Then
        sbMain.Panels.Item("directory").Text = sPath
      End If
    Case "searchdepth"
      Dim frmNew As frmSearchDepth
      Dim sSearchDepth As String
      Set frmNew = New frmSearchDepth
      sSearchDepth = sbMain.Panels.Item("searchdepth").Text
      If frmNew.ShowSearchDepth(sSearchDepth, Me) Then
        sbMain.Panels.Item("searchdepth").Text = sSearchDepth
      End If
  End Select
End Sub
