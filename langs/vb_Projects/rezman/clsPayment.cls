VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsPayment"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mlPaymentID As Long
Private mlReservationID As Long
Private mlPaymentTypeID As Long
Private mcAmount As Currency
Private msCardNumber As String
Private msNameOnCard As String
'an empty string - "" is transmitted to a Null in database
'but for Dates it is hard to have a sentinel so I made it
'variant so that it either holds a date or Null
Private mvExpirationDate As Variant

Private mbDirty As Boolean

Public Property Let PaymentID(lPaymentID As Long)
  mlPaymentID = lPaymentID
  mbDirty = True
End Property
Public Property Get PaymentID() As Long
  PaymentID = mlPaymentID
End Property
Public Property Let ReservationID(lReservationID As Long)
  mlReservationID = lReservationID
  mbDirty = True
End Property
Public Property Get ReservationID() As Long
  ReservationID = mlReservationID
End Property
Public Property Let PaymentTypeID(lPaymentTypeID As Long)
  mlPaymentTypeID = lPaymentTypeID
  mbDirty = True
End Property
Public Property Get PaymentTypeID() As Long
  PaymentTypeID = mlPaymentTypeID
End Property
Public Property Let Amount(cAmount As Currency)
  mcAmount = cAmount
  mbDirty = True
End Property
Public Property Get Amount() As Currency
  Amount = mcAmount
End Property
Public Property Let CardNumber(sCardNumber As String)
  msCardNumber = sCardNumber
  mbDirty = True
End Property
Public Property Get CardNumber() As String
  CardNumber = msCardNumber
End Property
Public Property Let NameOnCard(sNameOnCard As String)
  msNameOnCard = sNameOnCard
  mbDirty = True
End Property
Public Property Get NameOnCard() As String
  NameOnCard = msNameOnCard
End Property
Public Property Let ExpirationDate(vExpirationDate As Variant)
  If IsNull(vExpirationDate) Then
    mvExpirationDate = Null
  Else
    mvExpirationDate = FormatDateTime(vExpirationDate, vbShortDate)
  End If
  mbDirty = True
End Property
Public Property Get ExpirationDate() As Variant
  ExpirationDate = mvExpirationDate
End Property
Public Property Let Dirty(bDirty As Boolean)
  mbDirty = bDirty
End Property
Public Property Get Dirty() As Boolean
  Dirty = mbDirty
End Property
Public Function GetRowString() As String
  GetRowString = CStr(mlPaymentTypeID) & vbTab & msCardNumber & vbTab & msNameOnCard & vbTab & VBA.Format$(mvExpirationDate) & vbTab & FormatCurrency(mcAmount, 2, vbTrue, vbFalse, vbTrue)
End Function
Public Sub LoadFromGrid(grd As VSFlexGrid, ByVal nRow As Integer)
  mlPaymentTypeID = grd.TextMatrix(nRow, PAYM_COL_PaymentType)
  msCardNumber = grd.TextMatrix(nRow, PAYM_COL_CardNumber)
  msNameOnCard = grd.TextMatrix(nRow, PAYM_COL_NameOnCard)
  'this is allowed to be null if for example they paid cash
  If Len(grd.TextMatrix(nRow, PAYM_COL_ExpirationDate)) = 0 Then
    'let er be Null
  Else
    mvExpirationDate = FormatDateTime(grd.TextMatrix(nRow, PAYM_COL_ExpirationDate), vbShortDate)
  End If
  mcAmount = grd.TextMatrix(nRow, PAYM_COL_Amount)
End Sub
Public Sub Save(con As Connection, lReservationID As Long)
  Dim sSQL As String
  Dim rs As Recordset
  Set rs = New Recordset
  sSQL = "select PaymentID, ReservationID, PaymentTypeID, Amount, CardNumber, NameOnCard, ExpirationDate from Payments where true=false"
  rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
  rs.AddNew
  rs!ReservationID = lReservationID
  rs!PaymentTypeID = mlPaymentTypeID
  rs!Amount = mcAmount
  rs!CardNumber = StrToField(msCardNumber)
  rs!NameOnCard = StrToField(msNameOnCard)
  rs!ExpirationDate = mvExpirationDate
  rs.Update
  mlPaymentID = rs!PaymentID
  mbDirty = False
End Sub
