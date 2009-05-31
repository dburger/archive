VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsPayments"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private mobjPayments As New Collection
Public Function Add() As clsPayment
  Dim objPayment As New clsPayment
  mobjPayments.Add objPayment
  Set Add = objPayment
End Function
Public Function Remove(vItemKey As Variant)
  mobjPayments.Remove vItemKey
End Function
Public Function Item(vIndex As Variant) As clsPayment
Attribute Item.VB_UserMemId = 0
  Set Item = mobjPayments.Item(vIndex)
End Function
Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
  Set NewEnum = mobjPayments.[_NewEnum]
End Function
Public Function Count() As Integer
  Count = mobjPayments.Count
End Function
Public Function SetAllDirty()
  Dim objPayment As clsPayment
  For Each objPayment In mobjPayments
    objPayment.Dirty = True
  Next objPayment
End Function
Private Sub Class_Initialize()
  Set mobjPayments = New Collection
End Sub
Private Sub Class_Terminate()
  'Do Until mobjPayments.Count = 0
  '  mobjPayments.Remove 1
  'Loop
  Set mobjPayments = Nothing
End Sub
Public Sub Load(lReservationID As Long, con As Connection)
  Dim rs As Recordset
  Dim sSQL As String
  Dim objPayment As clsPayment
  sSQL = "select PaymentID, ReservationID, PaymentTypeID, Amount, CardNumber, NameOnCard, ExpirationDate from Payments where ReservationID = " & lReservationID
  Set rs = New Recordset
  rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
  Do Until rs.EOF
    Set objPayment = Add()
    With objPayment
      .Amount = rs!Amount
      'this one is allowed to be blank, so we change to
      'empty string in object property
      .CardNumber = VBA.Format$(rs!CardNumber)
      .NameOnCard = VBA.Format$(rs!NameOnCard)
      .ExpirationDate = rs!ExpirationDate
      .PaymentTypeID = rs!PaymentTypeID
      .ReservationID = lReservationID
      'the above fire events that make it Dirty, so
      'we must change it to false
      .Dirty = False
    End With
    rs.MoveNext
  Loop
End Sub
Public Sub LoadFromGrid(grd As VSFlexGrid)
  Dim nRow As Integer
  Dim nCols As Integer
  Dim objPayment As clsPayment
  'Do Until mobjPayments.Count = 0
  '  mobjPayments.Remove 1
  'Loop
  Set mobjPayments = New Collection
  nRow = 1
  nCols = grd.Cols
  Do Until nRow = (grd.Rows - PAYM_SUMMARY_ROWS) 'avoid the three total rows
    Set objPayment = Add
    objPayment.LoadFromGrid grd, nRow
    objPayment.Dirty = True
    nRow = nRow + 1
  Loop
End Sub
Public Sub Save(con As Connection, lReservationID As Long)
  Dim objPayment As clsPayment
  Dim sSQL As String
  sSQL = "delete * from Payments where ReservationID=" & lReservationID
  con.Execute sSQL
  For Each objPayment In mobjPayments
    If objPayment.Dirty Then objPayment.Save con, lReservationID
  Next objPayment
End Sub
Public Function GetPaymentTotal() As Currency
  Dim objPayment As clsPayment
  Dim cTemp As Currency
  For Each objPayment In mobjPayments
    cTemp = cTemp + objPayment.Amount
  Next objPayment
  GetPaymentTotal = cTemp
End Function
Public Function GetRemainingBalance(fTaxRate As Single, cTourPriceTotal As Currency, cProductsTotal As Currency) As Currency
  GetRemainingBalance = ((1 + fTaxRate) * (cTourPriceTotal + cProductsTotal)) - GetPaymentTotal
End Function
Public Function SubtotalRowString(cTourPriceTotal As Currency, cProductsTotal As Currency) As String
  SubtotalRowString = vbTab & vbTab & vbTab & "Subtotal:" & vbTab & FormatCurrency(cTourPriceTotal + cProductsTotal, 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function RSubtotalRowString(cTourPriceTotal As Currency, cProductsTotal As Currency) As String
  'this R version was created because putting the words
  'in col 5 took up too much room
  RSubtotalRowString = vbTab & vbTab & "Subtotal:" & vbTab & vbTab & FormatCurrency(cTourPriceTotal + cProductsTotal, 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function TaxRowString(fTaxRate As Single, cTourPriceTotal As Currency, cProductsTotal As Currency) As String
  TaxRowString = vbTab & vbTab & vbTab & TAXRATE_CELL_PREFIX & CStr(fTaxRate) & vbTab & FormatCurrency(fTaxRate * (cTourPriceTotal + cProductsTotal), 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function RTaxRowString(fTaxRate As Single, cTourPriceTotal As Currency, cProductsTotal As Currency) As String
  'this R version was created because putting the words
  'in col 5 took up too much room
  RTaxRowString = vbTab & vbTab & TAXRATE_CELL_PREFIX & CStr(fTaxRate) & vbTab & vbTab & FormatCurrency(fTaxRate * (cTourPriceTotal + cProductsTotal), 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function GrandTotalRowString(fTaxRate As Single, cTourPriceTotal As Currency, cProductsTotal As Currency) As String
  GrandTotalRowString = vbTab & vbTab & vbTab & "Grand Total:" & vbTab & FormatCurrency((1 + fTaxRate) * (cTourPriceTotal + cProductsTotal), 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function RGrandTotalRowString(fTaxRate As Single, cTourPriceTotal As Currency, cProductsTotal As Currency) As String
  'this R version was created because putting the words
  'in col 5 took up too much room
  RGrandTotalRowString = vbTab & vbTab & "Grand Total:" & vbTab & vbTab & FormatCurrency((1 + fTaxRate) * (cTourPriceTotal + cProductsTotal), 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function TotalPaymentsRowString() As String
  TotalPaymentsRowString = vbTab & vbTab & vbTab & "Payments Total:" & vbTab & FormatCurrency(GetPaymentTotal, 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function RTotalPaymentsRowString() As String
  'this R version was created because putting the words
  'in col 5 took up too much room
  RTotalPaymentsRowString = vbTab & vbTab & "Payments Total:" & vbTab & vbTab & FormatCurrency(GetPaymentTotal, 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function RemainingBalanceRowString(fTaxRate As Single, cTourPriceTotal As Currency, cProductsTotal As Currency) As String
  RemainingBalanceRowString = vbTab & vbTab & vbTab & "Remaining Balance:" & vbTab & FormatCurrency(GetRemainingBalance(fTaxRate, cTourPriceTotal, cProductsTotal), 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function RRemainingBalanceRowString(fTaxRate As Single, cTourPriceTotal As Currency, cProductsTotal As Currency) As String
  'this R version was created because putting the words
  'in col 5 took up too much room
  RRemainingBalanceRowString = vbTab & vbTab & "Remaining Balance:" & vbTab & vbTab & FormatCurrency(GetRemainingBalance(fTaxRate, cTourPriceTotal, cProductsTotal), 2, vbTrue, vbFalse, vbTrue)
End Function

