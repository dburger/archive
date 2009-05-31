VERSION 1.0 CLASS
BEGIN
  MultiUse = 0   'False
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Dim mfrmReport As frmReport
Private Sub Class_Initialize()
  Set mfrmReport = New frmReport
End Sub
Public Property Get TableSep() As String
  TableSep = mfrmReport.vspMain.TableSep
End Property
Public Property Let TableSep(ByVal sTableSep As String)
  mfrmReport.vspMain.TableSep() = sTableSep
End Property
Public Sub StartDoc()
  mfrmReport.vspMain.StartDoc
End Sub
Public Property Get TextAlign() As TextAlignSettings
  TextAlign = mfrmReport.vspMain.TextAlign
End Property
Public Property Let TextAlign(ByVal New_TextAlign As TextAlignSettings)
  mfrmReport.vspMain.TextAlign() = New_TextAlign
End Property
Public Property Let Text(ByVal sText As String)
  mfrmReport.vspMain.Text() = sText
End Property
Public Sub NewPage()
  mfrmReport.vspMain.NewPage
End Sub
Public Sub EndDoc()
  mfrmReport.vspMain.EndDoc
End Sub
Public Property Get Font() As Font
  Set Font = mfrmReport.vspMain.Font
End Property
Public Property Set Font(ByVal New_Font As Font)
  Set mfrmReport.vspMain.Font = New_Font
End Property
Public Sub AddTable(ByVal Format As String, ByVal Header As String, ByVal Body As String, Optional ByVal HeaderShade As Variant, Optional ByVal BodyShade As Variant, Optional ByVal Append As Variant)
  mfrmReport.vspMain.AddTable Format, Header, Body, HeaderShade, BodyShade, Append
End Sub
Public Sub StartTable()
  mfrmReport.vspMain.StartTable
End Sub
Public Property Get GetSingleTableCell(Setting As TableCellSettings, ByVal Row1 As Variant, ByVal Col1 As Variant) As Variant
  GetSingleTableCell = mfrmReport.vspMain.TableCell(Setting, Row1, Col1)
End Property
Public Property Let LetSingleTableCell(Setting As TableCellSettings, ByVal Row1 As Variant, ByVal Col1 As Variant, ByVal New_TableCell As Variant)
  mfrmReport.vspMain.TableCell(Setting, Row1, Col1) = New_TableCell
End Property
Public Sub EndTable()
  mfrmReport.vspMain.EndTable
End Sub
Public Property Let CalcTable(ByVal New_CalcTable As String)
  mfrmReport.vspMain.CalcTable() = New_CalcTable
End Property
Public Property Get Y2() As Variant
  Y2 = mfrmReport.vspMain.Y2
End Property
Public Property Let Y2(ByVal New_Y2 As Variant)
  mfrmReport.vspMain.Y2() = New_Y2
End Property
Public Property Get PageHeight() As Double
  PageHeight = mfrmReport.vspMain.PageHeight
End Property
Public Property Let PageHeight(ByVal New_PageHeight As Double)
  mfrmReport.vspMain.PageHeight() = New_PageHeight
End Property
Public Property Get MarginBottom() As Variant
  MarginBottom = mfrmReport.vspMain.MarginBottom
End Property
Public Property Let MarginBottom(ByVal New_MarginBottom As Variant)
  mfrmReport.vspMain.MarginBottom() = New_MarginBottom
End Property
Public Property Let Caption(sCaption As String)
  mfrmReport.Caption = sCaption
End Property
Public Sub ShowReport()
  mfrmReport.UpdatePageStatus
  mfrmReport.Show
End Sub
Public Function TableBreaksPage(sTableString) As Boolean
  mfrmReport.vspMain.CalcTable = sTableString
  'putting these two lines in is great for debugging
  'table page break problems
  'mvsp.Table = sTableString
  'mvsp = vbCrLf
  TableBreaksPage = mfrmReport.vspMain.Y2 > (Me.PageHeight - Me.MarginBottom)
End Function
