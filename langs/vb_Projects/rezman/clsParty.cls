VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsParty"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Reservations As clsReservations

Private mlPartyID As Long
Private mlResourceID As Long
Private mlPilotEmployeeID As Long
Private mdtDate As Date
Private mlStartTime As Long
Private mlEndTime As Long
Private mbDirty As Boolean
Public Property Let PartyID(lPartyID As Long)
  mlPartyID = lPartyID
  mbDirty = True
End Property
Public Property Get PartyID() As Long
  PartyID = mlPartyID
End Property
Public Property Let ResourceID(lResourceID As Long)
  mlResourceID = lResourceID
  mbDirty = True
End Property
Public Property Get ResourceID() As Long
  ResourceID = mlResourceID
End Property
Public Property Let DateOf(dtDate As Date)
  mdtDate = FormatDateTime(dtDate, vbShortDate)
  mbDirty = True
End Property
Public Property Get DateOf() As Date
  DateOf = mdtDate
End Property
Public Property Let StartTime(lTime As Long)
  mlStartTime = lTime
  mbDirty = True
End Property
Public Property Get StartTime() As Long
  StartTime = mlStartTime
End Property
Public Property Let EndTime(lTime As Long)
  mlEndTime = lTime
  mbDirty = True
End Property
Public Property Get EndTime() As Long
  EndTime = mlEndTime
End Property
Public Property Let PilotEmployeeID(lPilotEmployeeID As Long)
  mlPilotEmployeeID = lPilotEmployeeID
  mbDirty = True
End Property
Public Property Get PilotEmployeeID() As Long
  PilotEmployeeID = mlPilotEmployeeID
End Property
Public Property Get Dirty() As Boolean
  Dirty = mbDirty
End Property
Public Property Let Dirty(bDirty As Boolean)
  mbDirty = bDirty
End Property
Public Property Get PassengerCount() As Integer
  Dim nPassCount As Integer
  Dim objReservation As clsReservation
  For Each objReservation In Reservations
    nPassCount = nPassCount + objReservation.Passengers.Count
  Next objReservation
  PassengerCount = nPassCount
End Property
Private Sub Class_Initialize()
  Set Reservations = New clsReservations
End Sub
Private Sub Class_Terminate()
  Set Reservations = Nothing
End Sub
Public Sub Save(con As Connection)
  Dim sSQL As String
  Dim rs As Recordset
  Set rs = New Recordset
  If mbDirty Then
    If mlPartyID = 0 Then
      sSQL = "select PartyID, ResourceID, PilotEmployeeID, Date, StartTime, EndTime from Parties where true=false"
      rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
      rs.AddNew
      'i was trying to pull mlPartyID out right here but it never
      'contained a value so I had to move it to below
      'mlPartyID = rs!PartyID
      'Debug.Assert (mlPartyID <> 0)
    Else
      sSQL = "select PartyID, ResourceID, PilotEmployeeID, Date, StartTime, EndTime from Parties where PartyID=" & mlPartyID
      rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
    End If
    rs!ResourceID = mlResourceID
    rs!PilotEmployeeID = mlPilotEmployeeID
    rs!Date = mdtDate
    rs!StartTime = mlStartTime
    rs!EndTime = mlEndTime
    rs.Update
    mlPartyID = rs!PartyID
    mbDirty = False
  End If
  Reservations.Save con, mlPartyID
End Sub
Public Sub Delete(con As Connection)
  Dim sSQL As String
  sSQL = "delete * from Parties where PartyID=" & mlPartyID
  con.Execute sSQL
End Sub
Public Function TotalWeight(nPilotWeight As Integer) As Integer
  'we could retreive the pilot weight from the employees database
  'by using the PilotEmployeeID but the information is quickly
  'availble by ListIndex or EmployeeID on the main form so we just pass it in
  Dim objReservation As clsReservation
  Dim nWeightTotal As Integer
  For Each objReservation In Reservations
    nWeightTotal = nWeightTotal + objReservation.Passengers.TotalWeight
  Next objReservation
  TotalWeight = nWeightTotal + nPilotWeight
End Function
