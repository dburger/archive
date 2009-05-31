VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsRezmanData"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private msDataSourceLocation As String
Private mbDirty As Boolean
Public Property Get DataSourceLocation() As String
  DataSourceLocation = msDataSourceLocation
End Property
Public Property Let DataSourceLocation(sLocation As String)
  msDataSourceLocation = sLocation
  mbDirty = True
End Property
Public Property Get Dirty() As Boolean
  Dirty = mbDirty
End Property
Public Function GetConnection() As Connection
  'returns a connection to a Rezman database
  'upon error will return nothing
  Dim con As Connection
  On Error GoTo ErrorTrap
  Set con = New Connection
  'use this line to use an older version of access
  'con.Provider = "Microsoft.Jet.OLEDB.3.51"
  con.Provider = "Microsoft.Jet.OLEDB.4.0"
  con.Open msDataSourceLocation
  'this could be enhanced to verify it is actually a
  'rezman database, if it isn't we could raise an error
  'instead of establishing a connection
  Set GetConnection = con
  Exit Function
ErrorTrap:
  'not really necessary
  Set GetConnection = Nothing
End Function
Public Function CreateDatabase(sNewLocation As String, objappsettings As clsAppSettings) As Boolean
  'this could be done with ADOX as described
  'p 52 of June 1999 VBPJ but the extended
  'properties (autoincrement) wouldn't work
  'with 3.51 and since I only have beta of
  'office 2000 the 4.0 isn't creating databases
  'at all...besides I will give the option
  'to take some of the data with them into the
  'new database and this is best accomplished
  'with a copy and then strip out what you
  'don't want
  'this could also be done purely with DDL and
  'con.Execute sSQL statements but the extended
  'properties and Indexes are harder to set up
  'and the Relationships???  I'm not sure you
  'could set up the cascading updates and deletes
  'through DDL
  Dim objRezmanData As clsRezmanData
  Dim con As Connection
  Dim nRet As VbMsgBoxResult
  On Error GoTo ErrorTrap
  If APIFileCopy(msDataSourceLocation, sNewLocation, False) Then
    Set objRezmanData = New clsRezmanData
    objRezmanData.DataSourceLocation = sNewLocation
    'start a connection to the new database
    Set con = objRezmanData.GetConnection
    'blank out all of the data
    con.Execute "delete * from Parties"
    'cascades from Parties -> Reservations -> Passengers
    'cascades from                         -> Products
    'cascades from                         -> Payments
    nRet = MsgBox("Would you like to keep the list of Tours from your previous database file?", vbYesNo + vbQuestion, "Keep Tour List?")
    If nRet = vbNo Then
      con.Execute "delete * from TourList"
      'reset TourListID auto
    End If
    nRet = MsgBox("Would you like to keep the list of Agents from your previous database file?", vbYesNo + vbQuestion, "Keep Agents?")
    If nRet = vbNo Then
      con.Execute "delete * from AgentsCompanies"
      'cascade from AgentsCompanies -> Agents
      'reset AgentsCompanyID auto
      'reset AgentID auto
    End If
    nRet = MsgBox("Would you like to keep the list of Employees from your previous database file?", vbYesNo + vbQuestion, "Keep Employees?")
    If nRet = vbNo Then
      con.Execute "delete * from Employees"
      'reset EmployeeID auto
    End If
    nRet = MsgBox("Would you like to keep the list of " & objappsettings.ResourceNamePlural & " from your previous database file?", vbYesNo + vbQuestion, "Keep " & objappsettings.ResourceNamePlural & "?")
    If nRet = vbNo Then
      con.Execute "delete * from Resources"
      'reset ResourceID auto
    End If
    nRet = MsgBox("Would you like to keep the list of Payment Types from your previous database file?", vbYesNo + vbQuestion, "Keep Payment Types?")
    If nRet = vbNo Then
      con.Execute "delete * from PaymentTypes"
      'reset PaymentTypeID auto
    End If
    nRet = MsgBox("Would you like to keep the list of Products from your previous database file?", vbYesNo + vbQuestion, "Keep Product List?")
    If nRet = vbNo Then
      con.Execute "delete * from ProductList"
      'reset ProductList auto
    End If
    'add in none rows to the ones that need it
    'set the Autoincrements back to 1?
    CreateDatabase = True
    Exit Function
  Else
    'failed on the Copy
    CreateDatabase = False
  End If
  Exit Function
ErrorTrap:
  CreateDatabase = False
End Function
Public Sub SaveDataSourceLocation()
  SaveSetting REGISTRY_APP_NAME, "User Settings", "Data Source", msDataSourceLocation
End Sub
Private Sub Class_Initialize()
  msDataSourceLocation = GetSetting(REGISTRY_APP_NAME, "User Settings", "Data Source", App.Path & "\Data\rez.rzm")
End Sub
