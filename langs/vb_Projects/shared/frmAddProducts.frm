VERSION 5.00
Object = "{8099FCC2-0A81-11D2-BAA4-04F205C10000}#1.0#0"; "VSFLEX6.OCX"
Begin VB.Form frmAddProducts 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Add Products"
   ClientHeight    =   2730
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7230
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2730
   ScaleWidth      =   7230
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VSFlex6Ctl.vsFlexGrid grdProducts 
      Align           =   1  'Align Top
      Height          =   2055
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Width           =   7230
      _cx             =   12753
      _cy             =   3625
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
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      BackColorFixed  =   -2147483633
      ForeColorFixed  =   -2147483630
      BackColorSel    =   -2147483635
      ForeColorSel    =   -2147483634
      BackColorBkg    =   -2147483636
      BackColorAlternate=   -2147483643
      GridColor       =   -2147483633
      GridColorFixed  =   -2147483632
      TreeColor       =   -2147483632
      FloodColor      =   192
      SheetBorder     =   -2147483642
      FocusRect       =   1
      HighLight       =   1
      AllowSelection  =   -1  'True
      AllowBigSelection=   -1  'True
      AllowUserResizing=   0
      SelectionMode   =   1
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
      TabBehavior     =   0
      OwnerDraw       =   0
      Editable        =   0   'False
      ShowComboButton =   -1  'True
      WordWrap        =   0   'False
      TextStyle       =   0
      TextStyleFixed  =   0
      OleDragMode     =   0
      OleDropMode     =   0
      DataMode        =   1
      VirtualData     =   -1  'True
      DataMember      =   ""
   End
   Begin VB.CommandButton cmdClose 
      Cancel          =   -1  'True
      Caption         =   "&Close"
      Height          =   495
      Left            =   5880
      TabIndex        =   1
      Top             =   2160
      Width           =   1215
   End
   Begin VB.CommandButton cmdAddProduct 
      Caption         =   "&Add Product"
      Default         =   -1  'True
      Height          =   495
      Left            =   4560
      TabIndex        =   0
      Top             =   2160
      Width           =   1215
   End
End
Attribute VB_Name = "frmAddProducts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public Event AddProduct(lProductID As Long, sDescription As String, cUnitPrice As Currency)
Private msDescriptionFld As String
Private msProductIDFld As String
Private msUnitPriceFld As String
Private mRS As Recordset
Public Sub ShowAddProducts(rs As Recordset, sProductIDFld As String, sDescriptionFld As String, sUnitPriceFld As String, frmParent As Form)
  msDescriptionFld = sDescriptionFld
  msProductIDFld = sProductIDFld
  msUnitPriceFld = sUnitPriceFld
  Set mRS = rs
  grdProducts.DataMode = flexDMBound
  Set grdProducts.DataSource = mRS
  SetColumnWidths grdProducts
  Me.Show vbModal, frmParent
End Sub
Private Sub cmdAddProduct_Click()
  RaiseEvent AddProduct(mRS(msProductIDFld), mRS(msDescriptionFld), mRS(msUnitPriceFld))
End Sub
Private Sub cmdClose_Click()
  Unload Me
End Sub
Private Sub grdProducts_DblClick()
  cmdAddProduct_Click
End Sub
