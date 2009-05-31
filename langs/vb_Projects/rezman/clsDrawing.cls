VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsDrawing"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'set to work with ScaleMode = Pixel
Private Const BF_LEFT = &H1
Private Const BF_TOP = &H2
Private Const BF_RIGHT = &H4
Private Const BF_BOTTOM = &H8
Private Const BF_RECT = (BF_LEFT Or BF_TOP Or BF_RIGHT Or BF_BOTTOM)

Private Const BDR_RAISEDINNER = &H4
Private Const BDR_RAISEDOUTER = &H1
Private Const EDGE_RAISED = (BDR_RAISEDOUTER Or BDR_RAISEDINNER)

Private Type TPoint
  X As Long
  Y As Long
End Type
Private Type TRect
  Left As Long
  Top As Long
  Right As Long
  Bottom As Long
End Type
Private Declare Function DrawEdgeAPI Lib "user32" Alias "DrawEdge" (ByVal hdc As Long, qrc As TRect, ByVal edge As Long, ByVal grfFlags As Long) As Long
Private Declare Function DrawFocusRectAPI Lib "user32" Alias "DrawFocusRect" (ByVal hdc As Long, lpRect As TRect) As Long
Private Declare Function GetWindowRect Lib "user32" (ByVal hwnd As Long, lpRect As TRect)
Private Declare Function GetDC Lib "user32" (ByVal hwnd As Long) As Long
Private Declare Function DPtoLP Lib "gdi32" (ByVal hdc As Long, lpPoint As TPoint, ByVal nCount As Long) As Long
Public Function DrawEdge(lbl As Label, prnt As Object)
  Dim lRes As Long
  Dim rct As TRect
  Dim dc As Long
  Dim aPoints(1) As TPoint
  aPoints(0).X = (lbl.Left / Screen.TwipsPerPixelX) - 2
  aPoints(0).Y = (lbl.Top / Screen.TwipsPerPixelY) - 2
  aPoints(1).X = ((lbl.Left + lbl.Width) / Screen.TwipsPerPixelX + 2)
  aPoints(1).Y = ((lbl.Top + lbl.Height) / Screen.TwipsPerPixelY + 2)
  dc = GetDC(prnt.hwnd)
  rct.Left = aPoints(0).X
  rct.Top = aPoints(0).Y
  rct.Right = aPoints(1).X
  rct.Bottom = aPoints(1).Y
  lRes = DrawEdgeAPI(dc, rct, EDGE_RAISED, BF_RECT)
End Function
Public Function DrawFocusRect(lbl As Label, prnt As Object)
  Dim lRes As Long
  Dim rct As TRect
  Dim dc As Long
  Dim aPoints(1) As TPoint
  aPoints(0).X = lbl.Left + 2
  aPoints(0).Y = lbl.Top + 2
  aPoints(1).X = lbl.Left + lbl.Width - 2
  aPoints(1).Y = lbl.Top + lbl.Height - 2
  dc = GetDC(prnt.hwnd)
  rct.Left = aPoints(0).X
  rct.Top = aPoints(0).Y
  rct.Right = aPoints(1).X
  rct.Bottom = aPoints(1).Y
  lRes = DrawFocusRectAPI(dc, rct)
End Function
