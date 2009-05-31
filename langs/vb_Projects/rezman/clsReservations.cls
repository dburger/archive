VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsReservations"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private mobjReservations As Collection
Public Function Add(sReservationID As String) As clsReservation
  Dim objReservation As New clsReservation
  mobjReservations.Add objReservation, sReservationID
  Set Add = objReservation
End Function
Public Sub AddExistingReservation(objReservation As clsReservation)
  mobjReservations.Add objReservation, CStr(objReservation.ReservationID)
End Sub
Public Function Remove(vItemKey As Variant)
  mobjReservations.Remove vItemKey
End Function
Public Function Item(vIndex As Variant) As clsReservation
Attribute Item.VB_UserMemId = 0
  Set Item = mobjReservations.Item(vIndex)
End Function
Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
  Set NewEnum = mobjReservations.[_NewEnum]
End Function
Public Function Count() As Integer
  Count = mobjReservations.Count
End Function
Private Sub Class_Initialize()
  Set mobjReservations = New Collection
End Sub
Private Sub Class_Terminate()
  'Do Until mobjReservations.Count = 0
  '  mobjReservations.Remove 1
  'Loop
  Set mobjReservations = Nothing
End Sub
Public Sub LoadFromPartyID(lPartyID As Long, con As Connection)
  'this will load all reservations that belong to lPartyID
  Dim rs As Recordset
  Dim sSQL As String
  Dim objReservation As clsReservation
  sSQL = "select ReservationID, AgentID, DateMade, Notes, TaxRate from Reservations where PartyID = " & lPartyID
  Set rs = New Recordset
  rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
  Do Until rs.EOF
    Set objReservation = Add(CStr(rs!ReservationID))
    With objReservation
      .AgentID = rs!AgentID
      .DateMade = rs!DateMade
      'this one is allowed to be empty so
      .Notes = VBA.Format$(rs!Notes)
      .TaxRate = rs!TaxRate
      .ReservationID = rs!ReservationID
      'the above fire events that make the reservation Dirty, so
      'we must set the Dirty to false
      .Dirty = False
      .Passengers.Load .ReservationID, con
      .Payments.Load .ReservationID, con
      .Products.Load .ReservationID, con
    End With
    rs.MoveNext
  Loop
End Sub
Public Sub LoadFromResID(lReservationID As Long, con As Connection)
  'this will load the reservation specified by
  'lReservationID
  Dim rs As Recordset
  Dim sSQL As String
  Dim objReservation As clsReservation
  sSQL = "select PartyID, AgentID, DateMade, Notes, TaxRate from Reservations where ReservationID = " & lReservationID
  Set rs = New Recordset
  rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
  Set objReservation = Add(CStr(lReservationID))
  With objReservation
    .AgentID = rs!AgentID
    .DateMade = rs!DateMade
    'this is allowed to be blank so...
    .Notes = VBA.Format$(rs!Notes)
    .TaxRate = rs!TaxRate
    .ReservationID = lReservationID
    'the above fire events that make the reservation Dirty, so
    'we must set the Dirty to false
    .Dirty = False
    .Passengers.Load .ReservationID, con
    .Payments.Load .ReservationID, con
    .Products.Load .ReservationID, con
  End With
End Sub
Public Sub Save(con As Connection, lPartyID As Long)
  Dim objReservation As clsReservation
  For Each objReservation In mobjReservations
    If objReservation.Dirty Then objReservation.Save con, lPartyID
  Next objReservation
End Sub
