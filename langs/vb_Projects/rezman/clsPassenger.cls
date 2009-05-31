VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsPassenger"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mlPassengerID As Long
Private msLastName As String
Private msFirstName As String
Private msAddress As String
Private msAddress2 As String
Private msCity As String
Private msState As String
Private msZip As String
Private msPhoneNumber As String
Private mnWeight As Integer
Private msProvince As String
Private msCountry As String
Private mbDirty As Boolean
Private mlTourListID As Long
Private mcTourPrice As Currency

Public Property Let PassengerID(lPassengerID As Long)
  mlPassengerID = lPassengerID
  mbDirty = True
End Property
Public Property Get PassengerID() As Long
  PassengerID = mlPassengerID
End Property
Public Property Let LastName(sLastName As String)
  msLastName = sLastName
  mbDirty = True
End Property
Public Property Get LastName() As String
  LastName = msLastName
End Property
Public Property Let FirstName(sFirstName As String)
  msFirstName = sFirstName
  mbDirty = True
End Property
Public Property Get FirstName() As String
  FirstName = msFirstName
End Property
Public Property Let Address(sAddress As String)
  msAddress = sAddress
  mbDirty = True
End Property
Public Property Get Address() As String
  Address = msAddress
End Property
Public Property Let Address2(sAddress2 As String)
  msAddress2 = sAddress2
  mbDirty = True
End Property
Public Property Get Address2() As String
  Address2 = msAddress2
End Property
Public Property Let City(sCity As String)
  msCity = sCity
  mbDirty = True
End Property
Public Property Get City() As String
  City = msCity
End Property
Public Property Let State(sState As String)
  msState = sState
  mbDirty = True
End Property
Public Property Get State() As String
  State = msState
End Property
Public Property Let Zip(sZip As String)
  msZip = sZip
  mbDirty = True
End Property
Public Property Get Zip() As String
  Zip = msZip
End Property
Public Property Let PhoneNumber(sPhoneNumber As String)
  msPhoneNumber = sPhoneNumber
  mbDirty = True
End Property
Public Property Get PhoneNumber() As String
  PhoneNumber = msPhoneNumber
End Property
Public Property Let Weight(nWeight As Integer)
  mnWeight = nWeight
  mbDirty = True
End Property
Public Property Get Weight() As Integer
  Weight = mnWeight
End Property
Public Property Let Province(sProvince As String)
  msProvince = sProvince
  mbDirty = True
End Property
Public Property Get Province() As String
  Province = msProvince
End Property
Public Property Let Country(sCountry As String)
  msCountry = sCountry
  mbDirty = True
End Property
Public Property Get Country() As String
  Country = msCountry
End Property
Public Property Let TourListID(lTourListID As Long)
  mlTourListID = lTourListID
  mbDirty = True
End Property
Public Property Get TourListID() As Long
  TourListID = mlTourListID
End Property
Public Property Let TourPrice(cTourPrice As Currency)
  mcTourPrice = cTourPrice
  mbDirty = True
End Property
Public Property Get TourPrice() As Currency
  TourPrice = mcTourPrice
End Property
Public Property Let Dirty(bDirty As Boolean)
  mbDirty = bDirty
End Property
Public Property Get Dirty() As Boolean
  Dirty = mbDirty
End Property
Public Function GetRowString() As String
  GetRowString = CStr(mlTourListID) & vbTab & FormatCurrency(mcTourPrice, 2, vbTrue, vbFalse, vbTrue) & vbTab & msFirstName & vbTab & msLastName & vbTab & msAddress & vbTab & msAddress2 & vbTab & msCity & vbTab & msState & vbTab & msZip & vbTab & msPhoneNumber & vbTab & CStr(mnWeight) & vbTab & msProvince & vbTab & msCountry
End Function
Public Sub LoadFromGrid(grd As vsFlexGrid, nRow As Integer)
  msFirstName = grd.TextMatrix(nRow, PASS_COL_FirstName)
  msLastName = grd.TextMatrix(nRow, PASS_COL_LastName)
  msAddress = grd.TextMatrix(nRow, PASS_COL_Address)
  msAddress2 = grd.TextMatrix(nRow, PASS_COL_Address2)
  msCity = grd.TextMatrix(nRow, PASS_COL_City)
  msState = grd.TextMatrix(nRow, PASS_COL_State)
  msZip = grd.TextMatrix(nRow, PASS_COL_Zip)
  msPhoneNumber = grd.TextMatrix(nRow, PASS_COL_PhoneNumber)
  mnWeight = grd.TextMatrix(nRow, PASS_COL_Weight)
  msProvince = grd.TextMatrix(nRow, PASS_COL_Province)
  msCountry = grd.TextMatrix(nRow, PASS_COL_Country)
  mlTourListID = grd.TextMatrix(nRow, PASS_COL_TourDescription)
  mcTourPrice = grd.TextMatrix(nRow, PASS_COL_TourPrice)
End Sub
Public Sub Save(con As Connection, lReservationID As Long)
  Dim sSQL As String
  Dim rs As Recordset
  Set rs = New Recordset
  sSQL = "select ReservationID, PassengerID, FirstName, LastName, Address, Address2, City, State, Zip, PhoneNumber, Weight, Province, Country, TourListID, TourPrice from Passengers where true=false"
  rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
  rs.AddNew
  rs!ReservationID = lReservationID
  rs!FirstName = msFirstName
  rs!LastName = msLastName
  rs!Address = msAddress
  rs!Address2 = msAddress2
  rs!City = msCity
  rs!State = msState
  rs!Zip = msZip
  rs!PhoneNumber = msPhoneNumber
  rs!Weight = mnWeight
  rs!Province = msProvince
  rs!Country = msCountry
  rs!TourListID = mlTourListID
  rs!TourPrice = mcTourPrice
  rs.Update
  mlPassengerID = rs!PassengerID
  mbDirty = False
End Sub
