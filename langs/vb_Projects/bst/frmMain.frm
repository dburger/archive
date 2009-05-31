VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3195
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdFind 
      Caption         =   "Find"
      Height          =   510
      Left            =   1620
      TabIndex        =   3
      Top             =   1395
      Width           =   1185
   End
   Begin VB.CommandButton cmdShowValues 
      Caption         =   "Show Values"
      Height          =   510
      Left            =   135
      TabIndex        =   2
      Top             =   1395
      Width           =   1185
   End
   Begin VB.TextBox txtObjectData 
      Height          =   510
      Left            =   135
      TabIndex        =   1
      Top             =   720
      Width           =   1185
   End
   Begin VB.CommandButton cmdAddObject 
      Caption         =   "Add Object"
      Height          =   510
      Left            =   135
      TabIndex        =   0
      Top             =   135
      Width           =   1185
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mobjBST As clsBST

Private Sub cmdAddObject_Click()
  Dim tmpObject As clsExample
  Set tmpObject = New clsExample
  tmpObject.data = txtObjectData.Text
  mobjBST.add tmpObject
End Sub

Private Sub cmdFind_Click()
  MsgBox mobjBST.find(txtObjectData.Text)
End Sub

Private Sub cmdShowValues_Click()
  mobjBST.showValues
End Sub

Private Sub Form_Load()
  Set mobjBST = New clsBST
End Sub
