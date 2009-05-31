VERSION 5.00
Begin VB.Form frmAppSettings 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Application Settings"
   ClientHeight    =   6450
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5955
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6450
   ScaleWidth      =   5955
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox txtResourceNamePlural 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   34
      Top             =   4080
      Width           =   3615
   End
   Begin VB.TextBox txtResourceName 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   33
      Top             =   3720
      Width           =   3615
   End
   Begin VB.CheckBox chkValidateTourDuration 
      Caption         =   "&Validate Tour Duration"
      Height          =   255
      Left            =   2250
      TabIndex        =   27
      Top             =   5280
      Width           =   2055
   End
   Begin VB.CheckBox chkAllowZeroPayments 
      Caption         =   "&Allow Zero Payments"
      Height          =   255
      Left            =   2250
      TabIndex        =   26
      Top             =   4920
      Width           =   1815
   End
   Begin VB.TextBox txtWWWAddress 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   18
      Top             =   3000
      Width           =   3615
   End
   Begin VB.TextBox txtEmailAddress 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   20
      Top             =   3360
      Width           =   3615
   End
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "..."
      Height          =   285
      Left            =   5520
      TabIndex        =   2
      Top             =   120
      Width           =   375
   End
   Begin VB.TextBox txtDataSourceLocation 
      Height          =   285
      Left            =   1920
      MaxLength       =   255
      TabIndex        =   1
      Top             =   120
      Width           =   3615
   End
   Begin VB.TextBox txtPhoneNumber 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   16
      Top             =   2640
      Width           =   3615
   End
   Begin VB.TextBox txtZip 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   14
      Top             =   2280
      Width           =   3615
   End
   Begin VB.TextBox txtState 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   12
      Top             =   1920
      Width           =   3615
   End
   Begin VB.TextBox txtCity 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   10
      Top             =   1560
      Width           =   3615
   End
   Begin VB.TextBox txtAddress2 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   8
      Top             =   1200
      Width           =   3615
   End
   Begin VB.TextBox txtAddress 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   6
      Top             =   840
      Width           =   3615
   End
   Begin VB.TextBox txtCompanyName 
      Height          =   285
      Left            =   1920
      MaxLength       =   50
      TabIndex        =   4
      Top             =   480
      Width           =   3615
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   495
      Left            =   4650
      TabIndex        =   30
      Top             =   5280
      Width           =   1215
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   4650
      TabIndex        =   31
      Top             =   5880
      Width           =   1215
   End
   Begin VB.CheckBox chkAllowOverbooking 
      Caption         =   "&Allow Overbooking"
      Height          =   255
      Left            =   2250
      TabIndex        =   25
      Top             =   4560
      Width           =   1815
   End
   Begin VB.Frame frmTimeInterval 
      Caption         =   "Schedule Time Interval"
      Height          =   1815
      Left            =   90
      TabIndex        =   32
      Top             =   4560
      Width           =   2055
      Begin VB.OptionButton optFiveMinutes 
         Caption         =   "&Five Minutes"
         Height          =   255
         Left            =   120
         TabIndex        =   21
         Top             =   240
         Width           =   1215
      End
      Begin VB.OptionButton optTenMinutes 
         Caption         =   "&Ten Minutes"
         Height          =   255
         Left            =   120
         TabIndex        =   22
         Top             =   600
         Width           =   1215
      End
      Begin VB.OptionButton optThirtyMinutes 
         Caption         =   "&Thirty Minutes"
         Height          =   255
         Left            =   120
         TabIndex        =   23
         Top             =   960
         Width           =   1335
      End
      Begin VB.OptionButton optSixtyMinutes 
         Caption         =   "&Sixty Minutes"
         Height          =   255
         Left            =   120
         TabIndex        =   24
         Top             =   1320
         Width           =   1335
      End
   End
   Begin VB.TextBox txtTaxRate 
      Height          =   375
      Left            =   4650
      TabIndex        =   29
      Top             =   4800
      Width           =   1095
   End
   Begin VB.Label lblResourceNamePlural 
      Caption         =   "Resource Name Plural:"
      Height          =   255
      Left            =   120
      TabIndex        =   36
      Top             =   4080
      Width           =   1725
   End
   Begin VB.Label lblResourceName 
      Caption         =   "Resource Name:"
      Height          =   255
      Left            =   120
      TabIndex        =   35
      Top             =   3720
      Width           =   1215
   End
   Begin VB.Label lblWWWAddress 
      Caption         =   "WWW Address:"
      Height          =   255
      Left            =   120
      TabIndex        =   17
      Top             =   3000
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "Email Address:"
      Height          =   255
      Left            =   120
      TabIndex        =   19
      Top             =   3360
      Width           =   1215
   End
   Begin VB.Label lblDataSourceLocation 
      Caption         =   "&Data Source Location:"
      Height          =   285
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1815
   End
   Begin VB.Label lblPhoneNumber 
      Caption         =   "Phone Number:"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   2640
      Width           =   1215
   End
   Begin VB.Label lblZip 
      Caption         =   "Zip Code:"
      Height          =   255
      Left            =   120
      TabIndex        =   13
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label lblState 
      Caption         =   "State:"
      Height          =   255
      Left            =   120
      TabIndex        =   11
      Top             =   1920
      Width           =   1215
   End
   Begin VB.Label lblCity 
      Caption         =   "City:"
      Height          =   255
      Left            =   120
      TabIndex        =   9
      Top             =   1560
      Width           =   1215
   End
   Begin VB.Label lblAddress2 
      Caption         =   "Address2:"
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   1200
      Width           =   1215
   End
   Begin VB.Label lblAddress 
      Caption         =   "Address:"
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label lblCompanyName 
      Caption         =   "Company Name:"
      Height          =   255
      Left            =   120
      TabIndex        =   3
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label lblTaxRate 
      Caption         =   "&Tax Rate:"
      Height          =   255
      Left            =   4650
      TabIndex        =   28
      Top             =   4440
      Width           =   855
   End
End
Attribute VB_Name = "frmAppSettings"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public bAllowOverbookingChanged As Boolean
Public bGridFrequencyChanged As Boolean
Public bTaxRateChanged As Boolean
Public bDataSourceLocationChanged As Boolean
Private mobjAppSettings As clsAppSettings
Public Sub ShowApplicationSettings(objappsettings As clsAppSettings, frmOwner As Form)
  Dim objRezmanData As clsRezmanData
  Set mobjAppSettings = objappsettings
  With mobjAppSettings
    txtCompanyName.Text = .CompanyName
    txtAddress.Text = .Address
    txtAddress2.Text = .Address2
    txtCity.Text = .City
    txtState.Text = .State
    txtZip.Text = .ZipCode
    txtPhoneNumber.Text = .PhoneNumber
    txtWWWAddress.Text = .WWWAddress
    txtEmailAddress.Text = .EmailAddress
    txtResourceName.Text = .ResourceName
    txtResourceNamePlural.Text = .ResourceNamePlural
    If .AllowOverbooking Then chkAllowOverbooking.Value = vbChecked
    If .AllowZeroPayments Then chkAllowZeroPayments.Value = vbChecked
    If .ValidateTourDuration Then chkValidateTourDuration.Value = vbChecked
    Select Case .GridFrequency
      Case 5
        optFiveMinutes.Value = True
      Case 10
        optTenMinutes.Value = True
      Case 30
        optThirtyMinutes.Value = True
      Case 60
        optSixtyMinutes.Value = True
    End Select
    txtTaxRate.Text = CStr(.TaxRate)
  End With
  Set objRezmanData = New clsRezmanData
  txtDataSourceLocation = objRezmanData.DataSourceLocation
  Me.Show vbModal, frmOwner
End Sub
Private Sub cmdBrowse_Click()
  Dim sFilename As String
  Dim objFileDialog As clsFileDialog
  Set objFileDialog = New clsFileDialog
  sFilename = objFileDialog.GetOpenFileName(Me.hwnd, "All Files" & vbNullChar & "*.*" & vbNullChar & "RezMan Data Files" & vbNullChar & "*.rzm" & vbNullChar, 2, "rez", "rzm", "Select Data Source Location", App.Path & "\Data")
  If Len(sFilename) Then txtDataSourceLocation.Text = sFilename
End Sub
Private Sub cmdCancel_Click()
  Unload Me
End Sub
Private Sub cmdOK_Click()
  Dim nGridFrequency As Integer
  Dim nRet As VbMsgBoxResult
  Dim fTaxRate As Single
  Dim objRezmanData As clsRezmanData
  Dim con As Connection
  If DataValidates Then
    Set objRezmanData = New clsRezmanData
    If txtDataSourceLocation.Text <> objRezmanData.DataSourceLocation Then
      If FileExists(txtDataSourceLocation.Text) Then
        objRezmanData.DataSourceLocation = txtDataSourceLocation.Text
        'see if it is viable by attempting to get a connection object
        If Not objRezmanData.GetConnection Is Nothing Then
          objRezmanData.SaveDataSourceLocation
          bDataSourceLocationChanged = True
        Else
          MsgBox "An error occurred while connecting to the new database.  The data source location will not be changed.", vbOKOnly + vbCritical, "Data Source Error"
        End If
      Else
        nRet = MsgBox("The database you have specified does not exist.  Would you like to create the new database?", vbYesNo + vbQuestion, "Create Database?")
        If nRet = vbYes Then
          If objRezmanData.CreateDatabase(txtDataSourceLocation.Text, mobjAppSettings) Then
            objRezmanData.DataSourceLocation = txtDataSourceLocation.Text
            objRezmanData.SaveDataSourceLocation
            bDataSourceLocationChanged = True
          Else
            MsgBox "An error occurred while creating the new database.  The data source location will not be changed.", vbOKOnly + vbCritical, "Data Source Error"
          End If
        End If
      End If
    End If
    With mobjAppSettings
      .CompanyName = txtCompanyName.Text
      .Address = txtAddress.Text
      .Address2 = txtAddress2.Text
      .City = txtCity.Text
      .State = txtState.Text
      .ZipCode = txtZip.Text
      .PhoneNumber = txtPhoneNumber.Text
      .WWWAddress = txtWWWAddress.Text
      .EmailAddress = txtEmailAddress.Text
      .ResourceName = txtResourceName.Text
      .ResourceNamePlural = txtResourceNamePlural.Text
      If .AllowOverbooking Then
        If chkAllowOverbooking.Value = vbUnchecked Then
          bAllowOverbookingChanged = True
          .AllowOverbooking = False
        End If
      Else
        If chkAllowOverbooking.Value = vbChecked Then
          bAllowOverbookingChanged = True
          .AllowOverbooking = True
        End If
      End If
      .AllowZeroPayments = (chkAllowZeroPayments.Value = vbChecked)
      .ValidateTourDuration = (chkValidateTourDuration.Value = vbChecked)
      If optFiveMinutes.Value = True Then nGridFrequency = 5
      If optTenMinutes.Value = True Then nGridFrequency = 10
      If optThirtyMinutes.Value = True Then nGridFrequency = 30
      If optSixtyMinutes.Value = True Then nGridFrequency = 60
      If .GridFrequency <> nGridFrequency Then
        .GridFrequency = nGridFrequency
        bGridFrequencyChanged = True
      End If
      fTaxRate = CDec(txtTaxRate.Text)
      If .TaxRate <> fTaxRate Then
        .TaxRate = fTaxRate
        bTaxRateChanged = True
      End If
      If .Dirty Then .SaveSettings
      Unload Me
    End With
  End If
End Sub
Private Function DataValidates() As Boolean
  DataValidates = True
  If Len(txtCompanyName.Text) = 0 Then
    MsgBox "The company name is not allowed to be blank.", vbOKOnly + vbInformation, "Company Name Blank"
    DataValidates = False
    txtCompanyName.SetFocus
    Exit Function
  End If
  If Len(txtAddress.Text) = 0 Then
    MsgBox "The address is not allowed to be blank.", vbOKOnly + vbInformation, "Address Blank"
    DataValidates = False
    txtAddress.SetFocus
    Exit Function
  End If
  If Len(txtCity.Text) = 0 Then
    MsgBox "The city is not allowed to be blank.", vbOKOnly + vbInformation, "City Blank"
    DataValidates = False
    txtCity.SetFocus
    Exit Function
  End If
  If Len(txtState.Text) = 0 Then
    MsgBox "The state is not allowed to be blank.", vbOKOnly + vbInformation, "State Blank"
    DataValidates = False
    txtState.SetFocus
    Exit Function
  End If
  If Len(txtZip.Text) = 0 Then
    MsgBox "The zip code is not allowed to be blank.", vbOKOnly + vbInformation, "Zip Code Blank"
    DataValidates = False
    txtZip.SetFocus
    Exit Function
  End If
  If Len(txtPhoneNumber.Text) = 0 Then
    MsgBox "The phone number is not allowed to be blank.", vbOKOnly + vbInformation, "Phone Number Blank"
    DataValidates = False
    txtPhoneNumber.SetFocus
    Exit Function
  End If
  If Len(txtResourceName.Text) = 0 Then
    MsgBox "The resource name is not allowed to be blank.", vbOKOnly + vbInformation, "Resource Name Blank"
    DataValidates = False
    txtResourceName.SetFocus
    Exit Function
  End If
  If Len(txtResourceNamePlural.Text) = 0 Then
    MsgBox "The resource name plural is not allowed to be blank.", vbOKOnly + vbInformation, "Resource Name Plural Blank"
    DataValidates = False
    txtResourceNamePlural.SetFocus
    Exit Function
  End If
  If Not IsNumeric(txtTaxRate.Text) Then
    MsgBox "Please enter a valid tax rate.", vbOKOnly + vbInformation, "Tax Rate Invalid"
    DataValidates = False
    txtTaxRate.SetFocus
    Exit Function
  End If
End Function
