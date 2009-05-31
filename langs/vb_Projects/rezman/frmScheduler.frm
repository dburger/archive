VERSION 5.00
Object = "{C0A63B80-4B21-11D3-BD95-D426EF2C7949}#1.0#0"; "VSFLEX7L.OCX"
Object = "{98B65D62-50B4-11D3-9441-54AC0EC10000}#1.0#0"; "CTSCHEDULE.OCX"
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmScheduler 
   Caption         =   "Rezman 0.99"
   ClientHeight    =   5430
   ClientLeft      =   60
   ClientTop       =   -15
   ClientWidth     =   9480
   ClipControls    =   0   'False
   Icon            =   "frmScheduler.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   5430
   ScaleWidth      =   9480
   Begin VB.CommandButton cmdNextDay 
      Caption         =   ">>"
      Height          =   255
      Left            =   4920
      TabIndex        =   23
      Top             =   30
      Width           =   375
   End
   Begin VB.CommandButton cmdPreviousDay 
      Caption         =   "<<"
      Height          =   255
      Left            =   4560
      TabIndex        =   22
      Top             =   30
      Width           =   375
   End
   Begin MSComCtl2.DTPicker dpMain 
      Height          =   270
      Left            =   1650
      TabIndex        =   1
      Top             =   30
      Width           =   2895
      _ExtentX        =   5106
      _ExtentY        =   476
      _Version        =   393216
      CustomFormat    =   "MM/dd/yyy"
      Format          =   24641539
      CurrentDate     =   36154
   End
   Begin CTSCHEDULELibCtl.ctSchedule schMain 
      Align           =   1  'Align Top
      Height          =   1365
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   9480
      _Version        =   65536
      _ExtentX        =   16722
      _ExtentY        =   2408
      _StockProps     =   65
      BackColor       =   -2147483643
      BeginProperty TitleFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty ListFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty RulerFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Image1          =   "frmScheduler.frx":000C
      Image2          =   "frmScheduler.frx":0028
      Image3          =   "frmScheduler.frx":0044
      Image4          =   "frmScheduler.frx":0060
      Image5          =   "frmScheduler.frx":007C
      Image6          =   "frmScheduler.frx":0098
      SelectBackColor =   12582912
      SelectForeColor =   16777215
      BarDefBackColor =   65280
      ListBorder      =   2
      RulerAlign      =   0
      GridFrequency   =   5
      DateStart       =   36633
      DateEnd         =   36633
      IncludeAmPm     =   -1  'True
      SnapToGrid      =   -1  'True
      VertReposition  =   -1  'True
      PicArray0       =   "frmScheduler.frx":00B4
      PicArray1       =   "frmScheduler.frx":00D0
      PicArray2       =   "frmScheduler.frx":00EC
      PicArray3       =   "frmScheduler.frx":0108
      PicArray4       =   "frmScheduler.frx":0124
      PicArray5       =   "frmScheduler.frx":0140
      PicArray6       =   "frmScheduler.frx":015C
      PicArray7       =   "frmScheduler.frx":0178
      PicArray8       =   "frmScheduler.frx":0194
      PicArray9       =   "frmScheduler.frx":01B0
      PicArray10      =   "frmScheduler.frx":01CC
      PicArray11      =   "frmScheduler.frx":01E8
      PicArray12      =   "frmScheduler.frx":0204
      PicArray13      =   "frmScheduler.frx":0220
      PicArray14      =   "frmScheduler.frx":023C
      PicArray15      =   "frmScheduler.frx":0258
      PicArray16      =   "frmScheduler.frx":0274
      PicArray17      =   "frmScheduler.frx":0290
      PicArray18      =   "frmScheduler.frx":02AC
      PicArray19      =   "frmScheduler.frx":02C8
      PicArray20      =   "frmScheduler.frx":02E4
      PicArray21      =   "frmScheduler.frx":0300
      PicArray22      =   "frmScheduler.frx":031C
      PicArray23      =   "frmScheduler.frx":0338
      PicArray24      =   "frmScheduler.frx":0354
      PicArray25      =   "frmScheduler.frx":0370
      PicArray26      =   "frmScheduler.frx":038C
      PicArray27      =   "frmScheduler.frx":03A8
      PicArray28      =   "frmScheduler.frx":03C4
      PicArray29      =   "frmScheduler.frx":03E0
      PicArray30      =   "frmScheduler.frx":03FC
      PicArray31      =   "frmScheduler.frx":0418
      PicArray32      =   "frmScheduler.frx":0434
      PicArray33      =   "frmScheduler.frx":0450
      PicArray34      =   "frmScheduler.frx":046C
      PicArray35      =   "frmScheduler.frx":0488
      PicArray36      =   "frmScheduler.frx":04A4
      PicArray37      =   "frmScheduler.frx":04C0
      PicArray38      =   "frmScheduler.frx":04DC
      PicArray39      =   "frmScheduler.frx":04F8
      PicArray40      =   "frmScheduler.frx":0514
      PicArray41      =   "frmScheduler.frx":0530
      PicArray42      =   "frmScheduler.frx":054C
      PicArray43      =   "frmScheduler.frx":0568
      PicArray44      =   "frmScheduler.frx":0584
      PicArray45      =   "frmScheduler.frx":05A0
      PicArray46      =   "frmScheduler.frx":05BC
      PicArray47      =   "frmScheduler.frx":05D8
      PicArray48      =   "frmScheduler.frx":05F4
      PicArray49      =   "frmScheduler.frx":0610
      PicArray50      =   "frmScheduler.frx":062C
      PicArray51      =   "frmScheduler.frx":0648
      PicArray52      =   "frmScheduler.frx":0664
      PicArray53      =   "frmScheduler.frx":0680
      PicArray54      =   "frmScheduler.frx":069C
      PicArray55      =   "frmScheduler.frx":06B8
      PicArray56      =   "frmScheduler.frx":06D4
      PicArray57      =   "frmScheduler.frx":06F0
      PicArray58      =   "frmScheduler.frx":070C
      PicArray59      =   "frmScheduler.frx":0728
      PicArray60      =   "frmScheduler.frx":0744
      PicArray61      =   "frmScheduler.frx":0760
      PicArray62      =   "frmScheduler.frx":077C
      PicArray63      =   "frmScheduler.frx":0798
      PicArray64      =   "frmScheduler.frx":07B4
      PicArray65      =   "frmScheduler.frx":07D0
      PicArray66      =   "frmScheduler.frx":07EC
      PicArray67      =   "frmScheduler.frx":0808
      PicArray68      =   "frmScheduler.frx":0824
      PicArray69      =   "frmScheduler.frx":0840
      PicArray70      =   "frmScheduler.frx":085C
      PicArray71      =   "frmScheduler.frx":0878
      PicArray72      =   "frmScheduler.frx":0894
      PicArray73      =   "frmScheduler.frx":08B0
      PicArray74      =   "frmScheduler.frx":08CC
      PicArray75      =   "frmScheduler.frx":08E8
      PicArray76      =   "frmScheduler.frx":0904
      PicArray77      =   "frmScheduler.frx":0920
      PicArray78      =   "frmScheduler.frx":093C
      PicArray79      =   "frmScheduler.frx":0958
      PicArray80      =   "frmScheduler.frx":0974
      PicArray81      =   "frmScheduler.frx":0990
      PicArray82      =   "frmScheduler.frx":09AC
      PicArray83      =   "frmScheduler.frx":09C8
      PicArray84      =   "frmScheduler.frx":09E4
      PicArray85      =   "frmScheduler.frx":0A00
      PicArray86      =   "frmScheduler.frx":0A1C
      PicArray87      =   "frmScheduler.frx":0A38
      PicArray88      =   "frmScheduler.frx":0A54
      PicArray89      =   "frmScheduler.frx":0A70
      PicArray90      =   "frmScheduler.frx":0A8C
      PicArray91      =   "frmScheduler.frx":0AA8
      PicArray92      =   "frmScheduler.frx":0AC4
      PicArray93      =   "frmScheduler.frx":0AE0
      PicArray94      =   "frmScheduler.frx":0AFC
      PicArray95      =   "frmScheduler.frx":0B18
      PicArray96      =   "frmScheduler.frx":0B34
      PicArray97      =   "frmScheduler.frx":0B50
      PicArray98      =   "frmScheduler.frx":0B6C
      PicArray99      =   "frmScheduler.frx":0B88
   End
   Begin VB.CommandButton cmdSplitter 
      Height          =   135
      Left            =   0
      MousePointer    =   7  'Size N S
      TabIndex        =   2
      Top             =   2760
      Width           =   3945
   End
   Begin VB.Frame frmDetail 
      BorderStyle     =   0  'None
      Height          =   1905
      Left            =   0
      TabIndex        =   3
      Top             =   2940
      Width           =   10425
      Begin VB.TextBox txtTotalWeight 
         BackColor       =   &H8000000F&
         Height          =   315
         Left            =   6120
         Locked          =   -1  'True
         TabIndex        =   25
         Top             =   390
         Width           =   1695
      End
      Begin VB.ComboBox cboPilot 
         BackColor       =   &H8000000F&
         Height          =   315
         Left            =   3360
         Locked          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   15
         Top             =   30
         Width           =   1695
      End
      Begin VB.ComboBox cboAgent 
         BackColor       =   &H8000000F&
         Height          =   315
         Left            =   3360
         Locked          =   -1  'True
         Style           =   2  'Dropdown List
         TabIndex        =   14
         Top             =   390
         Width           =   1695
      End
      Begin VB.TextBox txtDateMade 
         BackColor       =   &H8000000F&
         Height          =   315
         Left            =   6120
         Locked          =   -1  'True
         TabIndex        =   13
         Top             =   30
         Width           =   1695
      End
      Begin VB.TextBox txtNotes 
         BackColor       =   &H8000000F&
         Height          =   735
         Left            =   8520
         Locked          =   -1  'True
         MaxLength       =   255
         MultiLine       =   -1  'True
         TabIndex        =   12
         Top             =   30
         Width           =   1815
      End
      Begin VB.CommandButton cmdNew 
         Caption         =   "&New"
         Enabled         =   0   'False
         Height          =   255
         Left            =   0
         TabIndex        =   11
         Top             =   30
         Width           =   1095
      End
      Begin VB.ListBox lstReservations 
         DragIcon        =   "frmScheduler.frx":0BA4
         Height          =   840
         ItemData        =   "frmScheduler.frx":0CF6
         Left            =   1080
         List            =   "frmScheduler.frx":0CF8
         TabIndex        =   10
         Top             =   30
         Width           =   1575
      End
      Begin VB.CommandButton cmdSaveEdit 
         Caption         =   "&Edit"
         Enabled         =   0   'False
         Height          =   255
         Left            =   0
         TabIndex        =   9
         Top             =   285
         Width           =   1095
      End
      Begin VB.CommandButton cmdCancelDelete 
         Caption         =   "&Delete"
         Enabled         =   0   'False
         Height          =   255
         Left            =   0
         TabIndex        =   8
         Top             =   540
         Width           =   1095
      End
      Begin VB.CommandButton cmdAddDetailItem 
         Caption         =   "&Add Passenger"
         Enabled         =   0   'False
         Height          =   465
         Left            =   0
         TabIndex        =   7
         Top             =   1230
         Width           =   915
      End
      Begin VB.CommandButton cmdDeleteDetailItem 
         Caption         =   "&Delete Passenger"
         Enabled         =   0   'False
         Height          =   465
         Left            =   0
         TabIndex        =   6
         Top             =   1710
         Width           =   915
      End
      Begin VSFlex7LCtl.VSFlexGrid grdPayments 
         Height          =   975
         Left            =   910
         TabIndex        =   4
         Top             =   1230
         Width           =   7935
         _cx             =   8337068
         _cy             =   8324792
         _ConvInfo       =   -1
         Appearance      =   1
         BorderStyle     =   1
         Enabled         =   -1  'True
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         MousePointer    =   0
         BackColor       =   -2147483637
         ForeColor       =   -2147483640
         BackColorFixed  =   -2147483633
         ForeColorFixed  =   -2147483630
         BackColorSel    =   -2147483635
         ForeColorSel    =   -2147483634
         BackColorBkg    =   -2147483636
         BackColorAlternate=   -2147483637
         GridColor       =   -2147483633
         GridColorFixed  =   -2147483632
         TreeColor       =   -2147483632
         FloodColor      =   192
         SheetBorder     =   -2147483642
         FocusRect       =   1
         HighLight       =   1
         AllowSelection  =   -1  'True
         AllowBigSelection=   -1  'True
         AllowUserResizing=   1
         SelectionMode   =   0
         GridLines       =   1
         GridLinesFixed  =   2
         GridLineWidth   =   1
         Rows            =   1
         Cols            =   1
         FixedRows       =   1
         FixedCols       =   0
         RowHeightMin    =   0
         RowHeightMax    =   0
         ColWidthMin     =   0
         ColWidthMax     =   0
         ExtendLastCol   =   0   'False
         FormatString    =   ""
         ScrollTrack     =   0   'False
         ScrollBars      =   3
         ScrollTips      =   0   'False
         MergeCells      =   0
         MergeCompare    =   0
         AutoResize      =   -1  'True
         AutoSizeMode    =   0
         AutoSearch      =   0
         AutoSearchDelay =   2
         MultiTotals     =   -1  'True
         SubtotalPosition=   1
         OutlineBar      =   0
         OutlineCol      =   0
         Ellipsis        =   0
         ExplorerBar     =   0
         PicturesOver    =   0   'False
         FillStyle       =   0
         RightToLeft     =   0   'False
         PictureType     =   0
         TabBehavior     =   1
         OwnerDraw       =   0
         Editable        =   0
         ShowComboButton =   -1  'True
         WordWrap        =   0   'False
         TextStyle       =   0
         TextStyleFixed  =   0
         OleDragMode     =   0
         OleDropMode     =   0
         ComboSearch     =   3
         AutoSizeMouse   =   -1  'True
         FrozenRows      =   0
         FrozenCols      =   0
         AllowUserFreezing=   0
         BackColorFrozen =   0
         ForeColorFrozen =   0
         WallPaperAlignment=   9
      End
      Begin MSComctlLib.TabStrip tabgrdDetail 
         Height          =   375
         Left            =   910
         TabIndex        =   5
         Top             =   870
         Width           =   7935
         _ExtentX        =   13996
         _ExtentY        =   661
         MultiRow        =   -1  'True
         _Version        =   393216
         BeginProperty Tabs {1EFB6598-857C-11D1-B16A-00C0F0283628} 
            NumTabs         =   3
            BeginProperty Tab1 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
               Caption         =   "Passengers"
               ImageVarType    =   2
            EndProperty
            BeginProperty Tab2 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
               Caption         =   "Products"
               ImageVarType    =   2
            EndProperty
            BeginProperty Tab3 {1EFB659A-857C-11D1-B16A-00C0F0283628} 
               Caption         =   "Payments"
               ImageVarType    =   2
            EndProperty
         EndProperty
      End
      Begin VSFlex7LCtl.VSFlexGrid grdProducts 
         Height          =   975
         Left            =   910
         TabIndex        =   16
         Top             =   1230
         Width           =   7935
         _cx             =   8337068
         _cy             =   8324792
         _ConvInfo       =   -1
         Appearance      =   1
         BorderStyle     =   1
         Enabled         =   -1  'True
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         MousePointer    =   0
         BackColor       =   -2147483637
         ForeColor       =   -2147483640
         BackColorFixed  =   -2147483633
         ForeColorFixed  =   -2147483630
         BackColorSel    =   -2147483635
         ForeColorSel    =   -2147483634
         BackColorBkg    =   -2147483636
         BackColorAlternate=   -2147483637
         GridColor       =   -2147483633
         GridColorFixed  =   -2147483632
         TreeColor       =   -2147483632
         FloodColor      =   192
         SheetBorder     =   -2147483642
         FocusRect       =   1
         HighLight       =   1
         AllowSelection  =   -1  'True
         AllowBigSelection=   -1  'True
         AllowUserResizing=   1
         SelectionMode   =   0
         GridLines       =   1
         GridLinesFixed  =   2
         GridLineWidth   =   1
         Rows            =   1
         Cols            =   1
         FixedRows       =   1
         FixedCols       =   0
         RowHeightMin    =   0
         RowHeightMax    =   0
         ColWidthMin     =   0
         ColWidthMax     =   0
         ExtendLastCol   =   0   'False
         FormatString    =   ""
         ScrollTrack     =   0   'False
         ScrollBars      =   3
         ScrollTips      =   0   'False
         MergeCells      =   0
         MergeCompare    =   0
         AutoResize      =   -1  'True
         AutoSizeMode    =   0
         AutoSearch      =   0
         AutoSearchDelay =   2
         MultiTotals     =   -1  'True
         SubtotalPosition=   1
         OutlineBar      =   0
         OutlineCol      =   0
         Ellipsis        =   0
         ExplorerBar     =   0
         PicturesOver    =   0   'False
         FillStyle       =   0
         RightToLeft     =   0   'False
         PictureType     =   0
         TabBehavior     =   1
         OwnerDraw       =   0
         Editable        =   0
         ShowComboButton =   -1  'True
         WordWrap        =   0   'False
         TextStyle       =   0
         TextStyleFixed  =   0
         OleDragMode     =   0
         OleDropMode     =   0
         ComboSearch     =   3
         AutoSizeMouse   =   -1  'True
         FrozenRows      =   0
         FrozenCols      =   0
         AllowUserFreezing=   0
         BackColorFrozen =   0
         ForeColorFrozen =   0
         WallPaperAlignment=   9
      End
      Begin VSFlex7LCtl.VSFlexGrid grdPassengers 
         Height          =   975
         Left            =   910
         TabIndex        =   17
         Top             =   1230
         Width           =   7935
         _cx             =   8337068
         _cy             =   8324792
         _ConvInfo       =   -1
         Appearance      =   1
         BorderStyle     =   1
         Enabled         =   -1  'True
         BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         MousePointer    =   0
         BackColor       =   -2147483637
         ForeColor       =   -2147483640
         BackColorFixed  =   -2147483633
         ForeColorFixed  =   -2147483630
         BackColorSel    =   -2147483635
         ForeColorSel    =   -2147483634
         BackColorBkg    =   -2147483636
         BackColorAlternate=   -2147483637
         GridColor       =   -2147483633
         GridColorFixed  =   -2147483632
         TreeColor       =   -2147483632
         FloodColor      =   192
         SheetBorder     =   -2147483642
         FocusRect       =   1
         HighLight       =   1
         AllowSelection  =   -1  'True
         AllowBigSelection=   -1  'True
         AllowUserResizing=   1
         SelectionMode   =   0
         GridLines       =   1
         GridLinesFixed  =   2
         GridLineWidth   =   1
         Rows            =   1
         Cols            =   1
         FixedRows       =   1
         FixedCols       =   0
         RowHeightMin    =   0
         RowHeightMax    =   0
         ColWidthMin     =   0
         ColWidthMax     =   0
         ExtendLastCol   =   0   'False
         FormatString    =   ""
         ScrollTrack     =   0   'False
         ScrollBars      =   3
         ScrollTips      =   0   'False
         MergeCells      =   0
         MergeCompare    =   0
         AutoResize      =   -1  'True
         AutoSizeMode    =   0
         AutoSearch      =   0
         AutoSearchDelay =   2
         MultiTotals     =   -1  'True
         SubtotalPosition=   1
         OutlineBar      =   0
         OutlineCol      =   0
         Ellipsis        =   0
         ExplorerBar     =   0
         PicturesOver    =   0   'False
         FillStyle       =   0
         RightToLeft     =   0   'False
         PictureType     =   0
         TabBehavior     =   1
         OwnerDraw       =   0
         Editable        =   0
         ShowComboButton =   -1  'True
         WordWrap        =   0   'False
         TextStyle       =   0
         TextStyleFixed  =   0
         OleDragMode     =   0
         OleDropMode     =   0
         ComboSearch     =   3
         AutoSizeMouse   =   -1  'True
         FrozenRows      =   0
         FrozenCols      =   0
         AllowUserFreezing=   0
         BackColorFrozen =   0
         ForeColorFrozen =   0
         WallPaperAlignment=   9
      End
      Begin VB.Label lblTotalWeight 
         Caption         =   "Total Weight:"
         Height          =   255
         Left            =   5160
         TabIndex        =   24
         Top             =   390
         Width           =   1215
      End
      Begin VB.Label lblPilot 
         Caption         =   "&Pilot:"
         Height          =   375
         Left            =   2760
         TabIndex        =   21
         Top             =   30
         Width           =   1215
      End
      Begin VB.Label lblAgent 
         Caption         =   "&Agent:"
         Height          =   375
         Left            =   2760
         TabIndex        =   20
         Top             =   390
         Width           =   1215
      End
      Begin VB.Label lblNotes 
         Caption         =   "&Notes:"
         Height          =   375
         Left            =   7920
         TabIndex        =   19
         Top             =   30
         Width           =   495
      End
      Begin VB.Label lblDateMade 
         Caption         =   "&Date Made:"
         Height          =   255
         Left            =   5160
         TabIndex        =   18
         Top             =   30
         Width           =   1215
      End
   End
   Begin VB.Menu mnuAppSettings 
      Caption         =   "App Settings!"
   End
   Begin VB.Menu mnuDataMaintenance 
      Caption         =   "Data Maintenance"
      Begin VB.Menu mnuDMAgents 
         Caption         =   "Agents"
      End
      Begin VB.Menu mnuDMAgentCompanies 
         Caption         =   "Agent Companies"
      End
      Begin VB.Menu mnuDMResources 
         Caption         =   "Aircrafts"
      End
      Begin VB.Menu mnuDMEmployees 
         Caption         =   "Employees"
      End
      Begin VB.Menu mnuDMPaymentTypes 
         Caption         =   "Payment Types"
      End
      Begin VB.Menu mnuDMProductList 
         Caption         =   "Product List"
      End
      Begin VB.Menu mnuDMTourList 
         Caption         =   "Tour List"
      End
   End
   Begin VB.Menu mnuReports 
      Caption         =   "Reports!"
   End
   Begin VB.Menu mnuExit 
      Caption         =   "Exit!"
   End
   Begin VB.Menu mnu_schMainPopup 
      Caption         =   "mnu_schMainPopup"
      Visible         =   0   'False
      Begin VB.Menu mnu_schMainChangePartyDate 
         Caption         =   "&Change Party Date"
      End
      Begin VB.Menu mnu_schMainDeleteParty 
         Caption         =   "&Delete Party"
      End
   End
   Begin VB.Menu mnu_lstReservationsPopup 
      Caption         =   "mnu_lstReservationsPopup"
      Visible         =   0   'False
      Begin VB.Menu mnu_lstReservationsCutReservation 
         Caption         =   "&Cut Reservation"
      End
      Begin VB.Menu mnu_lstReservationsPasteReservation 
         Caption         =   "&Paste Reservation"
      End
      Begin VB.Menu mnu_lstReservationsDeleteReservation 
         Caption         =   "&Delete Reservation"
      End
   End
End
Attribute VB_Name = "frmScheduler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mCon As Connection
Private mobjParties As clsParties
'these will be holding both cuts and copies and
'flag variables will hold the difference
'pooper, getting rid of this crap and changing to change date
'Private mobjCutParty As clsParty
Private mobjCutReservation As clsReservation
Private mobjAppSettings As clsAppSettings

Private mbDraggingSplitter As Boolean

Private Enum eProgramState
  psBROWSING
  psNEW_RESERVATION
  psEDITING_RESERVATION
End Enum
Private Sub cboPilot_Click()
  Dim nOldPilotWeight As Integer
  Dim nNewPilotWeight As Integer
  Dim nWeightBeforeChange As Integer
  Dim nNewTotalWeight As Integer
  If (ProgramState = psEDITING_RESERVATION Or ProgramState = psNEW_RESERVATION) And cboPilot.ListIndex <> -1 Then
    'the tag property of the lblTotalWeight control holds the value
    'of the weight of the previously selected pilot or 0 if none
    'was selected, this will help to calculate the new total
    'This txtTotalWeight.Tag property is set in the ShowPartyDetail
    'so that if they 1)Create New Party 2)Create New Reservation or
    '3)Edit a Reservation it is always ready to go
    nOldPilotWeight = CInt(lblTotalWeight.Tag)
    nNewPilotWeight = GetPilotWeightFromListPosition
    'and we set the tag of the lblTotalWeight control so that it will
    'work the next time this event fires
    lblTotalWeight.Tag = CStr(nNewPilotWeight)
    nWeightBeforeChange = GetTotalPartyWeightFromTextBox
    nNewTotalWeight = nWeightBeforeChange - nOldPilotWeight + nNewPilotWeight
    UpdateTotalWeightTextBox nNewTotalWeight, GetMaxPartyWeightFromTextBox
  End If
End Sub
Private Sub UpdateTotalWeightTextBox(nTotalWeight As Integer, nMaxWeight As Integer)
  'note - this must only be called when the text in the box
  'representing the total/max is up to date
  txtTotalWeight.Text = CStr(nTotalWeight) & "/" & CStr(nMaxWeight)
  If nTotalWeight > nMaxWeight Then
    txtTotalWeight.BackColor = vbRed
  Else
    txtTotalWeight.BackColor = vbButtonFace
  End If
End Sub
Private Function GetPilotWeightFromListPosition() As Integer
  Dim sPilotData As String
  Dim nWeight As Integer
  Dim astr() As String
  If cboPilot.ListIndex = -1 Then
    GetPilotWeightFromListPosition = 0
  Else
    astr = Split(cboPilot.Tag, "|")
    sPilotData = astr(cboPilot.ListIndex)
    astr = Split(sPilotData, ";")
    GetPilotWeightFromListPosition = CInt(astr(1))
  End If
End Function
Public Function GetPilotWeightFromTagStringByID(lEmployeeID As Long) As Integer
  Dim astr() As String
  astr = ExtractRowFromDataString(cboPilot.Tag, CStr(lEmployeeID))
  GetPilotWeightFromTagStringByID = astr(0)
End Function
Private Sub cmdAddDetailItem_Click()
  Dim lProductListID As Long
  Dim nNewRow As Integer
  
  Select Case tabgrdDetail.SelectedItem.Index
    Case PASS_TAB
      Dim sPreviousRow As String
      If grdPassengers.Rows > (PASS_SUMMARY_ROWS + 1) Then
        'add based on previous row
        sPreviousRow = GetPassengerRowStringFromGrid(grdPassengers.Rows - (1 + PASS_SUMMARY_ROWS))
        grdPassengers.AddItem sPreviousRow, grdPassengers.Rows - PASS_SUMMARY_ROWS
        'pooper will have to put test here to see that the new passenger
        'inheriting the previous passengers tourPrice doesn't knock the totals
        'out of range
        UpdatePassengersGridTotals
      Else
        grdPassengers.AddItem vbTab & "0" & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "0", grdPassengers.Rows - PASS_SUMMARY_ROWS
      End If
      'we added the passenger and now we update the look of the bar
      'color/text
      'it is important that the text of the bar is updated before
      'the bar color is checked and set because the UpdatePartyBarColorFromBarText
      'gets its info from the bar text
      IncrementNumPassengersInBarText schMain.ListIndex, schMain.Bar
      UpdatePartyBarColorFromBarText schMain.ListIndex, schMain.Bar
      If Not mobjAppSettings.AllowOverbooking Then
        cmdAddDetailItem.Enabled = PartyBelowMaxPassengersFromBarText(schMain.ListIndex, schMain.Bar)
      End If
      'position the focus for the adding of data
      If grdPassengers.Rows > (PASS_SUMMARY_ROWS + 2) Then grdPassengers.Col = PASS_COL_FirstName Else grdPassengers.Col = PASS_COL_TourDescription
      grdPassengers.Row = grdPassengers.Rows - (1 + PASS_SUMMARY_ROWS)
      grdPassengers.SetFocus
      cmdDeleteDetailItem.Enabled = True
    Case PAYM_TAB
      nNewRow = grdPayments.Rows - PAYM_SUMMARY_ROWS
      'when adding a new payment line we add the zero for the amount
      'to insure that the summation formulas for totals won't throw
      'errors on CCur'ing and empty string.
      grdPayments.AddItem "" & vbTab & "" & vbTab & "" & vbTab & "" & vbTab & "0", nNewRow
      grdPayments.Col = 0
      grdPayments.Row = nNewRow
      grdPayments.SetFocus
    Case PROD_TAB
      nNewRow = grdProducts.Rows - PROD_SUMMARY_ROWS
      'when adding a new product line we add the zero for the price
      'to insure that the summation formulas for totals won't throw
      'errors on CCur'ing and empty string.
      grdProducts.AddItem "0" & vbTab & vbTab & "0" & vbTab & "0", nNewRow
      grdProducts.Col = 0
      grdProducts.Row = nNewRow
      grdProducts.SetFocus
  End Select
End Sub
Private Sub DeleteSelectedReservation()
  Dim nRes As VbMsgBoxResult
  Dim objParty As clsParty
  Dim objReservation As clsReservation
  Set objParty = GetSelectedParty
  If objParty.Reservations.Count = 1 Then
    DeleteSelectedParty
  Else
    nRes = MsgBox("Are you sure you want to delete the selected reservation?", vbQuestion + vbYesNo, "Delete Reservation?")
    If nRes = vbYes Then
      'Set objReservation = objParty.Reservations(lstReservations.ItemData(lstReservations.ListIndex))
      Set objParty = GetSelectedParty
      Set objReservation = GetSelectedReservation
      'delete the reservation
      objReservation.Delete mCon
      'remove from object hierarchy
      objParty.Reservations.Remove CStr(objReservation.ReservationID)
      'remove from lstReservations
      lstReservations.RemoveItem lstReservations.ListIndex
      'this might necessary
      'lstReservations_Click
    End If
  End If
End Sub
Private Sub cmdCancelDelete_Click()
  Dim objParty As clsParty
  Dim objReservation As clsReservation
  Dim nIndex As Integer
  Dim nItemIndex As Integer
  Dim nBarIndex As Integer
  Select Case ProgramState
    Case psBROWSING
      DeleteSelectedReservation
    Case psNEW_RESERVATION
      'in case this was a new reservation on an existing
      'party we want to make sure it it will be set to
      'show the other existing reservation(s)
      nIndex = lstReservations.ListIndex
      lstReservations.ListIndex = 0
      lstReservations.RemoveItem nIndex
      nItemIndex = schMain.ListIndex
      nBarIndex = schMain.Bar
      If lstReservations.ListCount = 0 Then
        'this was a new reservation and new party so
        schMain.DeleteTimeBar nItemIndex, nBarIndex
        'this will automatically take its child
        'reservation with it
        mobjParties.Remove NEW_PARTY_ID
      Else
        Set objParty = GetSelectedParty
        objParty.Reservations.Remove NEW_PARTY_ID
        SetBarText nItemIndex, nBarIndex
        UpdatePartyBarColorFromBarText nItemIndex, nBarIndex
      End If
      ShowPartyDetail
    Case psEDITING_RESERVATION
      'reset the bar text in case they added/deleted passengers and then cancelled
      nItemIndex = schMain.ListIndex
      nBarIndex = schMain.Bar
      SetBarText nItemIndex, nBarIndex
      UpdatePartyBarColorFromBarText nItemIndex, nBarIndex
      'because the pilot may have been changed or totals changed during editing
      'and then they decided to cancel
      ShowPartyDetail
      'this click event will cause it to reload the information about the reservation
      lstReservations_Click
  End Select
  ProgramState = psBROWSING
End Sub
Private Sub cmdDeleteDetailItem_Click()
  Select Case tabgrdDetail.SelectedItem.Index
    Case PASS_TAB
      grdPassengers.RemoveItem grdPassengers.Row
      DecrementNumPassengersInBarText schMain.ListIndex, schMain.Bar
      UpdatePartyBarColorFromBarText schMain.ListIndex, schMain.Bar
      grdPassengers_RowColChange
    Case PROD_TAB
      grdProducts.RemoveItem grdProducts.Row
      grdProducts_RowColChange
      UpdateProductsGridTotals
    Case PAYM_TAB
      grdPayments.RemoveItem grdPayments.Row
      grdPayments_RowColChange
      UpdatePaymentsGridTotals
  End Select
End Sub
Private Sub cmdNew_Click()
  Dim objParty As clsParty
  Set objParty = GetSelectedParty
  CreateNewReservation objParty
End Sub
Private Sub cmdNextDay_Click()
  dpMain.Value = dpMain.Value + 1
  'should fire on its own but doesn't
  dpMain_Change
End Sub
Private Sub cmdPreviousDay_Click()
  dpMain.Value = dpMain.Value - 1
  'should fire on its own but doesn't
  dpMain_Change
End Sub
Private Sub cmdSaveEdit_Click()
  Dim objParty As clsParty
  'Dim objTempParty As clsParty
  Dim objReservation As clsReservation
  If cmdSaveEdit.Caption = "&Save" Then
    Set objParty = GetSelectedParty
    Set objReservation = GetSelectedReservation
    'make sure the info from the current grid display is validated
    If Not SelectedGridValidates Then Exit Sub
    'DataValidates checks the general reservation data and also
    'checks to make sure not violating AllowZeroPassengers or
    'AllowZeroPayments
    If DataValidates Then
      PutGridDataInReservation objReservation
      objParty.ResourceID = GetResourceIDByListIndex(schMain.ListIndex)
      objParty.DateOf = dpMain.Value
      objParty.StartTime = schMain.BarTimeStart(schMain.ListIndex, schMain.Bar)
      objParty.EndTime = schMain.BarTimeEnd(schMain.ListIndex, schMain.Bar)
      objParty.PilotEmployeeID = cboPilot.ItemData(cboPilot.ListIndex)
      objReservation.AgentID = cboAgent.ItemData(cboAgent.ListIndex)
      objReservation.DateMade = CDate(txtDateMade.Text)
      objReservation.Notes = txtNotes.Text
      objReservation.TaxRate = CDec(GetTaxRateFromPaymentsGrid)
      'objParty will save its "children" if they are dirty
      'so we only call the party save and it should take care
      'of the rest
      objParty.Save mCon
      If ProgramState = psEDITING_RESERVATION Then
        'this is necessary in case they changed the LastName of the
        'first passenger to get the display to work correctly
        'if it is a new reservation, it is handled below with the
        'removal of NEW_RES_ID and adding the reservation back in
        lstReservations.List(lstReservations.ListIndex) = objReservation.GetLeadPassengerName
      End If
      If ProgramState = psNEW_RESERVATION Then
        'this shuffle only takes place on a new reservation
        'must remove the object from the hierarchy with key NEW_RES_ID
        'and add it with propery PartyID
        'can't we change an ID?
        'TRIED TO DO IT LIKE THIS:
          'Set objTempParty = mobjParties.Add(CStr(objParty.PartyID))
          'Set objTempParty = objParty
          'mobjParties.Remove NEW_RES_ID
        'BUT HAD TO RESORT TO THIS
        If lstReservations.ListIndex = 0 Then
          'new reservation on NEW PARTY
          mobjParties.AddExistingParty objParty
          mobjParties.Remove NEW_PARTY_ID
          'change the bar so that it has the proper PartyID in
          'its key so it matches the new Party
          schMain.BarKeyID(schMain.ListIndex, schMain.Bar) = CStr(objParty.PartyID)
        End If
        objParty.Reservations.AddExistingReservation objReservation
        objParty.Reservations.Remove NEW_RES_ID
        'change lstReservations so that it shows the proper
        'name for reservation and ItemData holds the ReservationID
        lstReservations.RemoveItem lstReservations.ListIndex
        lstReservations.AddItem objReservation.GetLeadPassengerName
        lstReservations.ItemData(lstReservations.NewIndex) = objReservation.ReservationID
        lstReservations.ListIndex = lstReservations.NewIndex
        ProgramState = psBROWSING
      End If
      ProgramState = psBROWSING
    End If
    'this is to be removed because this has now been moved to the adding/deleting while
    'in the editing state
    'pooper, line no longer necessary
    'UpdatePartyBarColor objParty
  Else 'user clicked edit
    ProgramState = psEDITING_RESERVATION
  End If
End Sub
Private Sub cmdSplitter_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  mbDraggingSplitter = True
End Sub
Private Sub cmdSplitter_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)
  Dim fNewTop As Single
  If mbDraggingSplitter Then
    fNewTop = cmdSplitter.Top + y
    'we check to make sure they are between the top and the bottom
    If (fNewTop > 0) And (fNewTop < (Me.ScaleHeight - cmdSplitter.Height)) Then cmdSplitter.Top = fNewTop
  End If
End Sub
Private Sub cmdSplitter_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  mbDraggingSplitter = False
  Form_Resize
End Sub
Private Sub dpMain_Change()
  ChangeDate dpMain.Value
End Sub
Private Sub LoadResources()
  'this sub loads the Resources into the schedule control
  'each Item has a ListCargo(#) associated with it that
  'will hold a string, in that string we stick the
  'ResourceID;MaxPassengers;MaxWeight for later retrieval and parsing
  Dim nIndex As Integer
  Dim rs As Recordset
  Dim objResources As clsResources
  Set objResources = New clsResources
  Set rs = objResources.GetRecordset(mCon)
  Do Until rs.EOF
    nIndex = schMain.AddItem(rs!Description)
    schMain.ListCargo(nIndex) = rs!ResourceID & ";" & rs!MaxPassengers & ";" & rs!MaxWeight
    rs.MoveNext
  Loop
End Sub
Private Sub RefreshAllData()
  'this sub is used when the program starts
  'or the user changes to a new valid datasource
  'to refresh all database information
  LoadPilots
  LoadAgents
  dpMain_Change
End Sub
Private Sub LoadPilots()
  'we have to have weights with the pilots and since the
  'cboPilot will only hold a numeric ItemData we stick the
  'EmployeeID there and use the tag of the cboPilot to hold
  'a string that will hold the pilot weight data
  Dim rs As Recordset
  Dim sSQL As String
  Dim lEmployeeID As Long
  Set rs = New Recordset
  sSQL = "select [FirstName] & ' ' & [LastName] as FullName, EmployeeID, Weight from employees where IsPilot=Yes"
  rs.Open sSQL, mCon, adOpenForwardOnly, adLockPessimistic
  cboPilot.Clear
  cboPilot.Tag = ""
  Do Until rs.EOF
    cboPilot.AddItem rs!FullName
    lEmployeeID = CLng(rs!EmployeeID)
    cboPilot.ItemData(cboPilot.NewIndex) = lEmployeeID
    'we use the same format as the ColComboList #key;data;data|#key;data;data
    cboPilot.Tag = cboPilot.Tag & "#" & CStr(lEmployeeID) & ";" & CStr(rs!Weight) & "|"
    rs.MoveNext
  Loop
  cboPilot.Tag = VBA.Left$(cboPilot.Tag, Len(cboPilot.Tag) - 1)
End Sub
Private Sub LoadAgents()
  FillList cboAgent, mCon, "select [FirstName] & ' ' & [LastName] as FullName, AgentID from agents", "FullName", "AgentID"
End Sub
Private Sub ChangeDate(dtNewDate As Date)
  Dim lDaysSince1900 As Long
  Dim nScroll As Integer
  lDaysSince1900 = DaysSince1900(dtNewDate)
  schMain.ClearSchedule
  schMain.SchedScroll = SCHEDULE_HOUR_AT_BORDER
  LoadResources
  schMain.DateStart = lDaysSince1900
  schMain.DateEnd = lDaysSince1900
  Set mobjParties = New clsParties
  mobjParties.Load dtNewDate, mCon
  'actually, if they change the date, this will always
  'give NO party selected and obviously NO party detail
  'to show either but ShowPartyDetail will blank everything
  'out for you when it is called with nothing selected
  ShowParties
  ShowPartyDetail
End Sub
Private Sub ShowParties()
  Dim objParty As clsParty
  Dim lDate As Long
  Dim lStartTime As Long
  Dim lEndTime As Long
  Dim nResourceItemIndex As Integer
  Dim nNewBarIndex As Integer
  
  For Each objParty In mobjParties
    'this line may waste more cpu cycles than any in
    'the program, if I can figure a way to do this better
    'then the original load of a date of parties would be
    'much quicker
    nResourceItemIndex = GetResourceItemIndex(objParty.ResourceID)
    lDate = DaysSince1900(objParty.DateOf)
    lStartTime = objParty.StartTime
    lEndTime = objParty.EndTime
    nNewBarIndex = schMain.AddKeyTimeBar(nResourceItemIndex, lStartTime, lEndTime, lDate, lDate, CStr(objParty.PartyID))
    'the order of these two calls is important because the Color one
    'gets the necessary info from the bar text
    SetBarText nResourceItemIndex, nNewBarIndex
    UpdatePartyBarColorFromBarText nResourceItemIndex, nNewBarIndex
  Next objParty
  
  SetToolbarMenuState
End Sub
Private Sub ShowPartyDetail()
  Dim nMaxWeight As Integer
  Dim nTotalWeight As Integer
  Dim nPilotWeight As Integer
  Dim objParty As clsParty
  Dim objReservation As clsReservation
  Set objParty = GetSelectedParty
  If objParty Is Nothing Then
    'the tag property of the lblTotalWeight control is used to hold
    'the weight of the selected pilot, that way, when they change to a new
    'pilot, the selected pilot weight can be subtracted out, and the
    'new pilot weight added in to get the new total, if they create a new
    'PARTY we want to make sure that it is at 0
    cboPilot.ListIndex = -1
    lblTotalWeight.Tag = CStr(0)
    lstReservations.Clear
    lstReservations_Click
    txtTotalWeight.Text = ""
    txtTotalWeight.BackColor = vbButtonFace
    ShowReservationDetail Nothing
  Else
    With objParty
      txtDateMade.Text = .DateOf
      ComboFetchByItemData cboPilot, .PilotEmployeeID
    End With
    lstReservations.Clear
    For Each objReservation In objParty.Reservations
      With objReservation
        lstReservations.AddItem .GetLeadPassengerName
        lstReservations.ItemData(lstReservations.NewIndex) = .ReservationID
      End With
    Next objReservation
    'this causes showreservationdetail to fire from the click event
    lstReservations.ListIndex = 0
    nMaxWeight = GetMaxWeightByListIndex(schMain.ListIndex)
    'notice this can only be done after the pilot combo is set
    nPilotWeight = GetPilotWeightFromListPosition
    'the pilots weight is held in the lblPilotWeight.Tag so that
    'when they change pilots we can subtract out the old weight and
    'add in the new weight
    lblTotalWeight.Tag = CStr(nPilotWeight)
    nTotalWeight = objParty.TotalWeight(nPilotWeight)
    UpdateTotalWeightTextBox nTotalWeight, nMaxWeight
  End If
End Sub
Private Sub ShowReservationDetail(objReservation As clsReservation)
  If objReservation Is Nothing Then
    cboAgent.ListIndex = -1
    txtDateMade.Text = ""
    txtNotes.Text = ""
  Else
    ComboFetchByItemData cboAgent, objReservation.AgentID
    txtDateMade.Text = objReservation.DateMade
    txtNotes.Text = objReservation.Notes
  End If
  Debug.Print "Loading all grids"
  ShowPassengers objReservation
  ShowPayments objReservation
  ShowProducts objReservation
  SetReservationButtonsState
End Sub
Private Sub ShowPassengers(objReservation As clsReservation)
  Dim objPassenger As clsPassenger
  grdPassengers.Rows = 1
  If objReservation Is Nothing Then Exit Sub
  For Each objPassenger In objReservation.Passengers
    'add to grid
    grdPassengers.AddItem objPassenger.GetRowString
  Next
  grdPassengers.AddItem objReservation.Passengers.PassengerTotalsRowString
End Sub
Private Sub ShowPayments(objReservation As clsReservation)
  Dim objPayment As clsPayment
  Dim cTourPriceTotal As Currency
  Dim cProductsTotal As Currency
  Dim fTaxRate As Single
  grdPayments.Rows = 1
  If objReservation Is Nothing Then Exit Sub
  For Each objPayment In objReservation.Payments
    'add to grid
    grdPayments.AddItem objPayment.GetRowString
  Next
  fTaxRate = objReservation.TaxRate
  cTourPriceTotal = objReservation.Passengers.TotalTourPrice
  cProductsTotal = objReservation.Products.GetProductTotal
  grdPayments.AddItem objReservation.Passengers.TourPriceTotalRowStringForPayments
  grdPayments.AddItem objReservation.Products.TotalRowStringForPayments
  grdPayments.AddItem objReservation.Payments.SubtotalRowString(cTourPriceTotal, cProductsTotal)
  grdPayments.AddItem objReservation.Payments.TaxRowString(fTaxRate, cTourPriceTotal, cProductsTotal)
  grdPayments.AddItem objReservation.Payments.GrandTotalRowString(fTaxRate, cTourPriceTotal, cProductsTotal)
  grdPayments.AddItem objReservation.Payments.TotalPaymentsRowString
  grdPayments.AddItem objReservation.Payments.RemainingBalanceRowString(fTaxRate, cTourPriceTotal, cProductsTotal)
End Sub
Private Sub ShowProducts(objReservation As clsReservation)
  Dim objProduct As clsProduct
  grdProducts.Rows = 1
  If objReservation Is Nothing Then Exit Sub
  For Each objProduct In objReservation.Products
    'add to grid
    grdProducts.AddItem objProduct.GetRowString
  Next
  grdProducts.AddItem objReservation.Products.TotalRowString
End Sub
Private Function GetResourceItemIndex(lResourceID As Long) As Integer
  Dim nLoop As Integer
  Dim lID As Long
  For nLoop = 1 To schMain.ListCount
    lID = GetResourceIDByListIndex(nLoop)
    If lResourceID = lID Then
      GetResourceItemIndex = nLoop
      Exit For
    End If
  Next nLoop
End Function
Private Function GetResourceIDByListIndex(nListIndex As Integer) As Long
  Dim sResourceID As String
  sResourceID = ExtractFromDelimitedList(schMain.ListCargo(nListIndex), 0, ";")
  GetResourceIDByListIndex = CLng(sResourceID)
End Function
Private Function GetMaxPassByListIndex(nListIndex As Integer) As Integer
  Dim sMaxPassengers As String
  sMaxPassengers = ExtractFromDelimitedList(schMain.ListCargo(nListIndex), 1, ";")
  GetMaxPassByListIndex = CInt(sMaxPassengers)
End Function
Private Function GetMaxWeightByListIndex(nListIndex As Integer) As Integer
  Dim sMaxWeight As String
  sMaxWeight = ExtractFromDelimitedList(schMain.ListCargo(nListIndex), 2, ";")
  GetMaxWeightByListIndex = CInt(sMaxWeight)
End Function
Private Sub UpdatePartyBarColorFromBarText(nItemIndex As Integer, nBarIndex As Integer)
  Dim bOneMinuteOverlap As Boolean
  Dim nConflictingBar As Integer
  Dim sKeyID As String
  nConflictingBar = schMain.FindFirstBar(nItemIndex, nBarIndex, nItemIndex)
  Do Until nConflictingBar = 0
    If schMain.BarTimeStart(nItemIndex, nBarIndex) < schMain.BarTimeStart(nItemIndex, nConflictingBar) Then
      'the bar that caused this sub to fire starts before the conflicting
      'bar
      bOneMinuteOverlap = (schMain.BarTimeEnd(nItemIndex, nBarIndex) = schMain.BarTimeStart(nItemIndex, nConflictingBar))
    ElseIf schMain.BarTimeStart(nItemIndex, nConflictingBar) < schMain.BarTimeStart(nItemIndex, nBarIndex) Then
      'the bar that is causing the conflict starts before the bar that caused
      'this event to fire
      bOneMinuteOverlap = (schMain.BarTimeEnd(nItemIndex, nConflictingBar) = schMain.BarTimeStart(nItemIndex, nBarIndex))
    End If
    If Not bOneMinuteOverlap Then
      'set the bar in question to blue and then make it topmost
      'NOTE:  THE WILL CHANGE THE INDEX VALUE OF THE TIME BAR
      schMain.BarBackColor(nItemIndex, nBarIndex) = vbBlue
      schMain.BringToFront nItemIndex, nBarIndex
      Exit Sub
    End If
    nConflictingBar = schMain.FindNextBar(nItemIndex, nBarIndex, nItemIndex)
  Loop
  If PartyBelowMaxPassengersFromBarText(nItemIndex, nBarIndex) Then
    schMain.BarBackColor(nItemIndex, nBarIndex) = vbGreen
  Else
    schMain.BarBackColor(nItemIndex, nBarIndex) = vbRed
  End If
End Sub
Private Function PartyBelowMaxPassengersFromBarText(nItemIndex As Integer, nBarIndex As Integer) As Boolean
  PartyBelowMaxPassengersFromBarText = GetNumPassengersFromBarText(nItemIndex, nBarIndex) < GetMaxPassFromBarText(nItemIndex, nBarIndex)
End Function
Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If mnuExit.Enabled = False Then
    Cancel = True
  Else
    'tried to put this in the forms terminate event
    'but it appears that the state of the window
    'may no longer be known at that point
    Dim objWindowPosition As clsWindowPosition
    Set objWindowPosition = New clsWindowPosition
    objWindowPosition.AppName = REGISTRY_APP_NAME
    objWindowPosition.SavePosition Me
    objWindowPosition.SaveCustom "SplitterTop", CStr(cmdSplitter.Top)
  End If
End Sub
Private Sub Form_Resize()
  Const HORI_SPACE = 4
  Dim lControlDimension As Long
  Dim lSplitterBottom As Long
  
  cmdSplitter.Width = Me.ScaleWidth
  schMain.Height = cmdSplitter.Top
  frmDetail.Top = cmdSplitter.Top + cmdSplitter.Height
  
  lSplitterBottom = cmdSplitter.Top + cmdSplitter.Height
  lControlDimension = Me.ScaleHeight - lSplitterBottom
  If lControlDimension > 0 Then frmDetail.Height = lControlDimension
  frmDetail.Width = Me.ScaleWidth
  
  lControlDimension = Me.ScaleWidth - grdPassengers.Left - HORI_SPACE
  If lControlDimension > 0 Then
    grdPassengers.Width = lControlDimension
    grdProducts.Width = lControlDimension
    grdPayments.Width = lControlDimension
    tabgrdDetail.Width = lControlDimension
    lControlDimension = Me.ScaleWidth - txtNotes.Left - HORI_SPACE
    If lControlDimension > 0 Then txtNotes.Width = lControlDimension
  End If
  lControlDimension = frmDetail.Height - grdPassengers.Top
  If lControlDimension > 0 Then
    grdPassengers.Height = lControlDimension
    grdProducts.Height = lControlDimension
    grdPayments.Height = lControlDimension
    SetColumnWidths grdPassengers
    SetColumnWidths grdProducts
    SetColumnWidths grdPayments
  End If
End Sub
Private Sub grdPassengers_AfterEdit(ByVal Row As Long, ByVal Col As Long)
  Dim astr() As String
  If Col = PASS_COL_TourDescription Then
    'this is going to lookup the price for the item
    'that they selected from the ColComboList
    astr = ExtractRowFromDataString(grdPassengers.ColComboList(PASS_COL_TourDescription), grdPassengers.TextMatrix(Row, Col))
    grdPassengers.TextMatrix(Row, PASS_COL_TourPrice) = astr(2)
    'changing programmatically doesn't fire the AfterEdit event so we do it
    grdPassengers_AfterEdit Row, PASS_COL_TourPrice
  ElseIf Col = PASS_COL_Weight Or Col = PASS_COL_TourPrice Then
    UpdatePassengersGridTotals
  End If
End Sub
Private Sub grdPassengers_BeforeEdit(ByVal Row As Long, ByVal Col As Long, Cancel As Boolean)
  Dim nRows As Integer
  nRows = grdPassengers.Rows
  If Not (Row < nRows - PASS_SUMMARY_ROWS) Then Cancel = True
End Sub
Private Sub grdPassengers_KeyPressEdit(ByVal Row As Long, ByVal Col As Long, KeyAscii As Integer)
  'the max of database text fields is 50
  If Len(grdPassengers.EditText) = 50 Then
    'yeah, allow them to backspace
    If KeyAscii <> 8 Then KeyAscii = 0
  End If
End Sub
Private Sub grdPassengers_RowColChange()
  If ProgramState = psNEW_RESERVATION Or ProgramState = psEDITING_RESERVATION Then
    SetDetailButtonsState
  End If
End Sub
Private Sub grdPassengers_ValidateEdit(ByVal Row As Long, ByVal Col As Long, Cancel As Boolean)
  Dim astr() As String
  Dim nTest As Integer
  Dim nMinutes As Integer
  Dim cOldTourPriceTotal As Currency
  Dim cTest As Currency
  Dim fTaxRate As Single
  On Error GoTo ErrorTrap
  If Col = PASS_COL_Weight Then
    If Not IsInteger(grdPassengers.EditText) Then
      MsgBox "Please enter a valid weight.", vbOKOnly + vbInformation, "Invalid Weight"
      Cancel = True
      Exit Sub
    End If
    If CInt(grdPassengers.EditText) < 0 Or CInt(grdPassengers.EditText) > MAX_HUMAN_WEIGHT Then
      MsgBox "Please enter a valid weight.", vbOKOnly + vbInformation, "Invalid Weight"
      Cancel = True
      Exit Sub
    End If
    'these lines try to use the new values and see if they will
    'cause errors to fire, if errors do fire (it is prob overflow)
    'the error trap cancels the edit.
    'there is no need to trap the weight for just the reservation
    'because the weight for the entire party will always be even higher
    nTest = GetTotalPartyWeightFromTextBox - CInt(grdPassengers.TextMatrix(Row, Col)) + CInt(grdPassengers.EditText)
  ElseIf Col = PASS_COL_TourPrice Or Col = PASS_COL_TourDescription Then
    If Col = PASS_COL_TourPrice Then
      If Not IsCurrency(grdPassengers.EditText) Then
        MsgBox "Please enter a valid tour price.", vbOKOnly + vbInformation, "Invalid Tour Price"
        Cancel = True
        Exit Sub
      End If
      'overflow tests
      'retrieve the new price
      cTest = CCur(grdPassengers.EditText)
    Else 'Col = PASS_COL_TourDescription
      If Len(grdPassengers.EditText) Then
        'overflow test
        'retrieve the new price
        astr = ExtractRowFromDataString(grdPassengers.ColComboList(PASS_COL_TourDescription), grdPassengers.ComboData(grdPassengers.ComboIndex))
        nMinutes = CInt(astr(1))
        If mobjAppSettings.ValidateTourDuration Then
          If GetSelectedBarTourDuration <> nMinutes Then
            'just reusing the variable
            nMinutes = MsgBox("You chose a tour that has a different duration than the time bar on the schedule.  Are you sure you wish to do that?", vbYesNo + vbQuestion, "Duration?")
            If nMinutes = vbNo Then Cancel = True
          End If
        End If
        cTest = CCur(astr(2))
      Else
        MsgBox "Please select a tour before continuing", vbOKOnly + vbInformation, "Select Tour"
        Cancel = True
      End If
    End If
    'shared overflow test
    'these lines will use the new values to see if computing them
    'will throw an error before putting them into the UI in the
    'AfterEdit event
    cOldTourPriceTotal = GetTourPriceTotalFromPassengersGrid(False)
    'the new tour price total
    cTest = (cOldTourPriceTotal - CCur(grdPassengers.TextMatrix(Row, PASS_COL_TourPrice))) + cTest
    'the new Subtotal
    cTest = cTest + GetProductsTotalFromProductsGrid(False)
    'the new grand total
    cTest = (1 + GetTaxRateFromPaymentsGrid) * cTest
    'the new remaining balance
    cTest = cTest - GetPaymentsTotalFromPaymentsGrid(False)
    'the new tour price total we are checking to see if will cause overflow
    cTest = GetRemainingBalanceFromPaymentsGrid(False) - cOldTourPriceTotal + cTest
  End If
  Exit Sub
ErrorTrap:
  MsgBox Err.Description, vbOKOnly + vbInformation, "Error:  " & CStr(Err.Number)
  Cancel = True
End Sub
Private Sub grdPayments_AfterEdit(ByVal Row As Long, ByVal Col As Long)
  Dim nRows As Integer
  nRows = grdPayments.Rows
  If (Col = PAYM_COL_Amount) Or (Col = PAYM_COL_TaxRate And Row = nRows - PAYM_SUMMARY_ROW_Tax) Then
    UpdatePaymentsGridTotals
  End If
End Sub
Private Sub UpdatePassengersGridTotals()
  'updating the total weight at the bottom of the grid and
  'the total weight for a reservation in the text box above
  'the grid
  Dim nRows As Integer
  Dim nNewWeightTotal As Integer
  Dim nWeightFromGrid As Integer
  Dim nMaxWeight As Integer
  Dim cNewTourPriceTotal As Currency
  Dim cTourPriceFromGrid As Currency
  Dim objParty As clsParty
  Dim objReservation As clsReservation
  Set objParty = GetSelectedParty
  Set objReservation = GetSelectedReservation
  nWeightFromGrid = GetWeightTotalFromPassengersGrid(True)
  nNewWeightTotal = objParty.TotalWeight(GetPilotWeightFromListPosition) - objReservation.Passengers.TotalWeight + nWeightFromGrid
  cTourPriceFromGrid = GetTourPriceTotalFromPassengersGrid(True)
  'these are the rows that update the UI
  nRows = grdPassengers.Rows
  grdPassengers.TextMatrix(nRows - PASS_SUMMARY_ROW_TotalWeight, PASS_COL_Weight) = nWeightFromGrid
  grdPassengers.TextMatrix(nRows - PASS_SUMMARY_ROW_TotalWeight, PASS_COL_TourPrice) = cTourPriceFromGrid
  nMaxWeight = GetMaxPartyWeightFromTextBox
  UpdateTotalWeightTextBox nNewWeightTotal, nMaxWeight
  'this also because a new total tour price makes payments have
  'to be updated
  UpdatePaymentsGridTotals
End Sub
Private Sub UpdatePaymentsGridTotals()
  'updating the total payment amount and remaining balance
  Dim nRows As Integer
  Dim cTourPriceTotal As Currency
  Dim cProductsTotal As Currency
  Dim cSubtotal As Currency
  Dim fTaxRate As Single
  nRows = grdPayments.Rows
  cTourPriceTotal = GetTourPriceTotalFromPassengersGrid(False)
  cProductsTotal = GetProductsTotalFromProductsGrid(False)
  cSubtotal = cTourPriceTotal + cProductsTotal
  fTaxRate = GetTaxRateFromPaymentsGrid
  grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_TourPriceTotal, PAYM_COL_Amount) = cTourPriceTotal
  grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_ProductsTotal, PAYM_COL_Amount) = cProductsTotal
  grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_Subtotal, PAYM_COL_Amount) = cSubtotal
  grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_Tax, PAYM_COL_Amount) = fTaxRate * cSubtotal
  grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_GrandTotal, PAYM_COL_Amount) = (1 + fTaxRate) * cSubtotal
  grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_PaymentsTotal, PAYM_COL_Amount) = GetPaymentsTotalFromPaymentsGrid(True)
  grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_RemainingBalance, PAYM_COL_Amount) = GetRemainingBalanceFromPaymentsGrid(True)
End Sub
Private Sub UpdateProductsGridTotals()
  Dim cProductsTotal As Currency
  cProductsTotal = GetProductsTotalFromProductsGrid(True)
  grdPayments.TextMatrix(grdPayments.Rows - PAYM_SUMMARY_ROW_ProductsTotal, PAYM_COL_Amount) = cProductsTotal
  grdProducts.TextMatrix(grdProducts.Rows - PROD_SUMMARY_ROW_Total, PROD_COL_Total) = cProductsTotal
  'this also cause the payments totals to have to be updated
  UpdatePaymentsGridTotals
End Sub
Private Function GetWeightTotalFromPassengersGrid(bCalculate As Boolean) As Integer
  'if bCalculate = True we loop through the grid to get the total
  'otherwise we simply pluck it out of the cell that should contain
  'it.
  '***NOTE the false version of these are usually called in validate
  'edits to see what was already there, the true versions of these
  'are called in AfterEdits to see what should be there
  If bCalculate Then
    Dim nLoop As Integer
    Dim nWeightTotal As Integer
    For nLoop = 1 To (grdPassengers.Rows - 1 - PASS_SUMMARY_ROWS)
      nWeightTotal = nWeightTotal + grdPassengers.TextMatrix(nLoop, PASS_COL_Weight)
    Next nLoop
    GetWeightTotalFromPassengersGrid = nWeightTotal
  Else
    Dim nRows As Integer
    nRows = grdPassengers.Rows
    GetWeightTotalFromPassengersGrid = CInt(grdPassengers.TextMatrix(nRows - PASS_SUMMARY_ROW_TotalWeight, PASS_COL_Weight))
  End If
End Function
Private Function GetTourPriceTotalFromPassengersGrid(bCalculate As Boolean) As Currency
  'this should be called in the AfterEdit to change the value that
  'appears on the passengers grid, otherwise, call GetTourPriceTotalFromPaymentsGrid
  If bCalculate Then
    Dim nLoop As Integer
    Dim cTourPriceTotal As Currency
    For nLoop = 1 To (grdPassengers.Rows - 1 - PASS_SUMMARY_ROWS)
      cTourPriceTotal = cTourPriceTotal + grdPassengers.TextMatrix(nLoop, PASS_COL_TourPrice)
    Next nLoop
    GetTourPriceTotalFromPassengersGrid = cTourPriceTotal
  Else
    Dim nRows As Integer
    nRows = grdPassengers.Rows
    GetTourPriceTotalFromPassengersGrid = CCur(grdPassengers.TextMatrix(nRows - PASS_SUMMARY_ROW_TotalWeight, PASS_COL_TourPrice))
  End If
End Function
Private Function GetPaymentsTotalFromPaymentsGrid(bCalculate As Boolean) As Currency
  '***NOTE the false version of these are usually called in validate
  'edits to see what was already there, the true versions of these
  'are called in AfterEdits to see what should be there
  If bCalculate Then
    Dim nLoop As Integer
    Dim cPaymentsTotal As Currency
    For nLoop = 1 To grdPayments.Rows - (PAYM_SUMMARY_ROWS + 1)
      cPaymentsTotal = cPaymentsTotal + CCur(grdPayments.TextMatrix(nLoop, PAYM_COL_Amount))
    Next nLoop
    GetPaymentsTotalFromPaymentsGrid = cPaymentsTotal
  Else
    Dim nRows As Integer
    nRows = grdPayments.Rows
    GetPaymentsTotalFromPaymentsGrid = CCur(grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_PaymentsTotal, PAYM_COL_Amount))
  End If
End Function
Private Function GetSubtotalFromPaymentsGrid(bCalculate As Boolean) As Currency
  Dim nRows As Integer
  nRows = grdPayments.Rows
  If bCalculate Then
    GetSubtotalFromPaymentsGrid = CCur(grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_TourPriceTotal, PAYM_COL_Amount)) + CCur(grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_ProductsTotal, PAYM_COL_Amount))
  Else
    GetSubtotalFromPaymentsGrid = CCur(grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_Subtotal, PAYM_COL_Amount))
  End If
End Function
Private Function GetGrandTotalFromPaymentsGrid(bCalculate As Boolean) As Currency
  Dim nRows As Integer
  nRows = grdPayments.Rows
  If bCalculate Then
    GetGrandTotalFromPaymentsGrid = (1 + GetTaxRateFromPaymentsGrid) * CCur(grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_ProductsTotal, PAYM_COL_Amount)) + CCur(grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_TourPriceTotal, PAYM_COL_Amount))
  Else
    GetGrandTotalFromPaymentsGrid = CCur(grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_GrandTotal, PAYM_COL_Amount))
  End If
End Function
Private Function GetRemainingBalanceFromPaymentsGrid(bCalculate As Boolean) As Currency
  'when they do an edit, the data isn't back in the object
  'hierarchy yet, so we total straight off the grid
  'if bCalculate = true then it determines this value by subtracting
  'the value in the Payments Total cell from the value in the
  'Grand Total cell, if it is false, it merely plucks it out of
  'the Remaining Balance cell
  If bCalculate Then
    Dim cPaymentsTotal As Currency
    Dim sTemp As String
    Dim cGrandTotal As Currency
    sTemp = grdPayments.TextMatrix(grdPayments.Rows - PAYM_SUMMARY_ROW_PaymentsTotal, PAYM_COL_Amount)
    cPaymentsTotal = CCur(sTemp)
    sTemp = grdPayments.TextMatrix(grdPayments.Rows - PAYM_SUMMARY_ROW_GrandTotal, PAYM_COL_Amount)
    cGrandTotal = CCur(sTemp)
    GetRemainingBalanceFromPaymentsGrid = cGrandTotal - cPaymentsTotal
  Else
    Dim nRows As Integer
    nRows = grdPayments.Rows
    GetRemainingBalanceFromPaymentsGrid = CCur(grdPayments.TextMatrix(nRows - PAYM_SUMMARY_ROW_RemainingBalance, PAYM_COL_Amount))
  End If
End Function
Private Sub grdPayments_BeforeEdit(ByVal Row As Long, ByVal Col As Long, Cancel As Boolean)
  Dim nRows As Integer
  nRows = grdPayments.Rows
  If Not (Row < nRows - PAYM_SUMMARY_ROWS) Then Cancel = True
  'except for this case
  If (Row = nRows - PAYM_SUMMARY_ROW_Tax) And (Col = PAYM_COL_TaxRate) Then Cancel = False
End Sub
Private Sub grdPayments_KeyPressEdit(ByVal Row As Long, ByVal Col As Long, KeyAscii As Integer)
  'the max of database text fields is 50
  If Len(grdPayments.EditText) = 50 Then
    'yeah, allow them to backspace
    If KeyAscii <> 8 Then KeyAscii = 0
  End If
End Sub
Private Sub grdPayments_ValidateEdit(ByVal Row As Long, ByVal Col As Long, Cancel As Boolean)
  Dim fNewTaxRate As Single
  Dim cTest As Currency
  Dim cOldPaymentAmount As Currency
  Dim nRows As Integer
  On Error GoTo ErrorTrap
  nRows = grdPayments.Rows
  If Col = PAYM_COL_TaxRate And Row = nRows - PAYM_SUMMARY_ROW_Tax Then
    If Not IsSingle(grdPayments.EditText) Then
      MsgBox "Please enter a valid tax rate.", vbOKOnly + vbInformation, "Invalid Tax Rate"
      Cancel = True
      Exit Sub
    End If
    fNewTaxRate = CSng(grdPayments.EditText)
    If fNewTaxRate < 0 Then
      MsgBox "Please enter a valid tax rate.", vbOKOnly + vbInformation, "Invalid Tax Rate"
      Cancel = True
      Exit Sub
    End If
    'the new Grandtotal (no need also compute only tax, it will always be smaller)
    cTest = (1 + fNewTaxRate) * GetSubtotalFromPaymentsGrid(False)
    'the new remaining balance
    cTest = cTest - GetPaymentsTotalFromPaymentsGrid(False)
    grdPayments.EditText = TAXRATE_CELL_PREFIX & CStr(grdPayments.EditText)
  ElseIf Col = PAYM_COL_ExpirationDate Then
    If Len(grdPayments.EditText) And (Not IsDate(grdPayments.EditText)) Then
      MsgBox "Please enter a valid expiration date.", vbOKOnly + vbInformation, "Invalid Date"
      Cancel = True
      Exit Sub
    End If
  ElseIf Col = PAYM_COL_Amount Then
    If Not IsCurrency(grdPayments.EditText) Then
      MsgBox "Please enter a valid amount.", vbOKOnly + vbInformation, "Invalid Amount"
      Cancel = True
      Exit Sub
    End If
    cOldPaymentAmount = CCur(grdPayments.TextMatrix(Row, Col))
    'the new amount
    cTest = CCur(grdPayments.EditText)
    'the new payments total
    cTest = (GetPaymentsTotalFromPaymentsGrid(False) - cOldPaymentAmount + cTest)
    'the new remaining balance
    cTest = GetGrandTotalFromPaymentsGrid(False) - cTest
  End If
  Exit Sub
ErrorTrap:
  MsgBox Err.Description, vbOKOnly + vbInformation, "Error:  " & CStr(Err.Number)
  Cancel = True
End Sub
Private Sub grdProducts_AfterEdit(ByVal Row As Long, ByVal Col As Long)
  'the ValidateEdit event already makes sure we have correct data
  'we don't need to check here
  Dim astr() As String
  If Col = PROD_COL_Description Then
    'this is going to lookup the price for the item
    'that they selected from the ColComboList
    astr = ExtractRowFromDataString(grdProducts.ColComboList(PROD_COL_Description), grdProducts.TextMatrix(Row, Col))
    'if astr comes back with nothing then that means they dropped it down
    'but never selected anything and then moved on causing it to fire
    'this event
    grdProducts.TextMatrix(Row, PROD_COL_UnitPrice) = astr(1)
    'changing programmatically doesn't fire the AfterEdit event so we do it
    grdProducts_AfterEdit Row, PROD_COL_UnitPrice
  ElseIf Col = PROD_COL_UnitPrice Or Col = PROD_COL_Quantity Then
    If IsLong(grdProducts.TextMatrix(Row, PROD_COL_Quantity)) And IsCurrency(grdProducts.TextMatrix(Row, PROD_COL_UnitPrice)) Then
      grdProducts.TextMatrix(Row, PROD_COL_Total) = (grdProducts.TextMatrix(Row, PROD_COL_Quantity)) * CDec(grdProducts.TextMatrix(Row, PROD_COL_UnitPrice))
      UpdateProductsGridTotals
    End If
  End If
End Sub
Private Function GetTaxRateFromPaymentsGrid() As Single
  Dim sTemp As String
  sTemp = grdPayments.TextMatrix(grdPayments.Rows - PAYM_SUMMARY_ROW_Tax, PAYM_COL_TaxRate)
  GetTaxRateFromPaymentsGrid = CDec(VBA.Right$(sTemp, Len(sTemp) - Len(TAXRATE_CELL_PREFIX)))
End Function
Private Function GetProductsTotalFromProductsGrid(bCalculate As Boolean)
  'when they do an edit, the data isn't back in the object
  'hierarchy yet, so we total straight off the grid
  If bCalculate Then
    Dim nLoop As Integer
    Dim cTemp As Currency
    For nLoop = 1 To grdProducts.Rows - (PROD_SUMMARY_ROWS + 1)
      cTemp = cTemp + CCur(grdProducts.TextMatrix(nLoop, PROD_COL_Total))
    Next nLoop
    GetProductsTotalFromProductsGrid = cTemp
  Else
    Dim nRows As Integer
    nRows = grdProducts.Rows
    GetProductsTotalFromProductsGrid = CCur(grdProducts.TextMatrix(nRows - PROD_SUMMARY_ROW_Total, PROD_COL_Total))
  End If
End Function
Private Sub grdProducts_BeforeEdit(ByVal Row As Long, ByVal Col As Long, Cancel As Boolean)
  Dim nRows As Integer
  nRows = grdProducts.Rows
  If Not (Row < nRows - PROD_SUMMARY_ROWS) Or (Col = PROD_COL_Total) Then Cancel = True
End Sub
Private Sub grdProducts_KeyPressEdit(ByVal Row As Long, ByVal Col As Long, KeyAscii As Integer)
  'the max of database text fields is 50
  If Len(grdProducts.EditText) = 50 Then
    'yeah, allow them to backspace
    If KeyAscii <> 8 Then KeyAscii = 0
  End If
End Sub
Private Sub grdProducts_RowColChange()
  If ProgramState = psNEW_RESERVATION Or ProgramState = psEDITING_RESERVATION Then
    SetDetailButtonsState
  End If
End Sub
Private Sub grdProducts_ValidateEdit(ByVal Row As Long, ByVal Col As Long, Cancel As Boolean)
  Dim sTemp As String
  Dim cTest As Currency
  Dim astr() As String
  On Error GoTo ErrorTrap
  If Col = PROD_COL_Quantity Or Col = PROD_COL_Description Or Col = PROD_COL_UnitPrice Then
    If Col = PROD_COL_Quantity Then
      If Not IsInteger(grdProducts.EditText) Then
        MsgBox "Please enter a valid quantity.", vbOKOnly + vbInformation, "Invalid quantity"
        Cancel = True
        Exit Sub
      End If
      'overflow checks for quantity change
      '1 new product amount
      cTest = CInt(grdProducts.EditText) * CCur(grdProducts.TextMatrix(Row, PROD_COL_UnitPrice))
    ElseIf Col = PROD_COL_Description Then
      If Len(grdProducts.EditText) Then
        'retrieve the new price
        astr = ExtractRowFromDataString(grdProducts.ColComboList(PROD_COL_Description), grdProducts.ComboData(grdProducts.ComboIndex))
        cTest = CCur(astr(1))
        'new product amount
        cTest = CInt(grdProducts.TextMatrix(Row, PROD_COL_Quantity)) * cTest
      Else
        MsgBox "Please select a product before continuing", vbOKOnly + vbInformation, "Select Product"
        Cancel = True
        Exit Sub
      End If
    ElseIf Col = PROD_COL_UnitPrice Then
      If Not IsCurrency(grdProducts.EditText) Then
        MsgBox "Please enter a valid price.", vbOKOnly + vbInformation, "Invalid price"
        Cancel = True
        Exit Sub
      End If
      'overflow checks for unit price change
      '1 new product amount
      cTest = CInt(grdProducts.TextMatrix(Row, PROD_COL_Quantity)) * CCur(grdProducts.EditText)
    End If
    'shared overflow tests
    '2 new products total
    cTest = (GetProductsTotalFromProductsGrid(False) - CCur(grdProducts.TextMatrix(Row, PROD_COL_Total))) + cTest
    '3 new subtotal
    cTest = cTest + GetTourPriceTotalFromPassengersGrid(False)
    '4 new grandtotal
    cTest = (1 + GetTaxRateFromPaymentsGrid) * cTest
    '5 new remaining balance
    cTest = cTest - GetPaymentsTotalFromPaymentsGrid(False)
  End If
  Exit Sub
ErrorTrap:
  MsgBox Err.Description, vbOKOnly + vbInformation, "Error:  " & CStr(Err.Number)
  Cancel = True
End Sub
Private Sub lstReservations_Click()
  Dim objReservation As clsReservation
  'they can't click on the NEW_RES_ID because it is disabled but
  'first time added it will fire so we suppress
  If lstReservations.Text <> NEW_RES_ID Then
    Set objReservation = GetSelectedReservation
    ShowReservationDetail objReservation
  End If
End Sub
Private Sub lstReservations_KeyUp(KeyCode As Integer, Shift As Integer)
  If (KeyCode = vbKeyDelete) And (lstReservations.ListIndex <> -1) Then
    DeleteSelectedReservation
  End If
End Sub
Private Sub lstReservations_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  SetToolbarMenuState
  If Button = vbRightButton Then
    If ProgramState = psEDITING_RESERVATION Or ProgramState = psNEW_RESERVATION Then
      'do nothing
    Else
      PopupMenu mnu_lstReservationsPopup
    End If
  End If
End Sub
Private Sub mnu_lstReservationsCutReservation_Click()
  Set mobjCutReservation = GetSelectedReservation
End Sub
Private Sub mnu_lstReservationsDeleteReservation_Click()
  DeleteSelectedReservation
End Sub
Private Sub mnu_lstReservationsPasteReservation_Click()
  'this menu is always disabled unless they are on a party
  'and there is a reservation to paste
  Dim objParty As clsParty
  Dim lOldPartyID As Long
  Set objParty = GetSelectedParty
  'change parties has intelligence to delete a Party
  'if moving its reservation to another Party leaves
  'it with no reservations
  mobjCutReservation.ChangeParties mCon, objParty.PartyID
  'let the changedate function
  'take care of the refresh
  ChangeDate dpMain.Value
'  lstReservations.AddItem mobjCutReservation.GetLeadPassengerLastName
'  lstReservations.ItemData(lstReservations.NewIndex) = mobjCutReservation.ReservationID
  'pooper
  'this proc does not now do copy reservation correctly and it shouldn't
  'be necessary to refresh the entire schedule just to get it to show
  'the new reservation BUT IT SURE IS EASY
  Set mobjCutReservation = Nothing
End Sub
Private Sub mnu_lstReservationsPopup_Click()
  'enables/disables handled from then mouseup event
  'of the lstReservations control
End Sub
Private Sub mnu_schMainDeleteParty_Click()
  DeleteSelectedParty
End Sub
Private Sub mnu_schMainChangePartyDate_Click()
  Dim frmNew As frmDatePicker
  Dim dtNewDate As Date
  Dim objParty As clsParty
  Set frmNew = New frmDatePicker
  dtNewDate = frmNew.GetDate(Me)
  If dtNewDate <> #12:00:00 AM# Then
    Set objParty = GetSelectedParty
    objParty.DateOf = dtNewDate
    objParty.Save mCon
    dpMain.Value = dtNewDate
    dpMain_Change
    Set objParty = Nothing
  End If
End Sub
Private Sub mnu_schMainPopup_Click()
  'enables/disables handled from the mouseup event for the
  'schMain control
End Sub
Private Sub mnuAppSettings_Click()
  Dim objRezmanData As clsRezmanData
  Dim frmNew As frmAppSettings
  Set frmNew = New frmAppSettings
  frmNew.ShowApplicationSettings mobjAppSettings, Me
  'in case they changed the Resource names
  SetUpResourcesUIStrings
  If frmNew.bAllowOverbookingChanged Then
    'if allow overbooking was changed the button state of the
    'new may change based on the number of passengers in selected
    'party
    ProgramState = psBROWSING
  End If
  If frmNew.bGridFrequencyChanged Then schMain.GridFrequency = mobjAppSettings.GridFrequency
  If frmNew.bDataSourceLocationChanged Then
    'the frmAppSettings verifies and saves the
    'path into the registry so no need verify
    'here, just pull it out of the registry and
    'GO!
    Set objRezmanData = New clsRezmanData
    Set mCon = objRezmanData.GetConnection
    RefreshAllData
  End If
  Set frmNew = Nothing
End Sub
Private Sub mnuDMAgentCompanies_Click()
  'because they could have deleted the company of an agent
  'that was NOT IN USE and the cascading delete removed the
  'agent, we must make sure the agent no long appears in the combo
  Dim lAgentID As Long
  If frmAgentsCompanies.ShowAgentsCompany(mCon, Me) Then
    If cboAgent.ListIndex <> -1 Then lAgentID = cboAgent.ItemData(cboAgent.ListIndex)
    LoadAgents
    If lAgentID <> 0 Then ComboFetchByItemData cboAgent, lAgentID
  End If
End Sub
Private Sub mnuDMAgents_Click()
  Dim lAgentID As Long
  If frmAgents.ShowAgent(mCon, Me) Then
    If cboAgent.ListIndex <> -1 Then lAgentID = cboAgent.ItemData(cboAgent.ListIndex)
    LoadAgents
    If lAgentID <> 0 Then ComboFetchByItemData cboAgent, lAgentID
  End If
End Sub
Private Sub mnuDMResources_Click()
  If frmResources.ShowResources(mCon, Me, mobjAppSettings) Then ChangeDate dpMain.Value
End Sub
Private Sub mnuDMEmployees_Click()
  Dim lPilotID As Long
  If frmEmployees.ShowEmployee(mCon, Me) Then
    'if not on a blank pilot then save who it was on
    If cboPilot.ListIndex <> -1 Then lPilotID = cboPilot.ItemData(cboPilot.ListIndex)
    'refresh the pilot data which may contain new weights
    LoadPilots
    'set the pilot back to the one it was on and ShowPartyDetail just in case
    'they changed the weight of the selected pilot
    If lPilotID <> 0 Then
      ComboFetchByItemData cboPilot, lPilotID
      ShowPartyDetail
    End If
  End If
End Sub
Private Sub mnuDMPaymentTypes_Click()
  If frmPaymentTypes.ShowPaymentTypes(mCon, Me) Then SetUpPaymentsCombo
End Sub
Private Sub mnuDMProductList_Click()
  If frmProducts.ShowProduct(mCon, Me) Then SetUpProductsCombo
End Sub
Private Sub mnuDMTourList_Click()
  If frmTours.ShowTour(mCon, Me) Then SetUpPassengersCombo
End Sub
Private Sub mnuExit_Click()
  Unload Me
End Sub
Private Sub mnuReports_Click()
  Dim objParty As clsParty
  Dim objReservation As clsReservation
  Dim objPaymentTypes As clsPaymentTypes
  Dim objProductList As clsProductList
  Dim objTourList As clsTourList
  Set objPaymentTypes = New clsPaymentTypes
  Set objProductList = New clsProductList
  Set objTourList = New clsTourList
  Set objParty = GetSelectedParty
  Set objReservation = GetSelectedReservation
  frmReportSelector.ShowReportSelector objParty, objReservation, mobjAppSettings, objPaymentTypes.GetPaymentList(mCon), objProductList.GetProductList(mCon), objTourList.GetTourList(mCon), cboPilot.Tag, mCon, Me
End Sub
Private Sub schMain_BarChanged(ByVal nIndex As Integer, ByVal nBar As Integer, ByVal cKeyID As String, ByVal lTimeStart As Long, ByVal lTimeEnd As Long, ByVal lDateStart As Long, ByVal lDateEnd As Long)
  Dim objParty As clsParty
  Dim lResourceID As Long
  Set objParty = mobjParties(cKeyID)
  lResourceID = GetResourceIDByListIndex(nIndex)
  With objParty
    If .ResourceID <> lResourceID Or .StartTime <> lTimeStart Or .EndTime <> lTimeEnd Then
      .ResourceID = lResourceID
      .StartTime = lTimeStart
      .EndTime = lTimeEnd
      Debug.Print "Saving Party"
      .Save mCon
      'because they may have moved to a different resource and they may
      'now be overbooked
      SetDetailButtonsState
    End If
  End With
  'when the move a bar the number of max passengers may be different, so...
  SetBarText nIndex, nBar
  UpdatePartyBarColorFromBarText nIndex, nBar
End Sub
Private Sub schMain_BarPreDrop(ByVal nIndex As Integer, ByVal nBar As Integer, ByVal nStartDate As Long, ByVal nEndDate As Long, ByVal nStartTime As Long, ByVal nEndTime As Long, ByVal nRow As Integer, ByVal bNewApp As Boolean)
  'nIndex is the Index for the old row
  'nRow is where they are attempting to drop
  Dim sBarKeyID As String
  Dim sResource As String
  Dim objParty As clsParty
  Dim nPassengersInParty As Integer
  Dim nMaxPassengers As Integer
  If (Not bNewApp) And (Not mobjAppSettings.AllowOverbooking) And (nIndex <> nRow) Then
    sBarKeyID = schMain.BarKeyID(nIndex, nBar)
    Set objParty = mobjParties(sBarKeyID)
    nPassengersInParty = objParty.PassengerCount
    'nRow immediately available from event parameters
    'so use GetResourceMaxPassByListIndex because #1 efficient
    nMaxPassengers = GetMaxPassByListIndex(nRow)
    If nPassengersInParty > nMaxPassengers Then
      schMain.CancelDrop
      sResource = schMain.ListText(nRow)
      MsgBox "The party will not be moved because moving it to the " & sResource & " will cause a state of overbooking.", vbOKOnly + vbInformation, "Overbooking"
    End If
  End If
End Sub
Private Sub schMain_BarSelect(ByVal nIndex As Integer, ByVal nBar As Integer)
  Dim sBarKeyID As String
  Dim objParty As clsParty
  sBarKeyID = schMain.BarKeyID(nIndex, nBar)
  If mobjParties.KeyExists(sBarKeyID) Then
    Set objParty = mobjParties(sBarKeyID)
    ShowPartyDetail
  Else 'this is a new party
    CreateNewParty nIndex, nBar
  End If
End Sub
Private Sub CreateNewParty(nIndex As Integer, nBar As Integer)
  Dim sNewID As String ' will hold word new and info to get at bar
  Dim objParty As clsParty
  schMain.BarKeyID(nIndex, nBar) = CStr(NEW_PARTY_ID)
  Set objParty = mobjParties.Add(NEW_PARTY_ID)
  cboPilot.ListIndex = -1
  SetBarText nIndex, nBar
  UpdateTotalWeightTextBox 0, GetMaxWeightByListIndex(schMain.ListIndex)
  CreateNewReservation objParty
End Sub
Private Sub CreateNewReservation(objParty As clsParty)
  Dim objReservation As clsReservation
  Set objReservation = objParty.Reservations.Add(NEW_RES_ID)
  SetUpDetailGridsForNewReservation
  lstReservations.AddItem NEW_RES_ID
  lstReservations.ListIndex = lstReservations.NewIndex
  cboAgent.ListIndex = -1
  txtDateMade.Text = FormatDateTime(Now, vbShortDate)
  txtNotes.Text = ""
  ProgramState = psNEW_RESERVATION
End Sub
Private Sub SetUpDetailGridsForNewReservation()
  grdPassengers.Rows = 1
  grdPassengers.AddItem "Total Price:" & vbTab & "0" & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "Total Weight:" & vbTab & "0"
    
  grdProducts.Rows = 1
  grdProducts.AddItem vbTab & vbTab & "Total:" & vbTab & "0"
  
  
  grdPayments.Rows = 1
  grdPayments.AddItem vbTab & vbTab & vbTab & "Tour Price Total:" & vbTab & "0"
  grdPayments.AddItem vbTab & vbTab & vbTab & "Products Total:" & vbTab & "0"
  grdPayments.AddItem vbTab & vbTab & vbTab & "Subtotal:" & vbTab & "0"
  grdPayments.AddItem vbTab & vbTab & vbTab & TAXRATE_CELL_PREFIX & CStr(mobjAppSettings.TaxRate) & vbTab & "0"
  grdPayments.AddItem vbTab & vbTab & vbTab & "Grand Total:" & vbTab & "0"
  grdPayments.AddItem vbTab & vbTab & vbTab & "Payments Total:" & vbTab & "0"
  grdPayments.AddItem vbTab & vbTab & vbTab & "Remaining Balance:" & vbTab & "0"
End Sub
Private Sub schMain_BarSizing(ByVal nIndex As Integer, ByVal nBar As Integer, ByVal nType As Integer, ByVal lTimeStart As Long, ByVal lTimeEnd As Long, ByVal lDateStart As Long, ByVal lDateEnd As Long)
  'notice I am not calling setBarText here because
  'when this event fires the bar doesn't have its new
  'times yet so must grab them directly from this event
  'this doesn't populate the text for a new bar that is
  'being drug out for some reason
  'CHANGE THIS ONE AND THE ONE BE LOW TO GET GLOBAL CHANGE TO BAR TEXT
  'also notice that we only want to change the minutes in this routine, the passengers
  'don't change so we keep everything from the m to the end of the string where the
  'string is in the form 50m 5/8
  Dim sBarText As String
  Dim sInfoToKeep As String
  sBarText = schMain.BarText(nIndex, nBar)
  sInfoToKeep = VBA.Right$(sBarText, Len(sBarText) - InStr(sBarText, "m") + 1)
  schMain.BarText(nIndex, nBar) = CStr(lTimeEnd - lTimeStart) & sInfoToKeep
End Sub
Private Sub schMain_KeyUp(KeyCode As Integer, Shift As Integer)
  Dim objParty As clsParty
  Set objParty = GetSelectedParty
  If Not objParty Is Nothing Then
    If KeyCode = vbKeyDelete Then DeleteSelectedParty
  End If
End Sub
Private Function DeleteSelectedParty()
  Dim objParty As clsParty
  Dim nRes As VbMsgBoxResult
  Set objParty = GetSelectedParty
  'if on a party then
  nRes = MsgBox("Are you sure you want to delete the selected party and all of the reservations contained in the party?", vbQuestion + vbYesNo, "Delete Party?")
  If nRes = vbYes Then
    'remove from database
    objParty.Delete mCon
    'remove from object hierarchy
    mobjParties.Remove CStr(objParty.PartyID)
    'remove the TimeBar
    schMain.DeleteTimeBar schMain.ListIndex, schMain.Bar
    'clear the reservations for lstReservations
    lstReservations.Clear
    'all it needs is this?
    'SetReservationBrowseButtonsState
    ShowPartyDetail
  End If
End Function
Private Function GetSelectedParty() As clsParty
  If schMain.ListIndex = 0 Or schMain.Bar = 0 Then
    Set GetSelectedParty = Nothing
  Else
    Set GetSelectedParty = mobjParties(schMain.BarKeyID(schMain.ListIndex, schMain.Bar))
  End If
End Function
Private Function GetSelectedReservation() As clsReservation
  Dim objParty As clsParty
  Set objParty = GetSelectedParty
  If objParty Is Nothing Then
    Set GetSelectedReservation = Nothing
  Else
    If lstReservations.Text = NEW_RES_ID Then
      Set GetSelectedReservation = objParty.Reservations(NEW_RES_ID)
    Else
      Set GetSelectedReservation = objParty.Reservations(CStr(lstReservations.ItemData(lstReservations.ListIndex)))
    End If
  End If
End Function
Private Property Get ProgramState() As eProgramState
  'notice that the cue for the ProgramState is taken
  'out of the UI, if the cmdSaveEdit buttons has a caption
  'of Edit, then the user is either in New or Editing reservation
  'state
  If cmdSaveEdit.Caption = "&Edit" Then
    ProgramState = psBROWSING
  Else
    If lstReservations.Text = NEW_RES_ID Then
      ProgramState = psNEW_RESERVATION
    Else
      ProgramState = psEDITING_RESERVATION
    End If
  End If
End Property
Private Property Let ProgramState(theProgramState As eProgramState)
  Select Case theProgramState
    Case psBROWSING
      dpMain.Enabled = True
      schMain.Enabled = True
      schMain.BackColor = vbWindowBackground
      cmdSaveEdit.Caption = "&Edit"
      cmdCancelDelete.Caption = "&Delete"
      lstReservations.Enabled = True
      cboPilot.Locked = True
      cboPilot.BackColor = vbInactiveBorder
      cboAgent.Locked = True
      cboAgent.BackColor = vbInactiveBorder
      txtNotes.Locked = True
      txtNotes.BackColor = vbInactiveBorder
      txtDateMade.Locked = True
      txtDateMade.BackColor = vbInactiveBorder
      cmdAddDetailItem.Enabled = False
      cmdDeleteDetailItem.Enabled = False
      grdPassengers.Editable = False
      grdProducts.Editable = False
      grdPayments.Editable = False
      grdPassengers.BackColor = vbInactiveBorder
      grdPayments.BackColor = vbInactiveBorder
      grdProducts.BackColor = vbInactiveBorder
    Case psNEW_RESERVATION, psEDITING_RESERVATION
      dpMain.Enabled = False
      schMain.Enabled = False
      schMain.BackColor = vbInactiveBorder
      cmdNew.Enabled = False
      cmdSaveEdit.Caption = "&Save"
      cmdCancelDelete.Caption = "&Cancel"
      lstReservations.Enabled = False
      cboPilot.Locked = False
      cboPilot.BackColor = vbWindowBackground
      cboAgent.Locked = False
      cboAgent.BackColor = vbWindowBackground
      txtNotes.Locked = False
      txtNotes.BackColor = vbWindowBackground
      txtDateMade.Locked = False
      txtDateMade.BackColor = vbWindowBackground
      grdPassengers.Editable = True
      grdProducts.Editable = True
      grdPayments.Editable = True
      grdPassengers.BackColor = vbWindowBackground
      grdPayments.BackColor = vbWindowBackground
      grdProducts.BackColor = vbWindowBackground
  End Select
  SetToolbarMenuState
  SetReservationButtonsState
  SetDetailButtonsState
End Property
Private Sub schMain_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
  'if OnParty then BarSelect will take care of the ShowPartyDetail
  'otherwise, we do it to clear everything
  If Not OnParty Then ShowPartyDetail
End Sub
Private Sub schMain_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
  SetToolbarMenuState
  If Button = vbRightButton And ((Not ProgramState = psEDITING_RESERVATION) Or (ProgramState = psNEW_RESERVATION)) Then
    PopupMenu mnu_schMainPopup
  End If
End Sub
Private Sub tabgrdDetail_BeforeClick(Cancel As Integer)
  If ProgramState = psEDITING_RESERVATION Or ProgramState = psNEW_RESERVATION Then
    If Not SelectedGridValidates Then Cancel = True
  End If
End Sub
Private Function SelectedGridValidates() As Boolean
    Select Case tabgrdDetail.SelectedItem.Index
      Case PASS_TAB
        SelectedGridValidates = PassengerDataValidates
      Case PAYM_TAB
        SelectedGridValidates = PaymentsDataValidates
      Case PROD_TAB
        SelectedGridValidates = ProductsDataValidates
    End Select
End Function
Private Function PassengerDataValidates() As Boolean
  'notice that we need not check numerics in these subs
  'because we did that on ValidateEdits but we still need to
  'run to check for blanks
  'also notice we do not check against AllowZeroPassengers,
  'that is only checked when press save in DataValidates function
  Dim sField As String
  Dim nCol As Integer
  Dim nRow As Integer
  PassengerDataValidates = True
  For nRow = 1 To grdPassengers.Rows - (PASS_SUMMARY_ROWS + 1)
    For nCol = 0 To grdPassengers.Cols - 1
      Select Case nCol
        Case PASS_COL_Address2, PASS_COL_Province
          'these can be zero length
        Case Else
          If Len(grdPassengers.TextMatrix(nRow, nCol)) = 0 Then
            grdPassengers.Row = nRow
            grdPassengers.Col = nCol
            sField = grdPassengers.TextMatrix(0, nCol)
            MsgBox sField & " is not allowed to be blank.", vbOKOnly + vbInformation, sField & " Blank"
            PassengerDataValidates = False
            Exit Function
          End If
      End Select
    Next nCol
  Next nRow
End Function
Private Function PaymentsDataValidates() As Boolean
  'notice that we need not check numerics in these subs
  'because we did that on ValidateEdits but we still need to
  'run to check for blanks
  'notice also we do not check AllowZeroPayments as that is only
  'checked when they hit save, on switch back and forth between
  'tabs it is not checked
  Dim nCol As Integer
  Dim nRow As Integer
  Dim sField As String
  PaymentsDataValidates = True
  For nRow = 1 To grdPayments.Rows - (PAYM_SUMMARY_ROWS + 1)
    For nCol = 0 To grdPayments.Cols - 1
      Select Case nCol
        Case PAYM_COL_CardNumber, PAYM_COL_NameOnCard, PAYM_COL_ExpirationDate
          'these can be zero length
        Case Else
          If Len(grdPayments.TextMatrix(nRow, nCol)) = 0 Then
            grdPayments.Row = nRow
            grdPayments.Col = nCol
            sField = grdPayments.TextMatrix(0, nCol)
            MsgBox sField & " is not allowed to be blank.", vbOKOnly + vbInformation, sField & " Blank"
            PaymentsDataValidates = False
            Exit Function
          End If
      End Select
    Next nCol
  Next nRow
End Function
Private Function ProductsDataValidates() As Boolean
  'notice that we need not check numerics in these subs
  'because we did that on ValidateEdits but we still need to
  'run to check for blanks
  Dim nCol As Integer
  Dim nRow As Integer
  Dim sField As String
  ProductsDataValidates = True
  For nRow = 1 To grdProducts.Rows - (PROD_SUMMARY_ROWS + 1)
    For nCol = 0 To grdProducts.Cols - 1
      Select Case nCol
        Case Else
          If Len(grdProducts.TextMatrix(nRow, nCol)) = 0 Then
            grdProducts.Row = nRow
            grdProducts.Col = nCol
            sField = grdProducts.TextMatrix(0, nCol)
            MsgBox sField & " is not allowed to be blank.", vbOKOnly + vbInformation, sField & " Blank"
            ProductsDataValidates = False
            Exit Function
          End If
      End Select
    Next nCol
  Next nRow
End Function
Private Sub tabgrdDetail_Click()
  Select Case tabgrdDetail.SelectedItem.Index
    Case PASS_TAB
      cmdAddDetailItem.Caption = "&Add Passenger"
      cmdDeleteDetailItem.Caption = "&Delete Passenger"
      grdPassengers.ZOrder 0
    Case PAYM_TAB
      cmdAddDetailItem.Caption = "&Add Payment"
      cmdDeleteDetailItem.Caption = "&Delete Payment"
      grdPayments.ZOrder 0
    Case PROD_TAB
      cmdAddDetailItem.Caption = "&Add Product"
      cmdDeleteDetailItem.Caption = "&Delete Product"
      grdProducts.ZOrder 0
  End Select
  SetDetailButtonsState
End Sub
Private Sub SetToolbarMenuState()
  'this even handles the popup menus
  Dim bOnParty As Boolean
  Dim nMaxPassengers As Integer
  Dim nListIndex As Integer
  Dim nBarIndex As Integer
  bOnParty = OnParty
  mnu_schMainDeleteParty.Enabled = bOnParty
  If (ProgramState = psEDITING_RESERVATION) Or (ProgramState = psNEW_RESERVATION) Then
    'in the edit or new state disable top level menus
    'and toolbars
    mnuAppSettings.Enabled = False
    mnuDataMaintenance.Enabled = False
    mnuReports.Enabled = False
    mnuExit.Enabled = False
    'won't pop up, so doesn't need to be set, otherwise
    'they would look like this
    'mnu_schMainNewParty.Enabled = False
    'mnu_schMainCutParty.Enabled = False
    'mnu_schMainCopyParty.Enabled = False
    'mnu_schMainPasteParty.Enabled = False
    'mnu_schMainDeleteParty.Enabled = False
    'mnu_lstReservationsNewReservation.Enabled = False
    'mnu_lstReservationsCutReservation.Enabled = False
    'mnu_lstReservationsCopyReservation.Enabled = False
    'mnu_lstReservationsPasteReservation.Enabled = False
    'mnu_lstReservationsDeleteReservation.Enabled = False
  Else
    mnuAppSettings.Enabled = True
    mnuDataMaintenance.Enabled = True
    mnuReports.Enabled = True
    mnuExit.Enabled = True
    mnu_schMainChangePartyDate.Enabled = bOnParty
    mnu_schMainDeleteParty.Enabled = bOnParty
    mnu_lstReservationsCutReservation.Enabled = bOnParty
    If (Not (mobjCutReservation Is Nothing)) And bOnParty Then
      'we know they are on a party so the fastest way to get
      'max passengers is through the ListIndex
      nListIndex = schMain.ListIndex
      nBarIndex = schMain.Bar
      mnu_lstReservationsPasteReservation.Enabled = (mobjCutReservation.Passengers.Count + GetNumPassengersFromBarText(nListIndex, nBarIndex)) <= GetMaxPassFromBarText(nListIndex, nBarIndex)
    Else
      mnu_lstReservationsPasteReservation.Enabled = False
    End If
    mnu_lstReservationsDeleteReservation.Enabled = bOnParty
  End If
End Sub
Private Sub SetReservationButtonsState()
  'this is for setting the state of the three
  'buttons that pertain to operations on reservations
  Dim objParty As clsParty
  Set objParty = GetSelectedParty
  If ProgramState = psBROWSING Then
    If objParty Is Nothing Then
      cmdNew.Enabled = False
      cmdSaveEdit.Enabled = False
      cmdCancelDelete.Enabled = False
    Else 'a party is selected
      cmdNew.Enabled = mobjAppSettings.AllowOverbooking Or PartyBelowMaxPassengersFromBarText(schMain.ListIndex, schMain.Bar)
      cmdSaveEdit.Enabled = True
      cmdCancelDelete.Enabled = True
      'the bar select event will take care of showing the reservation
    End If
  Else 'psEditing_Reservation or psNew_Reservation
    cmdNew.Enabled = False
    cmdCancelDelete.Enabled = True
    cmdSaveEdit.Enabled = True
  End If
End Sub
Private Sub SetDetailButtonsState()
  'this is for setting the state of the two buttons
  'that pertain to operations on the adding and
  'deleting of passengers/products/payments
  Dim nCurrentRow As Integer
  Dim nRows As Integer
  If ProgramState = psBROWSING Then
    cmdAddDetailItem.Enabled = False
    cmdDeleteDetailItem.Enabled = False
  Else  'psEditing_Reservation or psNew_Reservation
    Select Case tabgrdDetail.SelectedItem.Index
      Case PASS_TAB
        'they are editing, set up the add/delete buttons
        If mobjAppSettings.AllowOverbooking Then
          cmdAddDetailItem.Enabled = True
        Else
          cmdAddDetailItem.Enabled = PartyBelowMaxPassengersFromBarText(schMain.ListIndex, schMain.Bar)
        End If
        nCurrentRow = grdPassengers.Row
        nRows = grdPassengers.Rows
        cmdDeleteDetailItem.Enabled = ((nRows > 1) And (nCurrentRow < nRows - (PASS_SUMMARY_ROWS)))
      Case PAYM_TAB
        nCurrentRow = grdPayments.Row
        nRows = grdPayments.Rows
        cmdAddDetailItem.Enabled = True
        cmdDeleteDetailItem.Enabled = ((nRows > 1) And (nCurrentRow < nRows - (PAYM_SUMMARY_ROWS)))
      Case PROD_TAB
        nCurrentRow = grdProducts.Row
        nRows = grdProducts.Rows
        cmdAddDetailItem.Enabled = True
        cmdDeleteDetailItem.Enabled = ((nRows > 1) And (nCurrentRow < nRows - (PROD_SUMMARY_ROWS)))
    End Select
  End If
End Sub
Private Sub SetUpScheduleCtl()
  schMain.GridFrequency = mobjAppSettings.GridFrequency
End Sub
Private Sub SetUpDetailGrids()
  SetUpPassengersGrid
  SetUpProductsGrid
  SetUpPaymentsGrid
  grdPassengers.ZOrder 0
End Sub
Private Sub SetUpPassengersGrid()
  grdPassengers.FormatString = "Tour|Price|First Name|Last Name|Address|Address 2|City|State|Zip|Phone #|Weight|Province|Country"
  SetUpPassengersCombo
  grdPassengers.ColFormat(PASS_COL_TourPrice) = CURRENCY_COL_FORMAT
End Sub
Private Sub SetUpPassengersCombo()
  Dim objTourList As clsTourList
  Set objTourList = New clsTourList
  grdPassengers.ColComboList(PASS_COL_TourDescription) = objTourList.GetTourList(mCon)
End Sub
Private Sub SetUpProductsGrid()
  grdProducts.FormatString = "<Quantity|<Description|>Unit Price|>Total"
  SetUpProductsCombo
  grdProducts.ColFormat(PROD_COL_UnitPrice) = CURRENCY_COL_FORMAT
  grdProducts.ColFormat(PROD_COL_Total) = CURRENCY_COL_FORMAT
End Sub
Private Sub SetUpProductsCombo()
  Dim objProductList As clsProductList
  Set objProductList = New clsProductList
  grdProducts.ColComboList(PROD_COL_Description) = objProductList.GetProductList(mCon)
End Sub
Private Sub SetUpPaymentsGrid()
  grdPayments.FormatString = "<Payment Type|<Card Number|<Name on Card|<Expiration Date|>Amount"
  SetUpPaymentsCombo
  'this caused problems because the data was optional (might have been cash)
  'this ColEditMask wouldn't let them blank it out if they started to put
  'something in the column
  'grdPayments.ColEditMask(PAYM_COL_CardNumber) = "0000 0000 0000 0000;;*"
  grdPayments.ColFormat(PAYM_COL_ExpirationDate) = vbShortDate
  grdPayments.ColFormat(PAYM_COL_Amount) = CURRENCY_COL_FORMAT
End Sub
Private Sub SetUpPaymentsCombo()
  Dim objPaymentTypes As clsPaymentTypes
  Set objPaymentTypes = New clsPaymentTypes
  grdPayments.ColComboList(0) = objPaymentTypes.GetPaymentList(mCon)
End Sub
Private Function DataValidates() As Boolean
  DataValidates = True
  If cboPilot.ListIndex = -1 Then
    DataValidates = False
    MsgBox "You must select a pilot for this party.", vbOKOnly + vbInformation, "Select Pilot"
    cboPilot.SetFocus
    Exit Function
  End If
  If cboAgent.ListIndex = -1 Then
    DataValidates = False
    MsgBox "You must select an agent for this party.", vbOKOnly + vbInformation, "Select Agent"
    cboAgent.SetFocus
    Exit Function
  End If
  If Not IsDate(txtDateMade.Text) Then
    DataValidates = False
    MsgBox "You must select a valid date for when this reservation was made.", vbOKOnly + vbInformation, "Select Date Made"
    txtDateMade.SetFocus
    Exit Function
  End If
  If grdPassengers.Rows - (PASS_SUMMARY_ROWS + 1) = 0 Then
    DataValidates = False
    MsgBox "You must add passengers to this reservation.", vbOKOnly + vbInformation, "Add Passengers"
    tabgrdDetail.Tabs(PASS_TAB).Selected = True
    Exit Function
  End If
  If Not mobjAppSettings.AllowZeroPayments Then
    If grdPayments.Rows - (PAYM_SUMMARY_ROWS + 1) = 0 Then
      DataValidates = False
      MsgBox "You must add payments to this reservation.", vbOKOnly + vbInformation, "Add Payments"
      tabgrdDetail.Tabs(PAYM_TAB).Selected = True
      Exit Function
    End If
  End If
End Function
Private Sub PutGridDataInReservation(objReservation As clsReservation)
  objReservation.Passengers.LoadFromGrid grdPassengers
  objReservation.Payments.LoadFromGrid grdPayments
  objReservation.Products.LoadFromGrid grdProducts
End Sub
Private Sub grdPayments_RowColChange()
  If ProgramState = psNEW_RESERVATION Or ProgramState = psEDITING_RESERVATION Then
    SetDetailButtonsState
  End If
End Sub
Public Function GetPassengerRowStringFromGrid(nRow As Integer) As String
  'used to duplicate a row in the passenger grid when they add a new passenger
  'will duplicate all fields but FirstName and Weight
  Dim nCols As Integer
  Dim nLoop As Integer
  Dim sTemp As String
  nCols = grdPassengers.Cols
  For nLoop = 0 To (nCols - 1)
    If nLoop = PASS_COL_FirstName Then  'to make the first name blank for new row or weight
      sTemp = sTemp & vbTab
    ElseIf nLoop = PASS_COL_Weight Then
      sTemp = sTemp & "0" & vbTab
    Else
      sTemp = sTemp & grdPassengers.TextMatrix(nRow, nLoop) & vbTab
    End If
  Next nLoop
  GetPassengerRowStringFromGrid = VBA.Left$(sTemp, Len(sTemp) - 1)
End Function
Private Function OnParty() As Boolean
  Dim objParty As clsParty
  Set objParty = GetSelectedParty
  OnParty = Not (GetSelectedParty Is Nothing)
End Function
Private Sub SetUpScreen()
  Dim sSplitterTop As String
  Dim objWindowPosition As clsWindowPosition
  Set objWindowPosition = New clsWindowPosition
  objWindowPosition.AppName = REGISTRY_APP_NAME
  objWindowPosition.PositionWindow Me
  sSplitterTop = objWindowPosition.RetrieveCustom("SplitterTop")
  If IsLong(sSplitterTop) Then cmdSplitter.Top = CLng(sSplitterTop)
End Sub
Public Sub ShowScheduler(con As Connection)
  Set mCon = con
  Set mobjParties = New clsParties
  Set mobjAppSettings = New clsAppSettings
  mobjAppSettings.Init mCon
  SetUpScreen
  SetUpScheduleCtl
  SetUpDetailGrids
  SetUpResourcesUIStrings
  dpMain.Value = FormatDateTime(Now, vbShortDate)
  RefreshAllData
  Me.Show
End Sub
Private Sub SetUpResourcesUIStrings()
  mnuDMResources.Caption = mobjAppSettings.ResourceNamePlural
  schMain.TitleText = mobjAppSettings.ResourceNamePlural
End Sub
Private Function GetSelectedBarTourDuration() As Integer
  'this function must only be called when you KNOW a bar is selected
  GetSelectedBarTourDuration = GetTourDurationFromBarText(schMain.ListIndex, schMain.Bar)
End Function
Private Sub SetBarText(ByVal nIndex As Integer, ByVal nBar As Integer)
  'also check out schMain_BarSizing
  'this set bar text is for when first showing bars so it uses no methods
  'that look at the text of the bar
  Dim sBarKeyID As String
  Dim objParty As clsParty
  Dim lTimeStart As Long
  Dim lTimeEnd As Long
  Dim lTourLength As Long
  'first we get tour length in minutes
  lTimeStart = schMain.BarTimeStart(nIndex, nBar)
  lTimeEnd = schMain.BarTimeEnd(nIndex, nBar)
  'now we retrieve the number of passengers in the party
  sBarKeyID = schMain.BarKeyID(nIndex, nBar)
  'when they create a new party this is called
  'but the party isn't in mobjParties yet so we
  'trap for that possiblity here
  If mobjParties.KeyExists(sBarKeyID) Then
    Set objParty = mobjParties(sBarKeyID)
    schMain.BarText(nIndex, nBar) = CStr(lTimeEnd - lTimeStart) & "m " & CStr(objParty.PassengerCount) & "/" & CStr(GetMaxPassByListIndex(nIndex))
  Else
    schMain.BarText(nIndex, nBar) = CStr(lTimeEnd - lTimeStart) & "m 0/" & CStr(GetMaxPassByListIndex(nIndex))
  End If
End Sub
Private Function GetTourDurationFromBarText(nItemIndex As Integer, nBarIndex As Integer) As Integer
  Dim sBarText As String
  sBarText = schMain.BarText(nItemIndex, nBarIndex)
  GetTourDurationFromBarText = CInt(VBA.Left$(sBarText, InStr(sBarText, "m") - 1))
End Function
Private Function GetMaxPassFromBarText(nItemIndex As Integer, nBarIndex As Integer) As Integer
  Dim sBarText As String
  sBarText = schMain.BarText(nItemIndex, nBarIndex)
  GetMaxPassFromBarText = CInt(VBA.Right$(sBarText, Len(sBarText) - InStr(sBarText, "/")))
End Function
Private Function GetNumPassengersFromBarText(nItemIndex As Integer, nBarIndex As Integer) As Integer
  Dim sBarText As String
  Dim nSpacePosition As Integer
  sBarText = schMain.BarText(nItemIndex, nBarIndex)
  nSpacePosition = InStr(sBarText, " ")
  GetNumPassengersFromBarText = CInt(VBA.Mid$(sBarText, nSpacePosition + 1, InStr(sBarText, "/") - (nSpacePosition + 1)))
End Function
Private Sub IncrementNumPassengersInBarText(nItemIndex As Integer, nBarIndex As Integer)
  Dim nCurrentPassengers As Integer
  nCurrentPassengers = GetNumPassengersFromBarText(nItemIndex, nBarIndex)
  nCurrentPassengers = nCurrentPassengers + 1
  schMain.BarText(nItemIndex, nBarIndex) = CStr(GetTourDurationFromBarText(nItemIndex, nBarIndex) & "m " & CStr(nCurrentPassengers) & "/" & CStr(GetMaxPassFromBarText(nItemIndex, nBarIndex)))
End Sub
Private Sub DecrementNumPassengersInBarText(nItemIndex As Integer, nBarIndex As Integer)
  Dim nCurrentPassengers As Integer
  nCurrentPassengers = GetNumPassengersFromBarText(nItemIndex, nBarIndex)
  nCurrentPassengers = nCurrentPassengers - 1
  schMain.BarText(nItemIndex, nBarIndex) = CStr(GetTourDurationFromBarText(nItemIndex, nBarIndex) & "m " & CStr(nCurrentPassengers) & "/" & CStr(GetMaxPassFromBarText(nItemIndex, nBarIndex)))
End Sub
Private Function GetTotalPartyWeightFromTextBox() As Integer
  Dim sTotalWeightString As String
  sTotalWeightString = txtTotalWeight.Text
  GetTotalPartyWeightFromTextBox = CInt(VBA.Left$(sTotalWeightString, InStr(sTotalWeightString, "/") - 1))
End Function
Private Function GetMaxPartyWeightFromTextBox() As Integer
  Dim sTotalWeightString As String
  sTotalWeightString = txtTotalWeight.Text
  GetMaxPartyWeightFromTextBox = CInt(VBA.Right$(sTotalWeightString, Len(sTotalWeightString) - InStr(sTotalWeightString, "/")))
End Function
'Private Function PartyBelowMaxPassengers(objParty As clsParty, nResourceItemIndex As Integer) As Boolean
'  Dim nMaxPassengers As Integer
'  nMaxPassengers = GetResourceMaxPassByListIndex(nResourceItemIndex)
'  PartyBelowMaxPassengers = (objParty.PassengerCount < nMaxPassengers)
'End Function
'Private Function PartyBeingEditedBelowMaxPassengers(objParty As clsParty, objReservation As clsReservation)
'  'when a party is in an edit state you can't call
'  'party below max passengers because the reservation
'  'information isn't written out to the object model
'  'until the reservation is saved
'  'We must take the number of passengers straight
'  'off a row count of the grdPassengers grid
'  Dim nMaxPassengers As Integer
'  Dim nPassengersInParty As Integer
'  Dim nPassengersInGrid As Integer
'  Dim nPassengersInReservation As Integer
'  'the party being edited must be selected so the
'  'fastest way to a passenger count is through the
'  'ListIndex
'  nMaxPassengers = GetResourceMaxPassByListIndex(schMain.ListIndex)
'  nPassengersInParty = objParty.PassengerCount
'  nPassengersInReservation = objReservation.Passengers.Count
'  nPassengersInGrid = grdPassengers.Rows - (PASS_SUMMARY_ROWS + 1)
'  PartyBeingEditedBelowMaxPassengers = (nMaxPassengers - (nPassengersInParty - nPassengersInReservation + nPassengersInGrid) > 0)
'End Function
'function not needed at this time
'Private Function GetResourceMaxPassByResourceID(lResourceID As Long) As Integer
'  'if only the ResourceID is immediately available
'  'you should call this one
'  Dim nListIndex As Integer
'  nListIndex = GetResourceItemIndex(lResourceID)
'  GetResourceMaxPassByResourceID = GetResourceMaxPassByListIndex(nListIndex)
'End Function
'function not needed at this time
'Private Function GetResourceMaxPassByPartyID(lPartyID As Long) As Integer
'  'if the ListIndex is not immediately available
'  'but the PartyID is immediately available then call
'  'this one
'  Dim sKeyID As String
'  Dim nListIndex As Integer
'  sKeyID = CStr(lPartyID)
'  nListIndex = schMain.KeyIDItem(sKeyID)
'  GetResourceMaxPassByPartyID = GetResourceMaxPassByListIndex(nListIndex)
'End Function
'***************END THREE WAYS TO DO SAME THING***************
'Private Sub UpdatePartyBarColor(objParty As clsParty)
'  Dim bOneMinuteOverlap As Boolean
'  Dim nResourceItemIndex As Integer
'  Dim nBarIndex As Integer
'  Dim nConflictingBar As Integer
'  Dim sKeyID As String
'  If objParty.PartyID = 0 Then
'    'this is a brand new party that in an edit state
'    'it doesn't have a match up between its PartyID
'    'and the BarKeyID, so don't try to look for the
'    'bar by using the PartyID as a BarKeyID, instead
'    'just grab what is selected
'    nResourceItemIndex = schMain.ListIndex
'    nBarIndex = schMain.Bar
'  Else
'    sKeyID = CStr(objParty.PartyID)
'    'we find the bar that goes with the Party
'    'via the PartyID
'    nResourceItemIndex = schMain.KeyIDItem(sKeyID)
'    nBarIndex = schMain.KeyIDBar(sKeyID, nResourceItemIndex)
'  End If
'  nConflictingBar = schMain.FindFirstBar(nResourceItemIndex, nBarIndex, nResourceItemIndex)
'  Do Until nConflictingBar = 0
'    If nConflictingBar > 0 Then
'      'we check to see if it is the one minute conflict
'      'if it is, we don't want blue
'      If schMain.BarTimeStart(nResourceItemIndex, nBarIndex) < schMain.BarTimeStart(nResourceItemIndex, nConflictingBar) Then
'        'the bar that caused this sub to fire starts before the conflicting
'        'bar
'        bOneMinuteOverlap = (schMain.BarTimeEnd(nResourceItemIndex, nBarIndex) = schMain.BarTimeStart(nResourceItemIndex, nConflictingBar))
'      ElseIf schMain.BarTimeStart(nResourceItemIndex, nConflictingBar) < schMain.BarTimeStart(nResourceItemIndex, nBarIndex) Then
'        'the bar that is causing the conflict starts before the bar that caused
'        'this event to fire
'        bOneMinuteOverlap = (schMain.BarTimeEnd(nResourceItemIndex, nConflictingBar) = schMain.BarTimeStart(nResourceItemIndex, nBarIndex))
'      End If
'      If Not bOneMinuteOverlap Then
'        'set the bar in question to blue and then make it topmost
'        'NOTE:  THE WILL CHANGE THE INDEX VALUE OF THE TIME BAR
'        schMain.BarBackColor(nResourceItemIndex, nBarIndex) = vbBlue
'        schMain.BringToFront nResourceItemIndex, nBarIndex
'        Exit Sub
'      End If
'    End If
'    nConflictingBar = schMain.FindNextBar(nResourceItemIndex, nBarIndex, nResourceItemIndex)
'  Loop
'  If PartyBelowMaxPassengers(objParty, nResourceItemIndex) Then
'    schMain.BarBackColor(nResourceItemIndex, nBarIndex) = vbGreen
'  Else
'    schMain.BarBackColor(nResourceItemIndex, nBarIndex) = vbRed
'  End If
'End Sub
'Private Function GetBarTourDuration(nItemIndex As Integer, nBarIndex As Integer) As Integer
'  Dim lTimeStart As Long
'  Dim lTimeEnd As Long
'  lTimeStart = schMain.BarTimeStart(nItemIndex, nBarIndex)
'  lTimeEnd = schMain.BarTimeEnd(nItemIndex, nBarIndex)
'  GetBarTourDuration = CInt(lTimeEnd - lTimeStart)
'End Function

