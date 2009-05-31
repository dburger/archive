VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsParties"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private mobjParties As Collection
Private Sub Class_Initialize()
  Set mobjParties = New Collection
End Sub
Public Function Add(sPartyID As String) As clsParty
  Dim objParty As clsParty
  Set objParty = New clsParty
  mobjParties.Add objParty, sPartyID
  Set Add = objParty
End Function
Public Sub AddExistingParty(objParty As clsParty)
  mobjParties.Add objParty, CStr(objParty.PartyID)
End Sub
Public Function Remove(vItemKey As Variant)
  mobjParties.Remove vItemKey
End Function
Public Function Item(vIndex As Variant) As clsParty
Attribute Item.VB_UserMemId = 0
  Set Item = mobjParties.Item(vIndex)
End Function
Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
  Set NewEnum = mobjParties.[_NewEnum]
End Function
Public Function Count() As Integer
  Count = mobjParties.Count
End Function
Public Function KeyExists(sKey As String) As Boolean
  On Error Resume Next
  Item (sKey)
  KeyExists = (Err.Number = 0)
End Function
Public Function SetAllDirty()
  Dim objParty As clsParty
  For Each objParty In mobjParties
    objParty.Dirty = True
  Next objParty
End Function
Private Sub Class_Terminate()
  Set mobjParties = Nothing
End Sub
Public Sub Load(dt As Date, con As Connection)
  'Dim nResourceIndex As Integer
  Dim rs As Recordset
  Dim sSQL As String
  Dim objParty As clsParty
  sSQL = "select ResourceID, PartyID, PilotEmployeeID, Date, StartTime, EndTime from Parties where Date=#" & FormatDateTime(dt, vbShortDate) & "#;"
  Set rs = New Recordset
  rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
  Do Until rs.EOF
    Set objParty = Add(CStr(rs!PartyID))
    With objParty
      .ResourceID = rs!ResourceID
      .DateOf = dt
      .PartyID = rs!PartyID
      .PilotEmployeeID = rs!PilotEmployeeID
      .StartTime = rs!StartTime
      .EndTime = rs!EndTime
      .Reservations.LoadFromPartyID .PartyID, con
      .Dirty = False
    End With
    rs.MoveNext
  Loop
End Sub
Public Sub Save(con As Connection, lReservationID As Long)
End Sub

