VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsPlaylist"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private msFullPath As String
Private msPlaylist As String
Private Const SONG_DELIM = vbCrLf
Public Sub InitFromFile(sFullPath As String)
  Dim hFile As Integer
  Dim sLine As String
  msPlaylist = ""
  msFullPath = sFullPath
  hFile = FreeFile
  Open sFullPath For Input As hFile
  While Not EOF(hFile)
    Line Input #hFile, sLine
    msPlaylist = msPlaylist & sLine & SONG_DELIM
  Wend
  Close hFile
  If Len(msPlaylist) > 0 Then
    msPlaylist = Left$(msPlaylist, Len(msPlaylist) - Len(SONG_DELIM))
  End If
End Sub
Public Sub InitFromTreeViewNode(ndParent As Node)
  Dim ndChild As Node
  msPlaylist = ""
  msFullPath = ndParent.Key
  Set ndChild = ndParent.Child
  Do
    msPlaylist = msPlaylist & ExtractSongFilenameFromTreeNodeChildKey(ndChild.Key) & SONG_DELIM
    Set ndChild = ndChild.Next
  Loop While Not ndChild Is Nothing
  If Len(msPlaylist) > 0 Then msPlaylist = Left$(msPlaylist, Len(msPlaylist) - Len(SONG_DELIM))
End Sub
Public Sub InitFromListView(lv As ListView)
  Dim li As ListItem
  msPlaylist = ""
  For Each li In lv.ListItems
    If li.Selected Then msPlaylist = msPlaylist & li.Key & SONG_DELIM
  Next li
  If Len(msPlaylist) > 0 Then
    msPlaylist = Left$(msPlaylist, Len(msPlaylist) - Len(SONG_DELIM))
  End If
End Sub
Public Property Let FullPath(sFullPath As String)
  msFullPath = sFullPath
End Property
Public Property Get FullPath() As String
  FullPath = msFullPath
End Property
Public Property Let Playlist(sPlaylist As String)
  msPlaylist = sPlaylist
End Property
Public Property Get Playlist() As String
  Playlist = msPlaylist
End Property
Public Sub Save()
  Dim hFile As Integer
  hFile = FreeFile
  Open msFullPath For Output As hFile
  Print #hFile, msPlaylist
  Close hFile
End Sub
Public Sub Play()
  If Len(msFullPath) = 0 Then 'never been saved...use a temp file if necessary
    If MoreThanOneSong Then
      msFullPath = App.Path & "\temp.m3u"
      Save
      LaunchAppByAssociation 0, msFullPath, ""
      'clear the filename back, this has never been saved
      msFullPath = ""
    Else
      LaunchAppByAssociation 0, msPlaylist, ""
    End If
  Else 'play the file
    LaunchAppByAssociation 0, msFullPath, ""
  End If
End Sub
Public Function MoreThanOneSong() As Boolean
  Dim nFoundPos As String
  nFoundPos = InStr(1, msPlaylist, SONG_DELIM)
  MoreThanOneSong = nFoundPos > 0
End Function
Public Function HasSongs() As Boolean
  HasSongs = Len(msPlaylist) > 0
End Function
