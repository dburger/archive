VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsMP3Info"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private Type TFrameHeader
  b1 As Byte
  b2 As Byte
  b3 As Byte
  b4 As Byte
End Type

Private Type TID3
  Tag As String * 3
  Title As String * 30
  Artist As String * 30
  Album As String * 30
  Year As String * 4
  Comment As String * 30
  Genre As Byte
End Type

Private mid3 As TID3
Private mfh As TFrameHeader
Private msFilename As String
Private mlFileSize As Long
Private mbHasTag As Boolean
Public Sub init(sFilename As String)
  Dim hFile As Integer
  Dim lFileSize As Long
  Dim b1 As Byte
  Dim b2 As Byte
  On Error GoTo ErrorHandler
    msFilename = sFilename
    hFile = FreeFile
    Open msFilename For Binary Shared As hFile
    lFileSize = LOF(hFile)
    mlFileSize = lFileSize
    While b1 <> 255 And Not IsBitSet(b2, 7) And Not IsBitSet(b2, 6) And Not IsBitSet(b2, 5)
      Get hFile, , b1
      Get hFile, , b2
    Wend
    mfh.b1 = b1
    mfh.b2 = b2
    Get hFile, , mfh.b3
    Get hFile, , mfh.b4
    Seek hFile, mlFileSize - 127
    Get hFile, , mid3
    mbHasTag = mid3.Tag = "TAG"
    Close hFile
    Exit Sub
ErrorHandler:
  mbHasTag = False
End Sub
Public Property Get Filename() As String
  Filename = Trim$(msFilename)
End Property
Public Property Get HasTag() As Boolean
  HasTag = mbHasTag
End Property
Public Property Get Title() As String
  Title = Trim$(mid3.Title)
End Property
Public Property Get Artist() As String
  Artist = Trim$(mid3.Artist)
End Property
Public Property Get Album() As String
  Album = Trim$(mid3.Album)
End Property
Public Property Get Year() As String
  Year = Trim$(mid3.Year)
End Property
Public Property Get Comment() As String
  Comment = Trim$(mid3.Comment)
End Property
Public Property Get GenreByte() As Byte
  GenreByte = mid3.Genre
End Property
Public Property Get GenreString() As String
  GenreString = gasGenres(mid3.Genre)
End Property
Public Property Get Size() As Long
  Size = mlFileSize
  End Property
Public Function setTag(sFilename As String, sTitle As String, sArtist As String, sAlbum As String, sYear As String, sComment As String, nGenre As Integer) As Boolean
  Dim hFile As Integer
  Dim lFileSize As Long
  Dim lWriteLoc As Long
  Dim id3 As TID3
  On Error GoTo ErrorHandler
    id3.Tag = "TAG"
    id3.Title = sTitle
    id3.Artist = sArtist
    id3.Album = sAlbum
    id3.Year = sYear
    id3.Comment = sComment
    If nGenre = -1 Then
      'Unknown
      id3.Genre = 255
    Else
      id3.Genre = nGenre
    End If
    hFile = FreeFile
    Open sFilename For Binary Access Write As hFile
    lFileSize = LOF(hFile)
    If HasTag Then
      lWriteLoc = lFileSize - 127
    Else
      lWriteLoc = lFileSize + 1
    End If
    Put hFile, lWriteLoc, id3
    mid3 = id3
    mlFileSize = lWriteLoc + 127
    mbHasTag = True
    setTag = True
    Close hFile
    Exit Function
ErrorHandler:
  mbHasTag = False
  setTag = False
End Function
Public Function Version() As String
  If IsBitSet(mfh.b2, 4) Then
    If IsBitSet(mfh.b2, 3) Then
      Version = "MPEG Version 1"
    Else
      Version = "MPEG Version 2"
    End If
  Else
    If IsBitSet(mfh.b2, 3) Then
      Version = "reserved"
    Else
      Version = "MPEG Version 2.5"
    End If
  End If
End Function
Public Function LayerDescription() As String
  If IsBitSet(mfh.b2, 2) Then
    If IsBitSet(mfh.b2, 1) Then
      LayerDescription = "Layer 1"
    Else
      LayerDescription = "Layer 2"
    End If
  Else
    If IsBitSet(mfh.b2, 1) Then
      LayerDescription = "Layer 3"
    Else
      LayerDescription = "reserved"
    End If
  End If
End Function
Public Function ProtectionBit() As String
  If IsBitSet(mfh.b2, 0) Then
    ProtectionBit = "CRC"
  Else
    ProtectionBit = "Not protected"
  End If
End Function
Public Function Bitrate() As String
  Dim sVersion As String
  Dim sLayer As String
  sVersion = Version
  sLayer = LayerDescription
  If IsBitSet(mfh.b3, 7) Then '1???
    If IsBitSet(mfh.b3, 6) Then '11??
      If IsBitSet(mfh.b3, 5) Then '111?
        If IsBitSet(mfh.b3, 4) Then '1111
          Bitrate = "bad"
        Else '1110
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "448"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "384"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "320"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "448"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "384"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "320 (160)"
            End If
          End If
        End If
      Else '110?
        If IsBitSet(mfh.b3, 4) Then '1101
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "416"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "320"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "256"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "416"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "320"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "256 (144)"
            End If
          End If
        Else '1100
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "384"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "256"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "224"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "384"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "256"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "128 (128)"
            End If
          End If
        End If
      End If
    Else '10??
      If IsBitSet(mfh.b3, 5) Then '101?
        If IsBitSet(mfh.b3, 4) Then '1011
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "352"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "224"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "192"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "352"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "224"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "112 (112)"
            End If
          End If
        Else '1010
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "320"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "192"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "160"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "320"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "192"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "160 (96)"
            End If
          End If
        End If
      Else '100?
        If IsBitSet(mfh.b3, 4) Then '1001
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "288"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "160"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "128"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "288"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "160"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "128 (80)"
            End If
          End If
        Else '1000
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "256"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "128"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "112"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "256"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "128"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "64 (64)"
            End If
          End If
        End If
      End If
    End If
  Else '0???
    If IsBitSet(mfh.b3, 6) Then '01??
      If IsBitSet(mfh.b3, 5) Then '011?
        If IsBitSet(mfh.b3, 4) Then '0111
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "224"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "112"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "96"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "224"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "112"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "56 (56)"
            End If
          End If
        Else '0110
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "192"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "96"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "80"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "192"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "96"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "80 (48)"
            End If
          End If
        End If
      Else '010?
        If IsBitSet(mfh.b3, 4) Then '0101
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "160"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "80"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "64"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "160"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "80"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "64 (40)"
            End If
          End If
        Else '0100
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "128"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "64"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "56"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "128"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "64"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "32 (32)"
            End If
          End If
        End If
      End If
    Else '00??
      If IsBitSet(mfh.b3, 5) Then '001?
        If IsBitSet(mfh.b3, 4) Then '0011
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "96"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "56"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "48"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "96"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "56"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "24 (24)"
            End If
          End If
        Else '0010
          If sVersion = "MPEG Version 1" Then
            If sLayer = "Layer 1" Then
              Bitrate = "64"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "48"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "40"
            End If
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "64"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "48"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "16 (16)"
            End If
          End If
        End If
      Else '000?
        If IsBitSet(mfh.b3, 4) Then '0001
          If sVersion = "MPEG Version 1" Then
              Bitrate = "32"
          ElseIf sVersion = "MPEG Version 2" Or sVersion = "MPEG Version 2.5" Then
            If sLayer = "Layer 1" Then
              Bitrate = "32"
            ElseIf sLayer = "Layer 2" Then
              Bitrate = "32"
            ElseIf sLayer = "Layer 3" Then
              Bitrate = "8 (8)"
            End If
          End If
        Else '0000
          Bitrate = "free"
        End If
      End If
    End If
  End If
End Function
Public Function Frequency() As String
  Dim sVersion As String
  sVersion = Version
  If IsBitSet(mfh.b3, 3) Then '1?
    If IsBitSet(mfh.b3, 2) Then '11
      If sVersion = "MPEG Version 1" Then
        Frequency = "reserved"
      ElseIf sVersion = "MPEG Version 2" Then
        Frequency = "reserved"
      ElseIf sVersion = "MPEG Version 2.5" Then
        Frequency = "reserved"
      End If
    Else '10
      If sVersion = "MPEG Version 1" Then
        Frequency = "32000"
      ElseIf sVersion = "MPEG Version 2" Then
        Frequency = "16000"
      ElseIf sVersion = "MPEG Version 2.5" Then
        Frequency = "8000"
      End If
    End If
  Else '0?
    If IsBitSet(mfh.b3, 2) Then '01
      If sVersion = "MPEG Version 1" Then
        Frequency = "48000"
      ElseIf sVersion = "MPEG Version 2" Then
        Frequency = "24000"
      ElseIf sVersion = "MPEG Version 2.5" Then
        Frequency = "12000"
      End If
    Else '00
      If sVersion = "MPEG Version 1" Then
        Frequency = "44100"
      ElseIf sVersion = "MPEG Version 2" Then
        Frequency = "22050"
      ElseIf sVersion = "MPEG Version 2.5" Then
        Frequency = "11025"
      End If
    End If
  End If
End Function
Public Function IsPadded() As Boolean
  IsPadded = IsBitSet(mfh.b3, 1)
End Function
Public Function ChannelMode() As String
  If IsBitSet(mfh.b4, 7) Then '1?
    If IsBitSet(mfh.b4, 6) Then '11
      ChannelMode = "Single Channel (mono)"
    Else '10
      ChannelMode = "Dual Channel (stereo)"
    End If
  Else '0?
    If IsBitSet(mfh.b4, 6) Then '01
      ChannelMode = "Joint Stereo (stereo)"
    Else '00
      ChannelMode = "Stereo"
    End If
  End If
End Function
Public Function IntensityStereo() As Boolean
  If ChannelMode = "Joint Stereo (stereo)" Then
    If IsBitSet(mfh.b4, 5) Then '1?
      If IsBitSet(mfh.b4, 4) Then '11
        IntensityStereo = True
      Else '10
        IntensityStereo = False
      End If
    Else '0?
      If IsBitSet(mfh.b4, 4) Then '01
        IntensityStereo = True
      Else '00
        IntensityStereo = False
      End If
    End If
  Else
    IntensityStereo = False
  End If
End Function
Public Function MSStereo() As Boolean
  If ChannelMode = "Joint Stereo (stereo)" Then
    If IsBitSet(mfh.b4, 5) Then '1?
      If IsBitSet(mfh.b4, 4) Then '11
        MSStereo = True
      Else '10
        MSStereo = True
      End If
    Else '0?
      If IsBitSet(mfh.b4, 4) Then '01
        MSStereo = False
      Else '00
        MSStereo = False
      End If
    End If
  Else
    MSStereo = False
  End If
End Function
Public Function Copyrighted() As Boolean
  Copyrighted = IsBitSet(mfh.b4, 3)
End Function
Public Function OriginalMedia() As Boolean
  OriginalMedia = IsBitSet(mfh.b4, 2)
End Function
Public Function Emphasis() As String
  If IsBitSet(mfh.b4, 1) Then '1?
    If IsBitSet(mfh.b4, 0) Then '11
      Emphasis = "CCIT J.17"
    Else '10
      Emphasis = "reserved"
    End If
  Else '0?
    If IsBitSet(mfh.b4, 0) Then '01
      Emphasis = "50/15 ms"
    Else '00
      Emphasis = "none"
    End If
  End If
End Function
Public Function FrameSize() As Long
  Dim nPadSize As Integer
  If IsPadded Then nPadSize = 1
  FrameSize = 144 * Bitrate / Frequency + nPadSize
End Function
