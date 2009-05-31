VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsBST"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private mobjHeadNode As clsNode
Public Sub add(obj As Object)
  Dim tmpNode As clsNode
  If mobjHeadNode Is Nothing Then
    Set tmpNode = New clsNode
    Set tmpNode.data = obj
    Set mobjHeadNode = tmpNode
  Else
    mobjHeadNode.add obj
  End If
End Sub
Public Sub showValues()
  mobjHeadNode.showValue
End Sub
Public Function find(sData As String) As Boolean
  If mobjHeadNode Is Nothing Then
    find = False
  Else
    find = mobjHeadNode.find(sData)
  End If
End Function
