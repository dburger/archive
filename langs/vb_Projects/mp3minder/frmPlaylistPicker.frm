VERSION 5.00
Begin VB.Form frmPlaylistPicker 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Select a Playlist"
   ClientHeight    =   2970
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2970
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdCancel 
      Caption         =   "Cancel"
      Height          =   510
      Left            =   3420
      TabIndex        =   2
      Top             =   2430
      Width           =   1185
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "OK"
      Height          =   510
      Left            =   2115
      TabIndex        =   1
      Top             =   2430
      Width           =   1185
   End
   Begin VB.ListBox lstPlaylists 
      Height          =   2010
      Left            =   45
      TabIndex        =   0
      Top             =   315
      Width           =   4560
   End
End
Attribute VB_Name = "frmPlaylistPicker"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mnModalResult As VbMsgBoxResult
Public Function ShowPlaylists(tvPlaylists As TreeView, frmParent As Form) As String
  mnModalResult = vbCancel
  LoadPlaylists tvPlaylists
  Me.Show vbModal, frmParent
  If mnModalResult = vbOK Then
    If lstPlaylists.ListIndex = -1 Then
      MsgBox "You need to select a playlist and then press OK.", vbOKOnly + vbInformation, "Select Playlist"
    Else
      ShowPlaylists = lstPlaylists.Text
    End If
  Else
    ShowPlaylists = ""
    Unload Me
  End If
End Function
Private Sub cmdCancel_Click()
  Me.Hide
End Sub
Private Sub cmdOK_Click()
  mnModalResult = vbOK
  Me.Hide
End Sub
Private Sub LoadPlaylists(tvPlaylists As TreeView)
  Dim nLoop As Integer
  Dim sKey As String
  For nLoop = 1 To tvPlaylists.Nodes.Count
    sKey = tvPlaylists.Nodes.Item(nLoop).Key
    If InStr(1, sKey, "|") = 0 Then
      lstPlaylists.AddItem sKey
    End If
  Next nLoop
End Sub
