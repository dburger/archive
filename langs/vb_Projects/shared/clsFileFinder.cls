VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFileFinder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'constants
Private Const INVALID_HANDLE_VALUE = -1
Private Const ERROR_NO_MORE_FILES = 18&
Private Const FILE_ATTRIBUTE_DIRECTORY = &H10
'types
Private Type FILETIME
        dwLowDateTime As Long
        dwHighDateTime As Long
End Type
Private Type WIN32_FIND_DATA
        dwFileAttributes As Long
        ftCreationTime As FILETIME
        ftLastAccessTime As FILETIME
        ftLastWriteTime As FILETIME
        nFileSizeHigh As Long
        nFileSizeLow As Long
        dwReserved0 As Long
        dwReserved1 As Long
        cFileName As String * MAX_PATH
        cAlternate As String * 14
End Type
'api calls
Private Declare Function FindFirstFile Lib "kernel32" Alias "FindFirstFileA" (ByVal lpFileName As String, lpFindFileData As WIN32_FIND_DATA) As Long
Private Declare Function FindNextFile Lib "kernel32" Alias "FindNextFileA" (ByVal hFindFile As Long, lpFindFileData As WIN32_FIND_DATA) As Long
Private Declare Function FindClose Lib "kernel32" (ByVal hFindFile As Long) As Long
Private Declare Function GetLastError Lib "kernel32" () As Long
'class events
Public Event FileFound(sDirectory As String, sFilename As String)
Public Event DirectoryChange(sDirectory As String)
'Public Sub FindFilesRecursive(sDirectory As String, sFilter As String, bSearchSubfolders As Boolean)
'clean sub, but can't control depth so dangerous
'may overflow the stack
'  Dim hSearch As Long
'  Dim lRet As Long
'  Dim uWFD As WIN32_FIND_DATA
'  Dim sFilename As String
'  Dim sExtensionMatch As String
'  'to make this robust, sFilter should be checked to...
'  'contain only one period
'  'contain text after the period
'  'and probably more
'  sExtensionMatch = Right$(sFilter, Len(sFilter) - InStr(1, sFilter, "."))
'  If Right$(sDirectory, 1) <> "\" Then sDirectory = sDirectory & "\"
'  RaiseEvent DirectoryChange(sDirectory)
'  If bSearchSubfolders Then
'    hSearch = FindFirstFile(sDirectory & "*.*", uWFD)
'  Else
'    'no need return everything if we aren't going to look in
'    'subdirectories
'    hSearch = FindFirstFile(sDirectory & sFilter, uWFD)
'  End If
'  Do Until hSearch = INVALID_HANDLE_VALUE
'    sFilename = APIToVBStr(uWFD.cFileName)
'    If Right$(sFilename, 3) = sExtensionMatch Or sExtensionMatch = "*" Then RaiseEvent FileFound(sDirectory, sFilename)
'    If (uWFD.dwFileAttributes And FILE_ATTRIBUTE_DIRECTORY) And (sFilename <> ".") And (sFilename <> "..") Then
'      Me.FindFilesRecursive sDirectory & sFilename, sFilter, bSearchSubfolders
'    End If
'    lRet = FindNextFile(hSearch, uWFD)
'    'GetLastError = ERROR_NO_MORE_FILES just not working
'    'this does
'    If lRet = 0 Then Exit Do
'  Loop
'  lRet = FindClose(hSearch)
'End Sub
Public Sub FindFilesNonRecursive(sDirectory As String, sFilter As String, nMaxDepth As Integer)
  '-1 is the sentinel that indicates no max depth is being specified
  'we will say this goes no deeper than 100 subdirectories
  If nMaxDepth = -1 Then nMaxDepth = 100
  ReDim ahSearch(nMaxDepth) As Long
  Dim npSearchIndex As Integer
  Dim lRet As Long
  Dim uWFD As WIN32_FIND_DATA
  Dim sFilename As String
  Dim sExtensionMatch As String
  'to make this robust, sFilter should be checked to...
  'contain only one period
  'contain text after the period
  'and probably more
  sExtensionMatch = Right$(sFilter, Len(sFilter) - InStr(1, sFilter, "."))
  If Right$(sDirectory, 1) <> "\" Then sDirectory = sDirectory & "\"
  RaiseEvent DirectoryChange(sDirectory)
  ahSearch(npSearchIndex) = FindFirstFile(sDirectory & "*.*", uWFD)
  If ahSearch(npSearchIndex) = INVALID_HANDLE_VALUE Then Exit Sub
  Do Until npSearchIndex = -1
    sFilename = APIToVBStr(uWFD.cFileName)
    If Right$(sFilename, 3) = sExtensionMatch Or sExtensionMatch = "*" Then RaiseEvent FileFound(sDirectory, sFilename)
    If (uWFD.dwFileAttributes And FILE_ATTRIBUTE_DIRECTORY) And (sFilename <> ".") And (sFilename <> "..") And (npSearchIndex < nMaxDepth) Then
      'right after we find a directory we always get . and .. so no need
      'to check if this fails
      npSearchIndex = npSearchIndex + 1
      sDirectory = sDirectory & sFilename & "\"
      RaiseEvent DirectoryChange(sDirectory)
      ahSearch(npSearchIndex) = FindFirstFile(sDirectory & "*.*", uWFD)
    Else
      lRet = FindNextFile(ahSearch(npSearchIndex), uWFD)
      'GetLastError = ERROR_NO_MORE_FILES just not working
      'this does
      If lRet = 0 Then
        Do Until lRet <> 0
          lRet = FindClose(ahSearch(npSearchIndex))
          npSearchIndex = npSearchIndex - 1
          If npSearchIndex = -1 Then
            Exit Do
          Else
            sDirectory = Left$(sDirectory, InStrRev(sDirectory, "\", Len(sDirectory) - 1))
          End If
          lRet = FindNextFile(ahSearch(npSearchIndex), uWFD)
        Loop
      End If
    End If
  Loop
End Sub
