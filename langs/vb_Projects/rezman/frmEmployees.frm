VERSION 5.00
Begin VB.Form frmEmployees 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Employees"
   ClientHeight    =   4455
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8250
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4455
   ScaleWidth      =   8250
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox txtWeight 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   5640
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   40
      Top             =   2640
      Width           =   2535
   End
   Begin VB.CheckBox chkIsPilot 
      BackColor       =   &H8000000B&
      Caption         =   "Is a Pilot?"
      Enabled         =   0   'False
      Height          =   315
      Left            =   5640
      TabIndex        =   30
      Top             =   3480
      Width           =   1215
   End
   Begin VB.TextBox txtTermDate 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   5640
      Locked          =   -1  'True
      TabIndex        =   29
      Top             =   3000
      Width           =   2535
   End
   Begin VB.TextBox txtDateHired 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   5640
      Locked          =   -1  'True
      TabIndex        =   19
      Top             =   840
      Width           =   2535
   End
   Begin VB.TextBox txtSSN 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   5640
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   21
      Top             =   1200
      Width           =   2535
   End
   Begin VB.TextBox txtDOB 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   5640
      Locked          =   -1  'True
      TabIndex        =   23
      Top             =   1560
      Width           =   2535
   End
   Begin VB.TextBox txtLicenseNumber 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   5640
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   25
      Top             =   1920
      Width           =   2535
   End
   Begin VB.TextBox txtEmergencyContact 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   5640
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   27
      Top             =   2280
      Width           =   2535
   End
   Begin VB.TextBox txtPhoneNumber2 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   5640
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   17
      Top             =   480
      Width           =   2535
   End
   Begin VB.TextBox txtFirstName 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   1
      Top             =   120
      Width           =   2535
   End
   Begin VB.TextBox txtLastName 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   3
      Top             =   480
      Width           =   2535
   End
   Begin VB.TextBox txtAddress 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   5
      Top             =   840
      Width           =   2535
   End
   Begin VB.TextBox txtAddress2 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   7
      Top             =   1200
      Width           =   2535
   End
   Begin VB.TextBox txtCity 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   9
      Top             =   1560
      Width           =   2535
   End
   Begin VB.TextBox txtState 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   11
      Top             =   1920
      Width           =   2535
   End
   Begin VB.TextBox txtZip 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   13
      Top             =   2280
      Width           =   2535
   End
   Begin VB.TextBox txtPhoneNumber 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   5640
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   15
      Top             =   120
      Width           =   2535
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "&Add"
      Height          =   495
      Left            =   1950
      TabIndex        =   31
      Top             =   3900
      Width           =   1215
   End
   Begin VB.CommandButton cmdEdit 
      Caption         =   "&Edit"
      Height          =   495
      Left            =   3210
      TabIndex        =   32
      Top             =   3900
      Width           =   1215
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "&Delete"
      Height          =   495
      Left            =   4470
      TabIndex        =   33
      Top             =   3900
      Width           =   1215
   End
   Begin VB.CommandButton cmdSelectSave 
      Caption         =   "&Select"
      Height          =   495
      Left            =   5730
      TabIndex        =   34
      Top             =   3900
      Width           =   1215
   End
   Begin VB.CommandButton cmdCloseCancel 
      Caption         =   "&Close"
      Height          =   495
      Left            =   6990
      TabIndex        =   35
      Top             =   3900
      Width           =   1215
   End
   Begin VB.CommandButton cmdFirst 
      Caption         =   "|<"
      Height          =   495
      Left            =   120
      TabIndex        =   36
      Top             =   2730
      Width           =   615
   End
   Begin VB.CommandButton cmdPrevious 
      Caption         =   "<"
      Height          =   495
      Left            =   840
      TabIndex        =   37
      Top             =   2730
      Width           =   615
   End
   Begin VB.CommandButton cmdNext 
      Caption         =   ">"
      Height          =   495
      Left            =   1560
      TabIndex        =   38
      Top             =   2730
      Width           =   615
   End
   Begin VB.CommandButton cmdLast 
      Caption         =   ">|"
      Height          =   495
      Left            =   2280
      TabIndex        =   39
      Top             =   2730
      Width           =   615
   End
   Begin VB.Label lblWeight 
      Caption         =   "Weight:"
      Height          =   315
      Left            =   4200
      TabIndex        =   41
      Top             =   2640
      Width           =   1215
   End
   Begin VB.Label lblTermDate 
      Caption         =   "Termination Date:"
      Height          =   435
      Left            =   4200
      TabIndex        =   28
      Top             =   3000
      Width           =   1215
   End
   Begin VB.Label lblDateHired 
      Caption         =   "Date Hired:"
      Height          =   315
      Left            =   4200
      TabIndex        =   18
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label lblSSN 
      Caption         =   "SSN:"
      Height          =   315
      Left            =   4200
      TabIndex        =   20
      Top             =   1200
      Width           =   1215
   End
   Begin VB.Label lblDOB 
      Caption         =   "Date of Birth"
      Height          =   315
      Left            =   4200
      TabIndex        =   22
      Top             =   1560
      Width           =   1215
   End
   Begin VB.Label lblLicenseNumber 
      Caption         =   "License Number:"
      Height          =   315
      Left            =   4200
      TabIndex        =   24
      Top             =   1920
      Width           =   1215
   End
   Begin VB.Label lblEmergencyContact 
      Caption         =   "Emergency Cont:"
      Height          =   315
      Left            =   4200
      TabIndex        =   26
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label lblPhoneNumber2 
      Caption         =   "&Phone Number2:"
      Height          =   315
      Left            =   4200
      TabIndex        =   16
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label lblFirstName 
      Caption         =   "&First Name:"
      Height          =   315
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label lblLastName 
      Caption         =   "&Last Name:"
      Height          =   315
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label lblAddress 
      Caption         =   "Address"
      Height          =   315
      Left            =   120
      TabIndex        =   4
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label lblAddress2 
      Caption         =   "Address2"
      Height          =   315
      Left            =   120
      TabIndex        =   6
      Top             =   1200
      Width           =   1215
   End
   Begin VB.Label lblCity 
      Caption         =   "&City:"
      Height          =   315
      Left            =   120
      TabIndex        =   8
      Top             =   1560
      Width           =   1215
   End
   Begin VB.Label lblState 
      Caption         =   "&State:"
      Height          =   315
      Left            =   120
      TabIndex        =   10
      Top             =   1920
      Width           =   1215
   End
   Begin VB.Label lblZip 
      Caption         =   "&Zip:"
      Height          =   315
      Left            =   120
      TabIndex        =   12
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label lblPhoneNumber 
      Caption         =   "&Phone Number:"
      Height          =   315
      Left            =   4200
      TabIndex        =   14
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "frmEmployees"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim mCon As Connection
Dim mRS As Recordset
Private mbAdding As Boolean
Private mbDirtiedEmployees As Boolean
Public Function ShowEmployee(con As Connection, frmParent As Form) As Boolean
  Dim sSQL As String
  Set mCon = con
  Set mRS = New Recordset
  
  sSQL = "SELECT EmployeeID, FirstName, LastName, Address, Address2, City, State, Zip, PhoneNumber, DateHired, SSN, Weight, DOB, LicenseNumber, EmergencyContact, IsPilot, TermDate, PhoneNumber2 FROM Employees;"
  mRS.Open sSQL, mCon, adOpenKeyset, adLockPessimistic
  'no need to unload, not shown yet
  If Not ShowCurrentRecord Then Exit Function
  Me.Show vbModal, frmParent
  ShowEmployee = mbDirtiedEmployees
End Function
Public Sub SelectEmployee(con As Connection, frmParent As Form)
'  Set mCon = con
'  Set mRS = mCon.Execute("select * from agents")
'  ShowCurrentRecord
'  Show
End Sub
Private Function ShowCurrentRecord() As Boolean
  ShowCurrentRecord = True
  If (mRS.RecordCount > 0) Then
    txtFirstName.Text = mRS!FirstName
    txtLastName.Text = mRS!LastName
    txtAddress.Text = mRS!Address
    'this is allowed to be null so
    txtAddress2.Text = VBA.Format$(mRS!Address2)
    txtCity.Text = mRS!City
    txtState.Text = mRS!State
    txtZip.Text = mRS!Zip
    txtPhoneNumber.Text = mRS!PhoneNumber
    txtPhoneNumber2.Text = mRS!PhoneNumber2
    txtDateHired.Text = mRS!DateHired
    txtSSN.Text = mRS!SSN
    txtWeight.Text = mRS!Weight
    txtDOB.Text = mRS!DOB
    txtLicenseNumber.Text = mRS!LicenseNumber
    txtEmergencyContact.Text = mRS!EmergencyContact
    'this is allowed to be null so
    txtTermDate.Text = VBA.Format$(mRS!TermDate)
    If mRS!IsPilot Then
      chkIsPilot.Value = vbChecked
    Else
      chkIsPilot.Value = vbUnchecked
    End If
  Else
    Dim nRes As Integer
    nRes = MsgBox("There are currently no employees in the database.  Would you like to add one?", vbYesNo, "Add Employee?")
    If nRes = vbYes Then
      cmdAdd_Click
    Else
      ShowCurrentRecord = False
    End If
  End If
End Function
Private Sub cmdAdd_Click()
  mbAdding = True
  ClearForm
  AddEditStart
End Sub
Private Sub ClearForm()
  Dim ctl As Control
  Dim ctlTextBox As TextBox
  For Each ctl In Me.Controls
    If TypeOf ctl Is TextBox Then
      Set ctlTextBox = ctl
      ctlTextBox.Text = ""
    End If
  Next
  chkIsPilot.Value = vbUnchecked
  'throws an error if not visible and since this could
  'the form being shown because it was called up with
  'no data it may not be visible
  If Me.Visible Then txtFirstName.SetFocus
End Sub
Private Sub cmdCloseCancel_Click()
  If cmdCloseCancel.Caption = "&Close" Then
    Unload Me
  Else '"Cancel"
    If Not ShowCurrentRecord Then
      Unload Me
      Exit Sub
    End If
    AddEditOver
  End If
End Sub
Private Sub cmdDelete_Click()
  Dim nRes As Integer
  If EmployeeIsBeingUsed Then
    'if we allow them to delete an employee that is
    'a pilot for a party reservation referential integrity will
    'be destroyed and it will cascade delete reservations
    MsgBox "This employee is associated with an existing reservation.  The employee will not be deleted.", vbOKOnly + vbInformation, "Employee In Use"
  Else
    nRes = MsgBox("Are you sure you want to delete the employee?", vbYesNo, "Delete Employee?")
    If nRes = vbYes Then
      mRS.Delete
      mRS.MoveNext
      If mRS.EOF Then mRS.MovePrevious
      mbDirtiedEmployees = True
      If Not ShowCurrentRecord Then Unload Me
    End If
  End If
End Sub
Private Function EmployeeIsBeingUsed() As Boolean
  Dim rs As Recordset
  Dim sSQL As String
  sSQL = "select PilotEmployeeID from Parties where PilotEmployeeID = " & CStr(mRS!EmployeeID)
  Set rs = New Recordset
  rs.Open sSQL, mCon, adOpenForwardOnly, adLockPessimistic
  If RecordsetIsEmpty(rs) Then
    EmployeeIsBeingUsed = False
  Else
    EmployeeIsBeingUsed = True
  End If
End Function
Private Sub cmdEdit_Click()
  AddEditStart
  mbAdding = False
End Sub
Private Sub cmdFirst_Click()
  mRS.MoveFirst
  ShowCurrentRecord
End Sub
Private Sub cmdLast_Click()
  mRS.MoveLast
  ShowCurrentRecord
End Sub
Private Sub cmdNext_Click()
  mRS.MoveNext
  If mRS.EOF Then
    Beep
    mRS.MovePrevious
  End If
  ShowCurrentRecord
End Sub
Private Sub cmdPrevious_Click()
  mRS.MovePrevious
  If mRS.BOF Then
    Beep
    mRS.MoveNext
  End If
  ShowCurrentRecord
End Sub
Private Function DataValidates() As Boolean
  DataValidates = True
  If Len(txtFirstName.Text) = 0 Then
    MsgBox "The first name is not allowed to be blank.", vbOKOnly + vbInformation, "First Name Blank"
    DataValidates = False
    txtFirstName.SetFocus
    Exit Function
  End If
  If Len(txtLastName.Text) = 0 Then
    MsgBox "The last name is not allowed to be blank.", vbOKOnly + vbInformation, "Last Name Blank"
    DataValidates = False
    txtLastName.SetFocus
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
  If Len(txtDateHired.Text) = 0 Then
    MsgBox "The date hired is not allowed to be blank.", vbOKOnly + vbInformation, "Date Hired Blank"
    DataValidates = False
    txtDateHired.SetFocus
    Exit Function
  End If
  If Len(txtSSN.Text) = 0 Then
    MsgBox "The social security number is not allowed to be blank.", vbOKOnly + vbInformation, "SSN Blank"
    DataValidates = False
    txtSSN.SetFocus
    Exit Function
  End If
  If Not IsInteger(txtWeight.Text) Then
    MsgBox "Please enter a valid weight.  If this is not a pilot, you may enter 0 as this value will not be used by the program.", vbOKOnly + vbInformation, "Weight Invalid"
    DataValidates = False
    txtWeight.SetFocus
    Exit Function
  End If
  If CInt(txtWeight.Text) > MAX_HUMAN_WEIGHT Then
    MsgBox "Please enter a valid weight.", vbOKOnly + vbInformation, "Weight Invalid"
    DataValidates = False
    txtWeight.SetFocus
    Exit Function
  End If
  If Not IsDate(txtDOB.Text) Then
    MsgBox "Please enter a valid date of birth.", vbOKOnly + vbInformation, "Date of Birth Invalid"
    DataValidates = False
    txtDOB.SetFocus
    Exit Function
  End If
  If Len(txtLicenseNumber.Text) = 0 Then
    MsgBox "The license number is not allowed to be blank.", vbOKOnly + vbInformation, "License Number Blank"
    DataValidates = False
    txtLicenseNumber.SetFocus
    Exit Function
  End If
  If Len(txtEmergencyContact.Text) = 0 Then
    MsgBox "The emergency contact is not allowed to be blank.", vbOKOnly + vbInformation, "Emergency Contact Blank"
    DataValidates = False
    txtEmergencyContact.SetFocus
    Exit Function
  End If
End Function
Private Sub cmdSelectSave_Click()
  If cmdSelectSave.Caption = "&Save" Then
    If DataValidates Then
      If mbAdding Then mRS.AddNew
      mRS!FirstName = txtFirstName.Text
      mRS!LastName = txtLastName.Text
      mRS!Address = txtAddress.Text
      mRS!Address2 = txtAddress2.Text
      mRS!City = txtCity.Text
      mRS!State = txtState.Text
      mRS!Zip = txtZip.Text
      mRS!PhoneNumber = txtPhoneNumber.Text
      mRS!PhoneNumber2 = txtPhoneNumber2.Text
      mRS!DateHired = txtDateHired.Text
      mRS!SSN = txtSSN.Text
      mRS!Weight = txtWeight.Text
      mRS!DOB = txtDOB.Text
      mRS!LicenseNumber = txtLicenseNumber.Text
      mRS!EmergencyContact = txtEmergencyContact.Text
      If Len(txtTermDate.Text) Then mRS!TermDate = txtTermDate.Text
      mRS!IsPilot = chkIsPilot.Value
      mRS.Update
      mbDirtiedEmployees = True
      AddEditOver
    End If
  Else 'Select
  
  End If
End Sub
Private Sub AddEditOver()
  cmdAdd.Enabled = True
  cmdEdit.Enabled = True
  cmdDelete.Enabled = True
  cmdSelectSave.Caption = "&Select"
  cmdCloseCancel.Caption = "&Close"
  cmdFirst.Enabled = True
  cmdPrevious.Enabled = True
  cmdNext.Enabled = True
  cmdLast.Enabled = True
  
  SetDataEntryFormState Me, BROWSING
  
End Sub
Private Sub AddEditStart()
  cmdAdd.Enabled = False
  cmdEdit.Enabled = False
  cmdDelete.Enabled = False
  cmdSelectSave.Caption = "&Save"
  cmdCloseCancel.Caption = "&Cancel"
  cmdFirst.Enabled = False
  cmdPrevious.Enabled = False
  cmdNext.Enabled = False
  cmdLast.Enabled = False
  
  SetDataEntryFormState Me, EDITING

End Sub
