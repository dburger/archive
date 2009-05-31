VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsProduct"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private mlProductID As Long
Private mlReservationID As Long
Private mlProductListID As Long


Private mnQuantity As Integer
Private mcUnitPrice As Currency

Private mbDirty As Boolean

Public Property Let ProductID(lProductID As Long)
  mlProductID = lProductID
  mbDirty = True
End Property
Public Property Get ProductID() As Long
  ProductID = mlProductID
End Property
Public Property Let ReservationID(lReservationID As Long)
  mlReservationID = lReservationID
  mbDirty = True
End Property
Public Property Get ReservationID() As Long
  ReservationID = mlReservationID
End Property
Public Property Let ProductListID(lProductListID As Long)
  mlProductListID = lProductListID
  mbDirty = True
End Property
Public Property Get ProductListID() As Long
  ProductListID = mlProductListID
End Property
Public Property Let Quantity(nQuantity As Integer)
  mnQuantity = nQuantity
  mbDirty = True
End Property
Public Property Get Quantity() As Integer
  Quantity = mnQuantity
End Property
Public Property Let UnitPrice(cUnitPrice As Currency)
  mcUnitPrice = cUnitPrice
  mbDirty = True
End Property
Public Property Get UnitPrice() As Currency
  UnitPrice = mcUnitPrice
End Property
Public Property Let Dirty(bDirty As Boolean)
  mbDirty = bDirty
End Property
Public Property Get Dirty() As Boolean
  Dirty = mbDirty
End Property
Public Function GetRowString() As String
  GetRowString = CStr(mnQuantity) & vbTab & CStr(mlProductListID) & vbTab & FormatCurrency(mcUnitPrice, 2, vbTrue, vbFalse, vbTrue) & vbTab & FormatCurrency(mnQuantity * mcUnitPrice, 2, vbTrue, vbFalse, vbTrue)
End Function
Public Sub LoadFromGrid(grd As vsFlexGrid, nRow As Integer)
  mnQuantity = grd.TextMatrix(nRow, PROD_COL_Quantity)
  mlProductListID = grd.TextMatrix(nRow, PROD_COL_Description)
  mcUnitPrice = grd.TextMatrix(nRow, PROD_COL_UnitPrice)
End Sub
Public Sub Save(con As Connection, lReservationID As Long)
  Dim sSQL As String
  Dim rs As Recordset
  Set rs = New Recordset
  sSQL = "select ProductID, ReservationID, ProductListID, UnitPrice, Quantity from Products where true=false"
  rs.Open sSQL, con, adOpenKeyset, adLockPessimistic
  rs.AddNew
  rs!ReservationID = lReservationID
  rs!ProductListID = mlProductListID
  rs!UnitPrice = mcUnitPrice
  rs!Quantity = mnQuantity
  rs.Update
  mlProductID = rs!ProductID
  mbDirty = False
End Sub
