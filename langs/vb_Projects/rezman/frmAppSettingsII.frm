VERSION 5.00
Begin VB.Form frmAppSettingsII 
   Caption         =   "Form1"
   ClientHeight    =   5010
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5985
   LinkTopic       =   "Form1"
   ScaleHeight     =   5010
   ScaleWidth      =   5985
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "..."
      Height          =   285
      Left            =   5520
      TabIndex        =   18
      Top             =   120
      Width           =   375
   End
   Begin VB.TextBox txtDataSource 
      Height          =   285
      Left            =   1920
      TabIndex        =   17
      Top             =   120
      Width           =   3615
   End
   Begin VB.TextBox txtPhoneNumber 
      Height          =   285
      Left            =   1920
      TabIndex        =   16
      Top             =   2640
      Width           =   3615
   End
   Begin VB.TextBox txtZip 
      Height          =   285
      Left            =   1920
      TabIndex        =   15
      Top             =   2280
      Width           =   3615
   End
   Begin VB.TextBox txtState 
      Height          =   285
      Left            =   1920
      TabIndex        =   14
      Top             =   1920
      Width           =   3615
   End
   Begin VB.TextBox txtCity 
      Height          =   285
      Left            =   1920
      TabIndex        =   13
      Top             =   1560
      Width           =   3615
   End
   Begin VB.TextBox txtAddress2 
      Height          =   285
      Left            =   1920
      TabIndex        =   12
      Top             =   1200
      Width           =   3615
   End
   Begin VB.TextBox txtAddress 
      Height          =   285
      Left            =   1920
      TabIndex        =   11
      Top             =   840
      Width           =   3615
   End
   Begin VB.TextBox txtCompanyName 
      Height          =   285
      Left            =   1920
      TabIndex        =   10
      Top             =   480
      Width           =   3615
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Height          =   495
      Left            =   4680
      TabIndex        =   8
      Top             =   3840
      Width           =   1215
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   4680
      TabIndex        =   7
      Top             =   4440
      Width           =   1215
   End
   Begin VB.CheckBox chkAllowOverbooking 
      Caption         =   "&Allow Overbooking"
      Height          =   495
      Left            =   2280
      TabIndex        =   6
      Top             =   3240
      Width           =   1695
   End
   Begin VB.Frame frmTimeInterval 
      Caption         =   "Schedule Time Interval"
      Height          =   1815
      Left            =   120
      TabIndex        =   1
      Top             =   3120
      Width           =   2055
      Begin VB.OptionButton optFiveMinutes 
         Caption         =   "&Five Minutes"
         Height          =   255
         Left            =   120
         TabIndex        =   5
         Top             =   240
         Width           =   1215
      End
      Begin VB.OptionButton optTenMinutes 
         Caption         =   "&Ten Minutes"
         Height          =   255
         Left            =   120
         TabIndex        =   4
         Top             =   600
         Width           =   1215
      End
      Begin VB.OptionButton optThirtyMinutes 
         Caption         =   "&Thirty Minutes"
         Height          =   255
         Left            =   120
         TabIndex        =   3
         Top             =   960
         Width           =   1335
      End
      Begin VB.OptionButton optSixtyMinutes 
         Caption         =   "&Sixty Minutes"
         Height          =   255
         Left            =   120
         TabIndex        =   2
         Top             =   1320
         Width           =   1335
      End
   End
   Begin VB.TextBox txtTaxRate 
      Height          =   375
      Left            =   3240
      TabIndex        =   0
      Top             =   3840
      Width           =   1095
   End
   Begin VB.Label lblDataSourceLocation 
      Caption         =   "&Data Source Location:"
      Height          =   285
      Left            =   120
      TabIndex        =   26
      Top             =   120
      Width           =   1815
   End
   Begin VB.Label lblPhoneNumber 
      Caption         =   "Phone Number:"
      Height          =   255
      Left            =   120
      TabIndex        =   25
      Top             =   2640
      Width           =   1215
   End
   Begin VB.Label lblZip 
      Caption         =   "Zip Code:"
      Height          =   255
      Left            =   120
      TabIndex        =   24
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label lblState 
      Caption         =   "State:"
      Height          =   255
      Left            =   120
      TabIndex        =   23
      Top             =   1920
      Width           =   1215
   End
   Begin VB.Label lblCity 
      Caption         =   "City:"
      Height          =   255
      Left            =   120
      TabIndex        =   22
      Top             =   1560
      Width           =   1215
   End
   Begin VB.Label lblAddress2 
      Caption         =   "Address2:"
      Height          =   255
      Left            =   120
      TabIndex        =   21
      Top             =   1200
      Width           =   1215
   End
   Begin VB.Label lblAddress 
      Caption         =   "Address:"
      Height          =   255
      Left            =   120
      TabIndex        =   20
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label lblCompanyName 
      Caption         =   "Company Name:"
      Height          =   255
      Left            =   120
      TabIndex        =   19
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label lblTaxRate 
      Caption         =   "&Tax Rate:"
      Height          =   255
      Left            =   2280
      TabIndex        =   9
      Top             =   3840
      Width           =   855
   End
End
Attribute VB_Name = "frmAppSettingsII"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public bAllowOverbookingChanged As Boolean
Public bGridFrequencyChanged As Boolean
Public bTaxRateChanged As Boolean
Public bDataSourceLocationChanged As Boolean
Private mnModalResult As VbMsgBoxResult
Private mobjAppSettings As clsAppSettings
Public Function ShowApplicationSettings(objAppSettings As clsAppSettings) As Boolean
  mnModalResult = vbCancel
  Set mobjAppSettings = objAppSettings
  
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
    If .AllowOverbooking Then chkAllowOverbooking.Value = vbChecked
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
  Me.Show vbModal, frm
  If mnModalResult = vbOK Then ShowConfigure = True
End Function
Private Sub cmdBrowse_Click()
  Dim sFilename As String
  Dim objFileDialog As clsFileDialog
  Set objFileDialog = New clsFileDialog
  sFilename = objFileDialog.GetOpenFileName(Me.hwnd, "All Files" & vbNullChar & "*.*" & vbNullChar & "RezMan Data Files" & vbNullChar & "*.rzm" & vbNullChar, 2, "rez", "rzm", "Select Data Source Location", App.Path & "\Data")
  If Len(sFilename) > 0 Then txtDataSource.Text = sFilename
End Sub
Private Sub cmdOK_Click()
  Dim nGridFrequency As Integer
  Dim fTaxRate As Single
  If DataValidates Then
    If mobjAppSettings.AllowOverbooking Then
      If chkAllowOverbooking.Value = vbUnchecked Then
        bAllowOverbookingChanged = True
        mobjAppSettings.AllowOverbooking = False
      End If
    Else
      If chkAllowOverbooking.Value = vbChecked Then
        bAllowOverbookingChanged = True
        mobjAppSettings.AllowOverbooking = True
      End If
    End If
    If optFiveMinutes.Value = True Then nGridFrequency = 5
    If optTenMinutes.Value = True Then nGridFrequency = 10
    If optThirtyMinutes.Value = True Then nGridFrequency = 30
    If optSixtyMinutes.Value = True Then nGridFrequency = 60
    If mobjAppSettings.GridFrequency <> nGridFrequency Then
      mobjAppSettings.GridFrequency = nGridFrequency
      bGridFrequencyChanged = True
    End If
    fTaxRate = CDec(txtTaxRate.Text)
    If mobjAppSettings.TaxRate <> fTaxRate Then
      mobjAppSettings.TaxRate = fTaxRate
      bTaxRateChanged = True
    End If
    If mobjAppSettings.Dirty Then mobjAppSettings.SaveSettings
    Unload Me
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
  If Not IsNumeric(txtTaxRate.Text) Then
    MsgBox "Please enter a valid tax rate.", vbOKOnly + vbInformation, "Tax Rate Invalid"
    DataValidates = False
    txtTaxRate.SetFocus
    Exit Function
  End If
End Function
