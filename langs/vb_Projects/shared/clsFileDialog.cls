VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsFileDialog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Const cdlOFNOverwritePrompt = &H2
Private Const cdlOFNPathMustExist = &H800
Private Const cdlOFNHideReadOnly = &H4
Private Const MAX_PATH = 256
Private Type OPENFILENAME
        lStructSize As Long
        hwndOwner As Long
        hInstance As Long
        lpstrFilter As String
        lpstrCustomFilter As String
        nMaxCustFilter As Long
        nFilterIndex As Long
        lpstrFile As String
        nMaxFile As Long
        lpstrFileTitle As String
        nMaxFileTitle As Long
        lpstrInitialDir As String
        lpstrTitle As String
        flags As Long
        nFileOffset As Integer
        nFileExtension As Integer
        lpstrDefExt As String
        lCustData As Long
        lpfnHook As Long
        lpTemplateName As String
End Type
Private Declare Function GetSaveFileName Lib "comdlg32.dll" Alias "GetSaveFileNameA" (pOpenfilename As OPENFILENAME) As Long
Private Declare Function APIGetOpenFileName Lib "comdlg32.dll" Alias "GetOpenFileNameA" (pOpenfilename As OPENFILENAME) As Long
Public Function GetSaveAsFileName(hwnd As Long, sFilters As String, nFilterIndex As Integer, sDefaultFileName As String, sDefaultExt As String, sTitle As String) As String
  Dim ofn As OPENFILENAME
  Dim lRet As Long
  With ofn
    .lStructSize = Len(ofn)
    .hwndOwner = hwnd
    .lpstrFilter = sFilters
    .nFilterIndex = nFilterIndex
    .lpstrDefExt = sDefaultExt
    .flags = cdlOFNOverwritePrompt Or cdlOFNPathMustExist Or cdlOFNHideReadOnly
    .lpstrTitle = sTitle
    .nMaxFile = MAX_PATH
    .lpstrFile = VBToAPIStr(sDefaultFileName, MAX_PATH)
    .lpstrInitialDir = ""
  End With
  lRet = GetSaveFileName(ofn)
  If lRet Then
    GetSaveAsFileName = APIToVBStr(ofn.lpstrFile)
  Else
    GetSaveAsFileName = ""
  End If
End Function
Public Function GetOpenFileName(hwnd As Long, sFilters As String, nFilterIndex As Integer, sDefaultFileName As String, sDefaultExt As String, sTitle As String, sInitialDirectory As String) As String
  Dim ofn As OPENFILENAME
  Dim lRet As Long
  With ofn
    .lStructSize = Len(ofn)
    .hwndOwner = hwnd
    .lpstrFilter = sFilters
    .nFilterIndex = nFilterIndex
    .lpstrDefExt = sDefaultExt
    .flags = cdlOFNOverwritePrompt Or cdlOFNPathMustExist Or cdlOFNHideReadOnly
    .lpstrTitle = sTitle
    .nMaxFile = MAX_PATH
    .lpstrFile = VBToAPIStr(sDefaultFileName, MAX_PATH)
    .lpstrInitialDir = VBToAPIStr(sInitialDirectory, MAX_PATH)
  End With
  lRet = APIGetOpenFileName(ofn)
  If lRet Then
    GetOpenFileName = APIToVBStr(ofn.lpstrFile)
  Else
    GetOpenFileName = ""
  End If
End Function
