Attribute VB_Name = "basSubclassing"
Option Explicit
Public Const GWL_WNDPROC = (-4)
Public ghPrevWinProc As Long
Public Const WM_NCLBUTTONDOWN = &HA1
Public Declare Function CallWindowProc Lib "user32" Alias "CallWindowProcA" (ByVal lpPrevWndFunc As Long, ByVal hWnd As Long, ByVal Msg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
Public Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
Public Function MyWinProc(ByVal hw As Long, ByVal uMsg As Long, ByVal wParam As Long, ByVal lParam As Long) As Long
'just to see if I am getting anything
  MsgBox "Caught it"
'  Select Case uMsg
'    Case WM_NCLBUTTONDOWN
'      MsgBox "got it"
'  End Select
  'call the windows real winproc
  MyWinProc = CallWindowProc(ghPrevWinProc, hw, uMsg, wParam, lParam)
End Function
Public Sub StartSubClassing(hWnd As Long)
  ghPrevWinProc = SetWindowLong(hWnd, GWL_WNDPROC, AddressOf MyWinProc)
End Sub
Public Sub StopSubClassing(hWnd As Long)
  SetWindowLong hWnd, GWL_WNDPROC, ghPrevWinProc
End Sub
