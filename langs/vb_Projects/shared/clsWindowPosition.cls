VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsWindowPosition"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private msAppName As String
'startup position form forms must be set to manual
'in order for this object to work correctly
Public Property Let AppName(sAppName As String)
  'the users must call this sub before using the other
  'methods, this determines the key that will be used
  'to store the information
  msAppName = sAppName
End Property
Public Sub SavePosition(frm As Form)
  If frm.WindowState = vbMaximized Then
    SaveSetting msAppName, "WindowStatus", "Maximized", "True"
  ElseIf frm.WindowState = vbMinimized Then
    'don't save window state if minimized, it really messes it up
  Else
    SaveSetting msAppName, "WindowStatus", "Maximized", "False"
    SaveSetting msAppName, "WindowStatus", "Left", CStr(frm.Left)
    SaveSetting msAppName, "WindowStatus", "Top", CStr(frm.Top)
    SaveSetting msAppName, "WindowStatus", "Width", CStr(frm.Width)
    SaveSetting msAppName, "WindowStatus", "Height", CStr(frm.Height)
  End If
End Sub
Public Sub PositionWindow(frm As Form)
  'i am loading these in regardless of whether or not the window
  'is maximized because it may effect the restore position?
  frm.Left = CLng(GetSetting(msAppName, "WindowStatus", "Left", Screen.Width / 8))
  frm.Top = CLng(GetSetting(msAppName, "WindowStatus", "Top", Screen.Height / 8))
  frm.Width = CLng(GetSetting(msAppName, "WindowStatus", "Width", Screen.Width * 3 / 4))
  frm.Height = CLng(GetSetting(msAppName, "WindowStatus", "Height", Screen.Height * 3 / 4))
  If GetSetting(msAppName, "WindowStatus", "Maximized", "True") = "True" Then
    frm.WindowState = vbMaximized
  End If
End Sub
Public Function RetrieveCustom(sName As String) As String
  RetrieveCustom = CStr(GetSetting(msAppName, "WindowStatus", sName, ""))
End Function
Public Sub SaveCustom(sName As String, sValue As String)
  SaveSetting msAppName, "WindowStatus", sName, sValue
End Sub
