Attribute VB_Name = "basFileRoutines"
Option Explicit
Public Declare Function GetTempFilenameAPI Lib "kernel32" Alias "GetTempFileNameA" (ByVal lpszPath As String, ByVal lpPrefixString As String, ByVal wUnique As Long, ByVal lpTempFileName As String) As Long
Public Declare Function GetTempPath Lib "kernel32" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Public Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Declare Function CopyFile Lib "kernel32" Alias "CopyFileA" (ByVal lpExistingFileName As String, ByVal lpNewFileName As String, ByVal bFailIfExists As Long) As Long
Public Function FileExists(sFilename As String) As Boolean
  If Len(sFilename) = 0 Or VBA.Right$(sFilename, 1) = "\" Then
    FileExists = False
    Exit Function
  End If
  FileExists = Len(Dir(sFilename)) > 0
End Function
Public Function APIFileCopy(sSource As String, sDestination As String, bFailIfDestExists As Boolean) As Boolean
  Dim lRet As Long
  lRet = CopyFile(sSource, sDestination, bFailIfDestExists)
  APIFileCopy = (lRet > 0)
End Function
Public Function GetTempFilename() As String
  'this function creates a temp file and returns the filename
  'it uses the system wide temp directory and a prefix of djb
  Dim sTempPath As String
  Dim sTempFilename As String
  Dim lRet As Long
  sTempPath = VBA.String$(255, 0)
  lRet = GetTempPath(Len(sTempPath) + 1, sTempPath)
  If lRet <> 0 Then
    sTempPath = VBA.Left$(sTempPath, lRet)
    sTempFilename = VBA.String$(255, 0)
    lRet = GetTempFilenameAPI(sTempPath, "djb", 0, sTempFilename)
    If lRet <> 0 Then
      GetTempFilename = APIToVBStr(sTempFilename)
    End If
  End If
End Function
Public Function GetTempFilenameExtended(sPath As String, sPrefix As String) As String
  'this function creates a temp file in sPath with prefix (3 chars only) of sPrefix
  'the name of the file is returned
  Dim sTempFilename As String
  Dim lRet As Long
  If lRet <> 0 Then
    sTempFilename = VBA.String$(255, 0)
    lRet = GetTempFilenameAPI(sPath, sPrefix, 0, sTempFilename)
    If lRet <> 0 Then
      GetTempFilenameExtended = APIToVBStr(sTempFilename)
    End If
  End If
End Function
Public Function GetFilenameFromFullPath(sFullPath As String) As String
  Dim nLastSlashPos As Integer
  nLastSlashPos = InStrRev(sFullPath, "\")
  GetFilenameFromFullPath = VBA.Right$(sFullPath, Len(sFullPath) - nLastSlashPos)
End Function
Public Function GetPathFromFullPath(sFullPath As String) As String
  Dim nLastSlash As Integer
  nLastSlash = InStrRev(sFullPath, "\")
  GetPathFromFullPath = VBA.Left$(sFullPath, nLastSlash - 1)
End Function
