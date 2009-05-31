VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsReservation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Passengers As clsPassengers
Public Payments As clsPayments
Public Products As clsProducts

Private mlReservationID As Long
Private mlAgentID As Long
Private mdtDateMade As Date
Private mfTaxRate As Single
Private msNotes As String
Private mbDirty As Boolean

Public Property Let ReservationID(lReservationID As Long)
  mlReservationID = lReservationID
  mbDirty = True
End Property
Public Property Get ReservationID() As Long
  ReservationID = mlReservationID
End Property
Public Property Let DateMade(dtDateMade As Date)
  mdtDateMade = dtDateMade
  mbDirty = True
End Property
Public Property Get DateMade() As Date
  DateMade = mdtDateMade
End Property
Public Property Let Notes(sNotes As String)
  msNotes = sNotes
  mbDirty = True
End Property
Public Property Get Notes() As String
  Notes = msNotes
End Property
Public Property Let TaxRate(fTaxRate As Single)
  mfTaxRate = fTaxRate
  mbDirty = True
End Property
Public Property Get TaxRate() As Single
  TaxRate = mfTaxRate
End Property
Public Property Let AgentID(lAgentID As Long)
  mlAgentID = lAgentID
  mbDirty = True
End Property
Public Property Get AgentID() As Long
  AgentID = mlAgentID
End Property
Public Property Let Dirty(bDirty As Boolean)
  mbDirty = bDirty
End Property
Public Property Get Dirty() As Boolean
  Dirty = mbDirty
End Property
Public Function GetLeadPassengerName() As String
  If Passengers.Count > 0 Then GetLeadPassengerName = Passengers(1).LastName
  'else empty string
End Function
Private Sub Class_Initialize()
  Set Passengers = New clsPassengers
  Set Payments = New clsPayments
  Set Products = New clsProducts
End Sub
Private Sub Class_Terminate()
  Set Passengers = Nothing
  Set Payments = Nothing
  Set Products = Nothing
End Sub
Public Sub Save(con As Connection, lPartyID As Long)
  Dim sSQL As String
  Dim rs As Recordset
  Set rs = New Recordset
  If mlReservationID = 0 Then
    sSQL = "select ReservationID, PartyID, AgentID, DateMade, Notes, TaxRate from Reservations where true=false"
    rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
    rs.AddNew
    'i was trying to get this right here so that the pulling out of the
    'reservationID wouldn't occur if it wasn't a new reservation
    'but, it wasn't getting a value, so I moved it to below the update
    'mlReservationID = rs!ReservationID
    'Debug.Assert (mlReservationID <> 0)
  Else
    sSQL = "select PartyID, ReservationID, AgentID, DateMade, Notes, TaxRate from Reservations where ReservationID=" & mlReservationID
    rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
  End If
  rs!DateMade = mdtDateMade
  rs!AgentID = mlAgentID
  rs!DateMade = mdtDateMade
  rs!Notes = msNotes
  rs!TaxRate = mfTaxRate
  rs!PartyID = lPartyID
  rs.Update
  mlReservationID = rs!ReservationID
  mbDirty = False
  Passengers.Save con, mlReservationID
  Payments.Save con, mlReservationID
  Products.Save con, mlReservationID
End Sub
Public Sub ChangeParties(con As Connection, lNewPartyID As Long)
  'this sub is used in cut/paste, drag/drop operations to take a group
  'of reservations and move them to a new party
  'this sub will delete a party if moving a reservation leaves it with
  'no reservations
  Dim lOldPartyID As Long
  Dim sSQL As String
  Dim rs As Recordset
  'find out what the old PartyID was
  Set rs = New Recordset
  sSQL = "select PartyID from Reservations where ReservationID=" & mlReservationID
  rs.Open sSQL, con, adOpenForwardOnly, adLockPessimistic
  lOldPartyID = rs!PartyID
  'update the reservation to hold the new PartyID
  sSQL = "update Reservations set PartyID=" & lNewPartyID & " where ReservationID=" & mlReservationID
  con.Execute sSQL
  'check to see if the old Party still has any reservations
  'if not, delete it
  Set rs = New Recordset
  sSQL = "select ReservationID from Reservations where PartyID=" & lOldPartyID
  rs.Open sSQL, con, adOpenForwardOnly, adLockPessimistic
  If RecordsetIsEmpty(rs) Then
    'delete it, no reservations left
    sSQL = "delete * from Parties where PartyID=" & lOldPartyID
    con.Execute sSQL
  Else
    'leave it be, it has reservations
  End If
End Sub
Public Sub Delete(con As Connection)
  Dim sSQL As String
  sSQL = "delete * from Reservations where ReservationID=" & mlReservationID
  con.Execute sSQL
End Sub
