VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "clsCutDragInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mlID As Long
Private mnNumPassengers As Integer
Private mReservationOrParty As EReservationOrParty
Private mobjCutObject As Object
Public Property Let ID(lID As Long)
  mlID = lID
End Property
Public Property Get ID() As Long
  ID = mlID
End Property
Public Property Let NumPassengers(nNumPassengers As Integer)
  mnNumPassengers = nNumPassengers
End Property
Public Property Get NumPassengers() As Integer
  NumPassengers = mnNumPassengers
End Property
Public Property Let ReservationOrParty(rmType As EReservationOrParty)
  mReservationOrParty = rmType
End Property
Public Property Get ReservationOrParty() As EReservationOrParty
  ReservationOrParty = mReservationOrParty
End Property
Public Property Set CutObject(objCutObject As Object)
  Set mobjCutObject = objCutObject
End Property
Public Property Get CutObject() As Object
  Set CutObject = mobjCutObject
End Property
Public Sub Clear()
  mlID = 0
  Set mobjCutObject = Nothing
End Sub
Public Function IsValid() As Boolean
  IsValid = (mlID <> 0)
End Function
Public Sub Drop(objParty As clsParty, con As Connection, frm As Form, sDate As String, sTime As String, lAircraftID As Long)
  Dim objDroppedParty As clsParty
  Dim objReservation As clsReservation
  Dim lNewPilotID As Long
  If mReservationOrParty = rmParty Then
    Set objDroppedParty = mobjCutObject
    'on cut and paste, date and time and aircraftID are all that could change
    
    'not fixed from here on down
    objDroppedParty.DateOf = sDate
    objDroppedParty.Time = sTime
    objDroppedParty.AircraftID = lAircraftID
    'if pasting into another party, adopt the other parties PartyID
    If Not (objParty Is Nothing) Then
      For Each objReservation In objDroppedParty.Reservations
        objReservation.ChangeParties con, objParty.PartyID
      Next
    Else
      objDroppedParty.Save con
    End If
  Else 'CutDragInfo.Type = "reservation"
    Set objReservation = mobjCutObject
    If Not (objParty Is Nothing) Then
      objReservation.ChangeParties con, objParty.PartyID
    Else 'reservation makes new party
      lNewPilotID = frmSelectListBox.SelectID(con, frm, "select EmployeeID, FirstName & ' ' & LastName as FullName from Employees where IsPilot=True", "FullName", "EmployeeID", "Select Pilot", "Select a pilot for this new party.")
      If lNewPilotID <> 0 Then
        Set objParty = New clsParty
        objParty.AircraftID = lAircraftID
        objParty.DateOf = sDate
        objParty.PilotEmployeeID = lNewPilotID
        objParty.Time = sTime
        objParty.Save con
        objReservation.ChangeParties con, objParty.PartyID
      End If
    End If
  End If
  Clear
End Sub
Private Sub Class_Terminate()
  Set mobjCutObject = Nothing
End Sub
