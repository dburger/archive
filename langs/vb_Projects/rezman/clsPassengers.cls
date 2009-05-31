VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsPassengers"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mobjPassengers As Collection

Public Function Add() As clsPassenger
  Dim objPassenger As clsPassenger
  Set objPassenger = New clsPassenger
  mobjPassengers.Add objPassenger
  Set Add = objPassenger
End Function
Public Function Remove(vItemKey As Variant)
  mobjPassengers.Remove vItemKey
End Function
Public Function Item(vIndex As Variant) As clsPassenger
Attribute Item.VB_UserMemId = 0
  Set Item = mobjPassengers.Item(vIndex)
End Function
Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
  Set NewEnum = mobjPassengers.[_NewEnum]
End Function
Public Function Count() As Integer
  Count = mobjPassengers.Count
End Function
Public Function SetAllDirty()
  Dim objPassenger As clsPassenger
  For Each objPassenger In mobjPassengers
    objPassenger.Dirty = True
  Next objPassenger
End Function
Private Sub Class_Initialize()
  Set mobjPassengers = New Collection
End Sub
Private Sub Class_Terminate()
  'Do Until mobjPassengers.Count = 0
  '  mobjPassengers.Remove 1
  'Loop
  Set mobjPassengers = Nothing
End Sub
Public Sub Load(lReservationID As Long, con As Connection)
  Dim rs As Recordset
  Dim sSQL As String
  Dim objPassenger As clsPassenger
  sSQL = "select PassengerID, Address, Address2, City, Country, FirstName, LastName, PhoneNumber, Province, State, Weight, Zip, TourListID, TourPrice from Passengers where ReservationID = " & lReservationID
  Set rs = New Recordset
  rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
  Do Until rs.EOF
    Set objPassenger = Add()
    With objPassenger
      .Address = rs!Address
      'this is allowed to be null so make sure to safely
      'convert to space
      .Address2 = VBA.Format$(rs!Address2)
      .City = rs!City
      .Country = rs!Country
      .FirstName = rs!FirstName
      .LastName = rs!LastName
      .PhoneNumber = rs!PhoneNumber
      'this is allowed to be null so make sure to safely
      'convert to space
      .Province = VBA.Format$(rs!Province)
      .State = rs!State
      .Weight = rs!Weight
      .Zip = rs!Zip
      .TourListID = rs!TourListID
      .TourPrice = rs!TourPrice
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
  Dim objPassenger As clsPassenger
  'Do Until mobjPassengers.Count = 0
  '  mobjPassengers.Remove 1
  'Loop
  Set mobjPassengers = New Collection
  nRow = 1
  nCols = grd.Cols
  Do Until nRow = (grd.Rows - PASS_SUMMARY_ROWS) 'avoid the summary row
    Set objPassenger = Add
    objPassenger.LoadFromGrid grd, nRow
    objPassenger.Dirty = True
    nRow = nRow + 1
  Loop
End Sub
Public Sub Save(con As Connection, lReservationID As Long)
  Dim objPassenger As clsPassenger
  Dim sSQL As String
  sSQL = "delete * from Passengers where ReservationID=" & lReservationID
  con.Execute sSQL
  For Each objPassenger In mobjPassengers
    If objPassenger.Dirty Then objPassenger.Save con, lReservationID
  Next objPassenger
End Sub
Public Function TotalWeight() As Integer
  Dim objPassenger As clsPassenger
  Dim nWeightTotal As Integer
  For Each objPassenger In mobjPassengers
    nWeightTotal = nWeightTotal + objPassenger.Weight
  Next objPassenger
  TotalWeight = nWeightTotal
End Function
Public Function TotalTourPrice() As Currency
  Dim objPassenger As clsPassenger
  Dim cTourPriceTotal As Currency
  For Each objPassenger In mobjPassengers
    cTourPriceTotal = cTourPriceTotal + objPassenger.TourPrice
  Next objPassenger
  TotalTourPrice = cTourPriceTotal
End Function
Public Function PassengerTotalsRowString() As String
  PassengerTotalsRowString = "Total Price:" & vbTab & TotalTourPrice & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & vbTab & "Total Weight:" & vbTab & TotalWeight
End Function
Public Function TourPriceTotalRowStringForPayments() As String
  'this is used to place in the summary location of the payments grid
  TourPriceTotalRowStringForPayments = vbTab & vbTab & vbTab & "Tour Price Total:" & vbTab & FormatCurrency(TotalTourPrice, 2, vbTrue, vbFalse, vbTrue)
End Function
Public Function RTourPriceTotalRowStringForPayments() As String
  'this R version has been created to use with reports because
  'putting the words Tour Price total in col 5 takes too much room
  RTourPriceTotalRowStringForPayments = vbTab & vbTab & "Tour Price Total:" & vbTab & vbTab & FormatCurrency(TotalTourPrice, 2, vbTrue, vbFalse, vbTrue)
End Function

