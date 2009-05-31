VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4185
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   4185
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox txtWindowTitle 
      Height          =   375
      Left            =   1350
      TabIndex        =   4
      Top             =   360
      Width           =   3255
   End
   Begin VB.CommandButton cmdQuitSubclassing 
      Caption         =   "Quit Subclassing"
      Height          =   510
      Left            =   3510
      TabIndex        =   3
      Top             =   3600
      Width           =   1140
   End
   Begin VB.CommandButton cmdStartSubclassing 
      Caption         =   "Start Subclassing"
      Height          =   510
      Left            =   1350
      TabIndex        =   2
      Top             =   3600
      Width           =   1095
   End
   Begin VB.ListBox lstChildren 
      Height          =   2400
      Left            =   1350
      TabIndex        =   1
      Top             =   1125
      Width           =   3300
   End
   Begin VB.CommandButton cmdGetChildren 
      Caption         =   "Get Children"
      Height          =   510
      Left            =   45
      TabIndex        =   0
      Top             =   135
      Width           =   1185
   End
   Begin VB.Label lblChildren 
      Caption         =   "Children:"
      Height          =   285
      Left            =   1395
      TabIndex        =   6
      Top             =   810
      Width           =   1185
   End
   Begin VB.Label lblWindowTitle 
      Caption         =   "Window Title:"
      Height          =   285
      Left            =   1350
      TabIndex        =   5
      Top             =   90
      Width           =   1185
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function FindWindowEx Lib "user32" Alias "FindWindowExA" (ByVal hWnd1 As Long, ByVal hWnd2 As Long, ByVal lpsz1 As String, ByVal lpsz2 As String) As Long
Private Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
Private Declare Function GetClassName Lib "user32" Alias "GetClassNameA" (ByVal hwnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long
Private mhOldWinProc As Long
Private Function GetWndClass(hwnd As Long) As String
  Dim k As Long, sName As String
  sName = Space$(128)
  k = GetClassName(hwnd, sName, 128)
  If k > 0 Then sName = Left$(sName, k) Else sName = "No class"
  GetWndClass = sName
End Function

Private Function GetWndText(hwnd As Long) As String
  Dim k As Long, sName As String
  sName = Space$(128)
  k = GetWindowText(hwnd, sName, 128)
  If k > 0 Then sName = Left$(sName, k) Else sName = "No caption"
  GetWndText = sName
End Function

Private Sub cmdGetChildren_Click()
  Dim lParent As Long
  Dim lChild As Long
  Dim lCharCount As Long
  Dim sBuffer As String
  sBuffer = String(255, Chr$(0))
  lParent = FindWindow(vbNullString, txtWindowTitle.Text)
  lstChildren.AddItem CStr(lParent)
  lstChildren.ItemData(lstChildren.NewIndex) = lParent
  lCharCount = GetWindowText(lParent, sBuffer, Len(sBuffer))
  Do
    lstChildren.AddItem "Class: " & GetWndClass(lChild) & " ; Text: " & GetWndText(lChild)
    lstChildren.ItemData(lstChildren.NewIndex) = lChild
    lChild = FindWindowEx(lParent, lChild, vbNullString, vbNullString)
  Loop Until lChild = 0
End Sub
Private Sub cmdQuitSubclassing_Click()
  'StopSubClassing cmdGetChildren.hWnd
  StopSubClassing lstChildren.ItemData(lstChildren.ListIndex)
End Sub
Private Sub cmdStartSubclassing_Click()
  'StartSubClassing cmdGetChildren.hWnd
  StartSubClassing lstChildren.ItemData(lstChildren.ListIndex)
End Sub

Private Sub Label1_Click()

End Sub
