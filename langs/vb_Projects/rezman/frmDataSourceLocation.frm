VERSION 5.00
Begin VB.Form frmBusinessInformation 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Business Information"
   ClientHeight    =   3000
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6945
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3000
   ScaleWidth      =   6945
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox txtCompanyName 
      Height          =   285
      Left            =   1920
      TabIndex        =   11
      Top             =   480
      Width           =   3615
   End
   Begin VB.TextBox txtAddress 
      Height          =   285
      Left            =   1920
      TabIndex        =   10
      Top             =   840
      Width           =   3615
   End
   Begin VB.TextBox txtAddress2 
      Height          =   285
      Left            =   1920
      TabIndex        =   9
      Top             =   1200
      Width           =   3615
   End
   Begin VB.TextBox txtCity 
      Height          =   285
      Left            =   1920
      TabIndex        =   8
      Top             =   1560
      Width           =   3615
   End
   Begin VB.TextBox txtState 
      Height          =   285
      Left            =   1920
      TabIndex        =   7
      Top             =   1920
      Width           =   3615
   End
   Begin VB.TextBox txtZip 
      Height          =   285
      Left            =   1920
      TabIndex        =   6
      Top             =   2280
      Width           =   3615
   End
   Begin VB.TextBox txtPhoneNumber 
      Height          =   285
      Left            =   1920
      TabIndex        =   5
      Top             =   2640
      Width           =   3615
   End
   Begin VB.CommandButton cmdOK 
      Caption         =   "&OK"
      Default         =   -1  'True
      Height          =   495
      Left            =   5760
      TabIndex        =   4
      Top             =   1800
      Width           =   975
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "&Cancel"
      Height          =   495
      Left            =   5760
      TabIndex        =   3
      Top             =   2400
      Width           =   975
   End
   Begin VB.TextBox txtDataSource 
      Height          =   285
      Left            =   1920
      TabIndex        =   1
      Top             =   120
      Width           =   3615
   End
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "&Browse"
      Height          =   285
      Left            =   5520
      TabIndex        =   0
      Top             =   120
      Width           =   1335
   End
   Begin VB.Label lblCompanyName 
      Caption         =   "Company Name:"
      Height          =   255
      Left            =   120
      TabIndex        =   18
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label lblAddress 
      Caption         =   "Address:"
      Height          =   255
      Left            =   120
      TabIndex        =   17
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label lblAddress2 
      Caption         =   "Address2:"
      Height          =   255
      Left            =   120
      TabIndex        =   16
      Top             =   1200
      Width           =   1215
   End
   Begin VB.Label lblCity 
      Caption         =   "City:"
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   1560
      Width           =   1215
   End
   Begin VB.Label lblState 
      Caption         =   "State:"
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   1920
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
   Begin VB.Label lblPhoneNumber 
      Caption         =   "Phone Number:"
      Height          =   255
      Left            =   120
      TabIndex        =   12
      Top             =   2640
      Width           =   1215
   End
   Begin VB.Label lblDataSourceLocation 
      Caption         =   "&Data Source Location:"
      Height          =   285
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   1815
   End
End
Attribute VB_Name = "frmBusinessInformation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mobjDataSourceLocation As clsDataSourceLocation
Private mbDataSourceLocationChanged As Boolean
Public Function ShowBusinessInformation(frm As Form) As Boolean
  'returns true if DataSourceLocation is changed
  Set mobjDataSourceLocation = New clsDataSourceLocation
  With mobjDataSourceLocation
    txtCompanyName.Text = .CompanyName
    txtAddress.Text = .Address
    txtAddress2.Text = .Address2
    txtCity.Text = .City
    txtState.Text = .State
    txtZip.Text = .ZipCode
    txtPhoneNumber.Text = .PhoneNumber
    txtDataSource.Text = mobjDataSourceLocation.DataSourceLocation
  End With
  Me.Show vbModal, frm
  ShowBusinessInformation = mbDataSourceLocationChanged
End Function
Private Sub cmdBrowse_Click()
  Dim sFilename As String
  Dim objFileDialog As clsFileDialog
  Set objFileDialog = New clsFileDialog
  sFilename = objFileDialog.GetOpenFileName(Me.hwnd, "All Files" & vbNullChar & "*.*" & vbNullChar & "RezMan Data Files" & vbNullChar & "*.rzm" & vbNullChar, 2, "rez", "rzm", "Select Data Source Location", App.Path & "\Data")
  If Len(sFilename) > 0 Then txtDataSource.Text = sFilename
End Sub
Private Sub cmdCancel_Click()
  Unload Me
End Sub
Private Sub cmdOK_Click()
  If DataValidates Then
    With mobjDataSourceLocation
      If txtDataSource.Text <> .DataSourceLocation Then mbDataSourceLocationChanged = True
      .CompanyName = txtCompanyName.Text
      .Address = txtAddress.Text
      .Address2 = txtAddress2.Text
      .City = txtCity.Text
      .State = txtState.Text
      .ZipCode = txtZip.Text
      .PhoneNumber = txtPhoneNumber.Text
      .DataSourceLocation = txtDataSource.Text
      .SaveSettings
    End With
  End If
  Unload Me
End Sub
Private Function DataValidates() As Boolean
  DataValidates = True
End Function
