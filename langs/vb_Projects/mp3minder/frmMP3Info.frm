VERSION 5.00
Begin VB.Form frmMP3Information 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "mp3 information"
   ClientHeight    =   3615
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3975
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3615
   ScaleWidth      =   3975
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame frmID3Information 
      Caption         =   "ID3 Information"
      Height          =   3570
      Left            =   45
      TabIndex        =   0
      Top             =   0
      Width           =   3885
      Begin VB.CommandButton cmdMore 
         Cancel          =   -1  'True
         Caption         =   "&More >>"
         Height          =   285
         Left            =   2610
         TabIndex        =   15
         Top             =   3240
         Width           =   1185
      End
      Begin VB.TextBox txtTitle 
         Height          =   330
         Left            =   855
         MaxLength       =   30
         TabIndex        =   2
         Top             =   225
         Width           =   2940
      End
      Begin VB.TextBox txtArtist 
         Height          =   330
         Left            =   855
         MaxLength       =   30
         TabIndex        =   4
         Top             =   630
         Width           =   2940
      End
      Begin VB.TextBox txtAlbum 
         Height          =   330
         Left            =   855
         MaxLength       =   30
         TabIndex        =   6
         Top             =   1035
         Width           =   2940
      End
      Begin VB.TextBox txtYear 
         Height          =   330
         Left            =   855
         MaxLength       =   4
         TabIndex        =   8
         Top             =   1440
         Width           =   2940
      End
      Begin VB.TextBox txtComment 
         Height          =   330
         Left            =   855
         MaxLength       =   30
         TabIndex        =   10
         Top             =   1845
         Width           =   2940
      End
      Begin VB.CommandButton cmdSave 
         Caption         =   "&Save"
         Default         =   -1  'True
         Height          =   510
         Left            =   855
         TabIndex        =   13
         Top             =   2700
         Width           =   1185
      End
      Begin VB.CommandButton cmdCancel 
         Caption         =   "&Cancel"
         Height          =   510
         Left            =   2610
         TabIndex        =   14
         Top             =   2700
         Width           =   1185
      End
      Begin VB.ComboBox cboGenre 
         Height          =   315
         Left            =   855
         Sorted          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   12
         Top             =   2250
         Width           =   2940
      End
      Begin VB.Label lblTitle 
         Caption         =   "&Title:"
         Height          =   285
         Left            =   90
         TabIndex        =   1
         Top             =   225
         Width           =   690
      End
      Begin VB.Label lblArtist 
         Caption         =   "&Artist:"
         Height          =   285
         Left            =   90
         TabIndex        =   3
         Top             =   630
         Width           =   690
      End
      Begin VB.Label lblAlbum 
         Caption         =   "A&lbum:"
         Height          =   285
         Left            =   90
         TabIndex        =   5
         Top             =   1035
         Width           =   690
      End
      Begin VB.Label lblYear 
         Caption         =   "&Year:"
         Height          =   285
         Left            =   90
         TabIndex        =   7
         Top             =   1440
         Width           =   690
      End
      Begin VB.Label lblComment 
         Caption         =   "&Comment:"
         Height          =   285
         Left            =   90
         TabIndex        =   9
         Top             =   1845
         Width           =   690
      End
      Begin VB.Label lblGenre 
         Caption         =   "&Genre:"
         Height          =   285
         Left            =   90
         TabIndex        =   11
         Top             =   2250
         Width           =   690
      End
   End
   Begin VB.Frame frmMP3Info 
      Caption         =   "MP3 Information"
      Height          =   3570
      Left            =   4005
      TabIndex        =   16
      Top             =   0
      Width           =   3885
      Begin VB.Label lblEmphasis 
         AutoSize        =   -1  'True
         Caption         =   "EMPHASIS"
         Height          =   195
         Left            =   90
         TabIndex        =   30
         Top             =   3150
         Width           =   825
      End
      Begin VB.Label lblOriginal 
         AutoSize        =   -1  'True
         Caption         =   "ORIGINAL"
         Height          =   195
         Left            =   90
         TabIndex        =   29
         Top             =   2925
         Width           =   765
      End
      Begin VB.Label lblCopyright 
         AutoSize        =   -1  'True
         Caption         =   "COPYRIGHT"
         Height          =   195
         Left            =   90
         TabIndex        =   28
         Top             =   2700
         Width           =   945
      End
      Begin VB.Label lblMSStereo 
         AutoSize        =   -1  'True
         Caption         =   "MS STEREO"
         Height          =   195
         Left            =   90
         TabIndex        =   27
         Top             =   2475
         Width           =   945
      End
      Begin VB.Label lblIntensityStereo 
         AutoSize        =   -1  'True
         Caption         =   "INTENSITY STEREO"
         Height          =   195
         Left            =   90
         TabIndex        =   26
         Top             =   2250
         Width           =   1560
      End
      Begin VB.Label lblChannelMode 
         AutoSize        =   -1  'True
         Caption         =   "CHANNEL MODE"
         Height          =   195
         Left            =   90
         TabIndex        =   25
         Top             =   2025
         Width           =   1290
      End
      Begin VB.Label lblPadding 
         AutoSize        =   -1  'True
         Caption         =   "PADDING"
         Height          =   195
         Left            =   90
         TabIndex        =   24
         Top             =   1800
         Width           =   735
      End
      Begin VB.Label lblFrequency 
         AutoSize        =   -1  'True
         Caption         =   "FREQUENCY"
         Height          =   195
         Left            =   90
         TabIndex        =   23
         Top             =   1575
         Width           =   990
      End
      Begin VB.Label lblBitrate 
         AutoSize        =   -1  'True
         Caption         =   "BITRATE"
         Height          =   195
         Left            =   90
         TabIndex        =   22
         Top             =   1350
         Width           =   690
      End
      Begin VB.Label lblProtection 
         AutoSize        =   -1  'True
         Caption         =   "PROTECTION"
         Height          =   195
         Left            =   90
         TabIndex        =   21
         Top             =   1125
         Width           =   1050
      End
      Begin VB.Label lblLayerDescription 
         AutoSize        =   -1  'True
         Caption         =   "LAYER DESCRIPTION"
         Height          =   195
         Left            =   90
         TabIndex        =   20
         Top             =   900
         Width           =   1665
      End
      Begin VB.Label lblAudioVersion 
         AutoSize        =   -1  'True
         Caption         =   "AUDIO VERSION"
         Height          =   195
         Left            =   90
         TabIndex        =   19
         Top             =   675
         Width           =   1275
      End
      Begin VB.Label lblSize 
         AutoSize        =   -1  'True
         Caption         =   "SIZE"
         Height          =   195
         Left            =   90
         TabIndex        =   18
         Top             =   450
         Width           =   360
      End
      Begin VB.Label lblFilename 
         Caption         =   "FILENAME"
         Height          =   195
         Left            =   90
         TabIndex        =   17
         Top             =   225
         Width           =   3675
      End
   End
End
Attribute VB_Name = "frmMP3Information"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mnModalResult As VbMsgBoxResult
Public Function ShowAttributes(ByRef objMP3Info As clsMP3Info, frmParent As Form) As Boolean
  ShowAttributes = False
  mnModalResult = vbCancel
  LoadGenres
  If objMP3Info.HasTag Then
    txtTitle.Text = objMP3Info.Title
    txtArtist.Text = objMP3Info.Artist
    txtAlbum.Text = objMP3Info.Album
    txtYear.Text = objMP3Info.Year
    txtComment.Text = objMP3Info.Comment
    ComboFetchByText cboGenre, objMP3Info.GenreString
  Else
    txtTitle.Text = ""
    txtArtist.Text = ""
    txtAlbum.Text = ""
    txtYear.Text = ""
    txtComment.Text = ""
    cboGenre.ListIndex = -1
  End If
  lblFilename.Caption = "Filename:  " & objMP3Info.Filename
  lblSize.Caption = "Size:  " & objMP3Info.Size
  lblAudioVersion.Caption = "Audio Version:  " & objMP3Info.Version
  
  lblLayerDescription.Caption = "Layer Description:  " & objMP3Info.LayerDescription
  lblProtection.Caption = "Protection:  " & objMP3Info.ProtectionBit
  lblBitrate.Caption = "Bitrate:  " & objMP3Info.Bitrate
  lblFrequency.Caption = "Frequency:  " & objMP3Info.Frequency
  lblPadding.Caption = "Padding:  " & YesNo(objMP3Info.IsPadded)
  lblChannelMode.Caption = "Channel Mode:  " & objMP3Info.ChannelMode
  lblIntensityStereo.Caption = "Intensity Stereo:  " & YesNo(objMP3Info.IntensityStereo)
  lblMSStereo.Caption = "MS Stereo:  " & YesNo(objMP3Info.MSStereo)
  lblCopyright.Caption = "Copyright:  " & YesNo(objMP3Info.Copyrighted)
  lblOriginal.Caption = "Original:  " & YesNo(objMP3Info.OriginalMedia)
  lblEmphasis.Caption = "Emphasis:  " & objMP3Info.Emphasis
  Me.Show vbModal, frmParent
  If mnModalResult = vbOK Then
    If cboGenre.ListIndex = -1 Then cboGenre.ListIndex = 255
    If Not objMP3Info.setTag(objMP3Info.Filename, txtTitle.Text, txtArtist.Text, txtAlbum.Text, txtYear.Text, txtComment.Text, cboGenre.ItemData(cboGenre.ListIndex)) Then
      MsgBox "An error occurred while changing the ID3 Tag.", vbOKOnly + vbCritical, "ID3 Tag Error"
    Else
      ShowAttributes = True
    End If
  End If
  Unload Me
End Function
Private Sub cmdCancel_Click()
  Me.Hide
End Sub
Private Sub cmdMore_Click()
  If cmdMore.Caption = "&More >>" Then
    cmdMore.Caption = "&Less <<"
    Me.Width = 8025
  Else
    cmdMore.Caption = "&More >>"
    Me.Width = 4065
  End If
End Sub
Private Sub cmdSave_Click()
  mnModalResult = vbOK
  Me.Hide
End Sub
Private Sub txtAlbum_GotFocus()
  txtAlbum.SelStart = 0
  txtAlbum.SelLength = Len(txtAlbum.Text)
End Sub
Private Sub txtArtist_GotFocus()
  txtArtist.SelStart = 0
  txtArtist.SelLength = Len(txtArtist.Text)
End Sub
Private Sub txtComment_GotFocus()
  txtComment.SelStart = 0
  txtComment.SelLength = Len(txtComment.Text)
End Sub
Private Sub txtTitle_GotFocus()
  txtTitle.SelStart = 0
  txtTitle.SelLength = Len(txtTitle.Text)
End Sub
Private Sub txtYear_GotFocus()
  txtYear.SelStart = 0
  txtYear.SelLength = Len(txtYear.Text)
End Sub
Private Function LoadGenres()
  LoadComboFromArray cboGenre, gasGenres
End Function
