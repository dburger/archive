VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsProducts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mobjProducts As New Collection

Public Function Add() As clsProduct
  Dim objProduct As New clsProduct
  mobjProducts.Add objProduct
  Set Add = objProduct
End Function
Public Function Remove(vItemKey As Variant)
  mobjProducts.Remove vItemKey
End Function
Public Function Item(vIndex As Variant) As clsProduct
Attribute Item.VB_UserMemId = 0
  Set Item = mobjProducts.Item(vIndex)
End Function
Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
  Set NewEnum = mobjProducts.[_NewEnum]
End Function
Public Function Count() As Integer
  Count = mobjProducts.Count
End Function
Public Function SetAllDirty()
  Dim objProduct As clsProduct
  For Each objProduct In mobjProducts
    objProduct.Dirty = True
  Next objProduct
End Function
Private Sub Class_Initialize()
  Set mobjProducts = New Collection
End Sub
Private Sub Class_Terminate()
  'Do Until mobjProducts.Count = 0
  '  mobjProducts.Remove 1
  'Loop
  Set mobjProducts = Nothing
End Sub
Public Sub Load(lReservationID As Long, con As Connection)
  Dim rs As Recordset
  Dim sSQL As String
  Dim objProduct As clsProduct
  sSQL = "select ProductID, ReservationID, ProductListID, UnitPrice, Quantity from Products where ReservationID = " & lReservationID
  Set rs = New Recordset
  rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
  Do Until rs.EOF
    Set objProduct = Add()
    With objProduct
      'the ones actually being stored
      .ProductID = rs!ProductID
      .ReservationID = rs!ReservationID
      .ProductListID = rs!ProductListID
      .UnitPrice = rs!UnitPrice
      .Quantity = rs!Quantity
      .Dirty = False
    End With
    rs.MoveNext
  Loop
End Sub
Public Sub LoadFromGrid(grd As vsFlexGrid)
  Dim nRow As Integer
  Dim nCols As Integer
  Dim objProduct As clsProduct
  'Do Until mobjProducts.Count = 0
  '  mobjProducts.Remove 1
  'Loop
  Set mobjProducts = New Collection
  nRow = 1
  nCols = grd.Cols
  Do Until nRow = (grd.Rows - PROD_SUMMARY_ROWS)  'avoid the three total rows
    Set objProduct = Add
    objProduct.LoadFromGrid grd, nRow
    objProduct.Dirty = True
    nRow = nRow + 1
  Loop
End Sub
Public Sub Save(con As Connection, lReservationID As Long)
  Dim objProduct As clsProduct
  Dim sSQL As String
  sSQL = "delete * from Products where ReservationID=" & lReservationID
  con.Execute sSQL
  For Each objProduct In mobjProducts
    If objProduct.Dirty Then objProduct.Save con, lReservationID
  Next objProduct
End Sub
Public Function GetProductTotal() As Currency
  Dim objProduct As clsProduct
  Dim cTemp As Currency
  For Each objProduct In mobjProducts
    cTemp = cTemp + (objProduct.Quantity * objProduct.UnitPrice)
  Next objProduct
  GetProductTotal = cTemp
End Function
Public Function TotalRowStringForPayments() As String
  TotalRowStringForPayments = vbTab & vbTab & vbTab & "Products Total:" & vbTab & FormatCurrency(GetProductTotal, 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function RTotalRowStringForPayments() As String
  'this R version has been created because putting the
  'words Product Total in col 5 took up too much room
  RTotalRowStringForPayments = vbTab & vbTab & "Products Total:" & vbTab & vbTab & FormatCurrency(GetProductTotal, 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function TotalRowString() As String
  TotalRowString = "" & vbTab & "" & vbTab & "Total:" & vbTab & FormatCurrency(GetProductTotal, 2, vbTrue, vbFalse, vbTrue)
End Function
