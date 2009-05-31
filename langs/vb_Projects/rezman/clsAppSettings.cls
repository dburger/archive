VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsAppSettings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private msCompanyName As String
Private msAddress As String
Private msAddress2 As String
Private msCity As String
Private msState As String
Private msZipCode As String
Private msPhoneNumber As String
Private msWWWAddress As String
Private msEmailAddress As String
Private msResourceName As String
Private msResourceNamePlural As String
Private mbAllowOverbooking As Boolean
Private mbAllowZeroPayments As Boolean
Private mbValidateTourDuration As Boolean
Private mnGridFrequency As Integer
Private mfTaxRate As Single
Private mbDirty As Boolean
Private mCon As Connection
Public Property Get CompanyName() As String
  CompanyName = msCompanyName
End Property
Public Property Let CompanyName(sCompanyName As String)
  msCompanyName = sCompanyName
  mbDirty = True
End Property
Public Property Get Address() As String
  Address = msAddress
End Property
Public Property Let Address(sAddress As String)
  msAddress = sAddress
  mbDirty = True
End Property
Public Property Get Address2() As String
  Address2 = msAddress2
End Property
Public Property Let Address2(sAddress2 As String)
  msAddress2 = sAddress2
  mbDirty = True
End Property
Public Property Get City() As String
  City = msCity
End Property
Public Property Let City(sCity As String)
  msCity = sCity
  mbDirty = True
End Property
Public Property Get State() As String
  State = msState
End Property
Public Property Let State(sState As String)
  msState = sState
  mbDirty = True
End Property
Public Property Get ZipCode() As String
  ZipCode = msZipCode
End Property
Public Property Let ZipCode(sZipCode As String)
  msZipCode = sZipCode
  mbDirty = True
End Property
Public Property Get PhoneNumber() As String
  PhoneNumber = msPhoneNumber
End Property
Public Property Let PhoneNumber(sPhoneNumber As String)
  msPhoneNumber = sPhoneNumber
  mbDirty = True
End Property
Public Property Get WWWAddress() As String
  WWWAddress = msWWWAddress
End Property
Public Property Let WWWAddress(sWWWAddress As String)
  msWWWAddress = sWWWAddress
  mbDirty = True
End Property
Public Property Get EmailAddress() As String
  EmailAddress = msEmailAddress
End Property
Public Property Let EmailAddress(sEmailAddress As String)
  msEmailAddress = sEmailAddress
  mbDirty = True
End Property
Public Property Get ResourceName() As String
  ResourceName = msResourceName
End Property
Public Property Let ResourceName(sResourceName As String)
  msResourceName = sResourceName
  mbDirty = True
End Property
Public Property Get ResourceNamePlural() As String
  ResourceNamePlural = msResourceNamePlural
End Property
Public Property Let ResourceNamePlural(sResourceNamePlural As String)
  msResourceNamePlural = sResourceNamePlural
  mbDirty = True
End Property
Public Property Get GridFrequency() As Integer
  GridFrequency = mnGridFrequency
End Property
Public Property Let GridFrequency(nGridFrequency As Integer)
  mnGridFrequency = nGridFrequency
  mbDirty = True
End Property
Public Property Get AllowOverbooking() As Boolean
  AllowOverbooking = mbAllowOverbooking
End Property
Public Property Let AllowOverbooking(bAllowOverbooking As Boolean)
  mbAllowOverbooking = bAllowOverbooking
  mbDirty = True
End Property
Public Property Get AllowZeroPayments() As Boolean
  AllowZeroPayments = mbAllowZeroPayments
End Property
Public Property Let AllowZeroPayments(bAllowZeroPayments As Boolean)
  mbAllowZeroPayments = bAllowZeroPayments
  mbDirty = True
End Property
Public Property Get ValidateTourDuration() As Boolean
  ValidateTourDuration = mbValidateTourDuration
End Property
Public Property Let ValidateTourDuration(bValidateTourDuration As Boolean)
  mbValidateTourDuration = bValidateTourDuration
  mbDirty = True
End Property
Public Property Get TaxRate() As Single
  TaxRate = mfTaxRate
End Property
Public Property Let TaxRate(fTaxRate As Single)
  mfTaxRate = fTaxRate
  mbDirty = True
End Property
Public Sub Init(con As Connection)
  Dim rs As Recordset
  Dim sSQL As String
  Set mCon = con
  Set rs = New Recordset
  sSQL = "select CompanyName, Address, Address2, City, State, ZipCode, PhoneNumber, WWWAddress, EmailAddress, ResourceName, ResourceNamePlural, AllowOverbooking, AllowZeroPayments, GridFrequency, TaxRate, ValidateTourDuration from AppSettings"
  rs.Open sSQL, mCon, adOpenForwardOnly, adLockReadOnly
  If RecordsetIsEmpty(rs) Then
    msCompanyName = "COMPANY NAME"
    msAddress = "ADDRESS"
    msAddress2 = "ADDRESS2"
    msCity = "CITY"
    msState = "STATE"
    msZipCode = "ZIP CODE"
    msPhoneNumber = "PHONE NUMBER"
    msWWWAddress = "WWW ADDRESS"
    msEmailAddress = "EMAIL ADDRESS"
    msResourceName = "RESOURCE NAME"
    msResourceNamePlural = "RESOURCE NAME PLURAL"
    mbAllowOverbooking = False
    mbAllowZeroPayments = False
    mbValidateTourDuration = False
    mnGridFrequency = 5
    mfTaxRate = 0.04
  Else
    msCompanyName = rs!CompanyName
    msAddress = rs!Address
    msAddress2 = VBA.Format$(rs!Address2)
    msCity = rs!City
    msState = rs!State
    msZipCode = rs!ZipCode
    msPhoneNumber = rs!PhoneNumber
    msWWWAddress = VBA.Format$(rs!WWWAddress)
    msEmailAddress = VBA.Format$(rs!EmailAddress)
    msResourceName = rs!ResourceName
    msResourceNamePlural = rs!ResourceNamePlural
    mbAllowOverbooking = rs!AllowOverbooking
    mbAllowZeroPayments = rs!AllowZeroPayments
    mbValidateTourDuration = rs!ValidateTourDuration
    mnGridFrequency = rs!GridFrequency
    mfTaxRate = rs!TaxRate
  End If
End Sub
Public Property Get Dirty() As Boolean
  Dirty = mbDirty
End Property
Public Sub SaveSettings()
  Dim rs As Recordset
  Dim sSQL As String
  Set rs = New Recordset
  sSQL = "select CompanyName, Address, Address2, City, State, ZipCode, PhoneNumber, WWWAddress, EmailAddress, ResourceName, ResourceNamePlural, AllowOverbooking, AllowZeroPayments, GridFrequency, TaxRate, ValidateTourDuration from AppSettings"
  rs.Open sSQL, mCon, adOpenKeyset, adLockPessimistic
  If RecordsetIsEmpty(rs) Then rs.AddNew
  rs!CompanyName = msCompanyName
  rs!Address = msAddress
  rs!Address2 = msAddress2
  rs!City = msCity
  rs!State = msState
  rs!ZipCode = msZipCode
  rs!PhoneNumber = msPhoneNumber
  rs!WWWAddress = msWWWAddress
  rs!EmailAddress = msEmailAddress
  rs!ResourceName = msResourceName
  rs!ResourceNamePlural = msResourceNamePlural
  rs!AllowOverbooking = mbAllowOverbooking
  rs!AllowZeroPayments = mbAllowZeroPayments
  rs!ValidateTourDuration = mbValidateTourDuration
  rs!GridFrequency = mnGridFrequency
  rs!TaxRate = mfTaxRate
  rs.Update
End Sub
