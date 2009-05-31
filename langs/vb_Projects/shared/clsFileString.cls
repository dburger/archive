VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFileString"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private msPathAndFileName As String
Private mobjFileSystem As FileSystemObject

Public Property Get PathAndFileName() As String
  PathAndFileName = msPathAndFileName
End Property
Public Property Let PathAndFileName(sPathAndFileName As String)
  msPathAndFileName = sPathAndFileName
End Property
Public Function StripFileName() As String
  Dim nLastSlash As Integer
  nLastSlash = InStrRev(msPathAndFileName, "\")
  StripFileName = Left$(msPathAndFileName, nLastSlash - 1)
End Function
Public Function FileExtension() As String
  Dim nPeriodLocation As Integer
  nPeriodLocation = InStrRev(msPathAndFileName, ".")
  FileExtension = Mid$(msPathAndFileName, nPeriodLocation + 1)
End Function
Public Function ParsePath() As String()
  ParsePath = Split(msPathAndFileName, "\")
End Function
Public Function CompressPath() As String
  Dim sArray() As String
  Dim sNewArray(3) As String
  Dim nElementsInPath As Integer
  sArray = Me.ParsePath
  nElementsInPath = UBound(sArray)
  If nElementsInPath > 2 Then
    sNewArray(0) = sArray(0)
    sNewArray(1) = sArray(1)
    sNewArray(2) = "..."
    sNewArray(3) = sArray(nElementsInPath)
    CompressPath = Join(sNewArray, "\")
  Else
    CompressPath = msPathAndFileName
  End If
End Function
Public Function FileExists() As Boolean
  FileExists = mobjFileSystem.FileExists(msPathAndFileName)
End Function
Public Function FolderExists() As Boolean
  FolderExists = mobjFileSystem.FolderExists(msPathAndFileName)
End Function
Public Function FileType() As String
  Dim fTemp As File
  If FileExists Then
    Set fTemp = mobjFileSystem.GetFile(msPathAndFileName)
    FileType = fTemp.Type
  End If
End Function
Public Function MakePath() As Boolean
  MakePath = MakeFolder(StripFileName)
  'need to write make folder
End Function

