VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsAgents"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private mobjAgents As Collection
Public Function Add(sAgentID As String) As clsAgent
  Dim objAgent As clsAgent
  Set objAgent = New clsAgent
  mobjAgents.Add objAgent, sAgentID
  Set Add = objAgent
End Function
Public Function Remove(vItemKey As Variant)
  mobjAgents.Remove vItemKey
End Function
Public Function Item(vIndex As Variant) As clsAgent
  Set Item = mobjAgents.Item(vIndex)
End Function
Public Function Count() As Integer
  Count = mobjAgents.Count
End Function
Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
  Set NewEnum = mobjAgents.[_NewEnum]
End Function
Public Sub Load(dtStart As Date, dtEnd As Date, con As Connection)
  Dim lLastAgentID As Long
  Dim objAgent As clsAgent
  Dim rs As Recordset
  Set rs = New Recordset
  Dim sSQL As String
  'this sSQL has a group by clause that will list all of the reservations
  'in groups by AgentID, the code below tests to see when we go through
  'the list if we are hitting a new agent or not, if it is a new agent
  'it loads it into the agent list and then loads the reservation into
  'that agent.  If the agent is not a new agent then the reservation
  'is merely loaded into that agent
  'THIS IS SET UP TO OPERATE BY DATEMADE!
  sSQL = "SELECT Agents.AgentID, Agents.FirstName, Agents.LastName, Agents.PhoneNumber, Agents.Address, Agents.Address2, Agents.City, Agents.State, Agents.Zip, Reservations.ReservationID, Reservations.DateMade FROM Agents INNER JOIN Reservations ON Agents.AgentID = Reservations.AgentID GROUP BY Agents.AgentID, Agents.FirstName, Agents.LastName, Agents.PhoneNumber, Agents.Address, Agents.Address2, Agents.City, Agents.State, Agents.Zip, Reservations.ReservationID, Reservations.DateMade HAVING (((Reservations.DateMade) Between #" & CStr(dtStart) & "# And #" & CStr(dtEnd) & "#));"
  rs.Open sSQL, con, adOpenForwardOnly, adLockPessimistic
  'lLastAgentID = 0 by default
  Do Until rs.EOF
    If lLastAgentID <> rs!AgentID Then
      Set objAgent = Add(CStr(rs!AgentID))
      With objAgent
        .AgentID = rs!AgentID
        .FirstName = rs!FirstName
        .LastName = rs!LastName
        .PhoneNumber = rs!PhoneNumber
        .Address = rs!Address
        .Address2 = VBA.Format$(rs!Address2)
        .City = rs!City
        .State = rs!State
        .Zip = rs!Zip
        .Reservations.LoadFromResID rs!ReservationID, con
      End With
      lLastAgentID = rs!AgentID
    Else 'this is another reservation for an agent
      objAgent.Reservations.LoadFromResID rs!ReservationID, con
    End If
    rs.MoveNext
  Loop
End Sub
Private Sub Class_Initialize()
  Set mobjAgents = New Collection
End Sub

