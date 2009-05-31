VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsAgent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public Reservations As clsReservations

Private mlAgentID As Long
Private msFirstName As String
Private msLastName As String
Private msPhoneNumber As String
Private msAddress As String
Private msAddress2 As String
Private msCity As String
Private msState As String
Private msZip As String

Public Property Get AgentID() As Long
  AgentID = mlAgentID
End Property
Public Property Let AgentID(lAgentID As Long)
  mlAgentID = lAgentID
End Property
Public Property Get FirstName() As String
  FirstName = msFirstName
End Property
Public Property Let FirstName(sFirstName As String)
  msFirstName = sFirstName
End Property
Public Property Get LastName() As String
  LastName = msLastName
End Property
Public Property Let LastName(sLastName As String)
  msLastName = sLastName
End Property
Public Property Get PhoneNumber() As String
  PhoneNumber = msPhoneNumber
End Property
Public Property Let PhoneNumber(sPhoneNumber As String)
  msPhoneNumber = sPhoneNumber
End Property
Public Property Get Address() As String
  Address = msAddress
End Property
Public Property Let Address(sAddress As String)
  msAddress = sAddress
End Property
Public Property Get Address2() As String
  Address2 = msAddress2
End Property
Public Property Let Address2(sAddress2 As String)
  msAddress2 = sAddress2
End Property
Public Property Get City() As String
  City = msCity
End Property
Public Property Let City(sCity As String)
  msCity = sCity
End Property
Public Property Get State() As String
  State = msState
End Property
Public Property Let State(sState As String)
  msState = sState
End Property
Public Property Get Zip() As String
  Zip = msZip
End Property
Public Property Let Zip(sZip As String)
  msZip = sZip
End Property
Private Sub Class_Initialize()
  Set Reservations = New clsReservations
End Sub
