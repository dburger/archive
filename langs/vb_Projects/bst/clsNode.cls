VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsNode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private mobjData As Object
Private mobjLeftNode As clsNode
Private mobjRightNode As clsNode
Private mnLeftChildren As Integer
Private mnRightChildren As Integer
Public Function find(sData As String) As Boolean
  If mobjData.data = sData Then
    find = True
  ElseIf sData < mobjData.data Then
    If mobjLeftNode Is Nothing Then
      find = False
    Else
      find = mobjLeftNode.find(sData)
    End If
  Else
    If mobjRightNode Is Nothing Then
      find = False
    Else
      find = mobjRightNode.find(sData)
    End If
  End If
End Function
Public Property Set data(obj As Object)
  Set mobjData = obj
End Property
Public Property Get data() As Object
  Set data = mobjData
End Property
Public Sub add(obj As Object)
  Dim tmpNode As clsNode
  If obj.data < mobjData.data Then
    If mobjLeftNode Is Nothing Then
      Set tmpNode = New clsNode
      Set tmpNode.data = obj
      Set mobjLeftNode = tmpNode
      mnLeftChildren = mnLeftChildren + 1
    Else
      mobjLeftNode.add obj
      mnLeftChildren = mnLeftChildren + 1
    End If
  Else
    If mobjRightNode Is Nothing Then
      Set tmpNode = New clsNode
      Set tmpNode.data = obj
      Set mobjRightNode = tmpNode
      mnRightChildren = mnRightChildren + 1
    Else
      mobjRightNode.add obj
      mnRightChildren = mnRightChildren + 1
    End If
  End If
End Sub
Public Sub showValue()
  If Not mobjLeftNode Is Nothing Then mobjLeftNode.showValue
  MsgBox mobjData.data & " left children: " & CStr(mnLeftChildren) & " right children: " & CStr(mnRightChildren)
  If Not mobjRightNode Is Nothing Then mobjRightNode.showValue
End Sub
