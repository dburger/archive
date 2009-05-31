VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsUserSettings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private msDataSourceLocation As String
Private mbAllowOverbooking As Boolean
Private mnGranularity As Integer
Private mbDirty As Boolean
Private mCon As Connection
Public Property Get DataSourceLocation() As String
  DataSourceLocation = msDataSourceLocation
End Property
Public Property Let DataSourceLocation(sLocation As String)
  msDataSourceLocation = sLocation
  mbDirty = True
End Property
Public Property Get Granularity() As Integer
  Granularity = mnGranularity
End Property
Public Property Let Granularity(nGranularity As Integer)
  mnGranularity = nGranularity
  mbDirty = True
End Property
Public Property Get AllowOverbooking() As Boolean
  AllowOverbooking = mbAllowOverbooking
End Property
Public Property Let AllowOverbooking(bAllowOverbooking As Boolean)
  mbAllowOverbooking = bAllowOverbooking
  mbDirty = True
End Property
Public Sub Init(con As Connection)
  Dim rs As Recordset
  Dim sSQL As String
  Set mCon = con
  Set rs = New Recordset
  sSQL = "select AllowOverbooking, Granularity from AppSettings"
  rs.Open sSQL, mCon, adOpenForwardOnly, adLockReadOnly
  If rs.EOF And rs.BOF Then
    mbAllowOverbooking = False
    mnGranularity = 5
  Else
    mbAllowOverbooking = rs!AllowOverbooking
    mnGranularity = rs!Granularity
  End If
End Sub
Public Property Get Dirty() As Boolean
  Dirty = mbDirty
End Property
Public Sub SaveSettings()
  Dim rs As Recordset
  Dim sSQL As String
  Set rs = New Recordset
  sSQL = "select AllowOverbooking, Granularity from AppSettings"
  rs.Open sSQL, mCon, adOpenKeyset, adLockPessimistic
  rs!AllowOverbooking = mbAllowOverbooking
  rs!Granularity = mnGranularity
  SaveSetting "RezMan", "User Settings", "Data Source", DataSourceLocation
End Sub
