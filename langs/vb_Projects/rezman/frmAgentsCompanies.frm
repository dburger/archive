VERSION 5.00
Begin VB.Form frmAgentsCompanies 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Agents Companies"
   ClientHeight    =   3360
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5550
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3360
   ScaleWidth      =   5550
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox txtAddress 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   3
      Top             =   480
      Width           =   2535
   End
   Begin VB.TextBox txtAddress2 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   5
      Top             =   840
      Width           =   2535
   End
   Begin VB.TextBox txtCity 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   7
      Top             =   1200
      Width           =   2535
   End
   Begin VB.TextBox txtState 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   9
      Top             =   1560
      Width           =   2535
   End
   Begin VB.TextBox txtZip 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   11
      Top             =   1920
      Width           =   2535
   End
   Begin VB.TextBox txtPhoneNumber 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   13
      Top             =   2280
      Width           =   2535
   End
   Begin VB.TextBox txtCompanyName 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   1
      Top             =   120
      Width           =   2535
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "&Add"
      Height          =   495
      Left            =   4200
      TabIndex        =   14
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton cmdEdit 
      Caption         =   "&Edit"
      Height          =   495
      Left            =   4200
      TabIndex        =   15
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "&Delete"
      Height          =   495
      Left            =   4200
      TabIndex        =   16
      Top             =   1320
      Width           =   1215
   End
   Begin VB.CommandButton cmdSelectSave 
      Caption         =   "&Select"
      Height          =   495
      Left            =   4200
      TabIndex        =   17
      Top             =   1920
      Width           =   1215
   End
   Begin VB.CommandButton cmdCloseCancel 
      Caption         =   "&Close"
      Height          =   495
      Left            =   4200
      TabIndex        =   18
      Top             =   2520
      Width           =   1215
   End
   Begin VB.CommandButton cmdFirst 
      Caption         =   "|<"
      Height          =   495
      Left            =   480
      TabIndex        =   19
      Top             =   2760
      Width           =   615
   End
   Begin VB.CommandButton cmdPrevious 
      Caption         =   "<"
      Height          =   495
      Left            =   1200
      TabIndex        =   20
      Top             =   2760
      Width           =   615
   End
   Begin VB.CommandButton cmdNext 
      Caption         =   ">"
      Height          =   495
      Left            =   1920
      TabIndex        =   21
      Top             =   2760
      Width           =   615
   End
   Begin VB.CommandButton cmdLast 
      Caption         =   ">|"
      Height          =   495
      Left            =   2640
      TabIndex        =   22
      Top             =   2760
      Width           =   615
   End
   Begin VB.Label lblAddress 
      Caption         =   "Address"
      Height          =   315
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label lblAddress2 
      Caption         =   "Address2"
      Height          =   315
      Left            =   120
      TabIndex        =   4
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label lblCity 
      Caption         =   "&City:"
      Height          =   315
      Left            =   120
      TabIndex        =   6
      Top             =   1200
      Width           =   1215
   End
   Begin VB.Label lblState 
      Caption         =   "&State:"
      Height          =   315
      Left            =   120
      TabIndex        =   8
      Top             =   1560
      Width           =   1215
   End
   Begin VB.Label lblZip 
      Caption         =   "&Zip:"
      Height          =   315
      Left            =   120
      TabIndex        =   10
      Top             =   1920
      Width           =   1215
   End
   Begin VB.Label lblPhoneNumber 
      Caption         =   "&Phone Number:"
      Height          =   315
      Left            =   120
      TabIndex        =   12
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label lblCompanyName 
      Caption         =   "&Company Name:"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "frmAgentsCompanies"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim mCon As Connection
Dim mRS As Recordset
Private mbAdding As Boolean
Private mbDirtiedAgentsCompanies As Boolean
Public Function ShowAgentsCompany(con As Connection, frmParent As Form) As Boolean
  Dim sSQL As String
  Set mCon = con
  Set mRS = New Recordset
  sSQL = "SELECT AgentCompanyID, CompanyName, Address, Address2, City, State, Zip, PhoneNumber FROM AgentsCompanies;"
  mRS.Open sSQL, mCon, adOpenKeyset, adLockPessimistic
  'no need to unload, not shown yet
  If Not ShowCurrentRecord Then Exit Function
  Me.Show vbModal, frmParent
  ShowAgentsCompany = mbDirtiedAgentsCompanies
End Function
Public Sub SelectAgentsCompany(con As Connection, frmParent As Form)
'  Set mCon = con
'  Set mRS = mCon.Execute("select * from agents")
'  ShowCurrentRecord
'  Show
End Sub
Private Function ShowCurrentRecord() As Boolean
  ShowCurrentRecord = True
  If (mRS.RecordCount > 0) Then
    txtCompanyName.Text = mRS!CompanyName
    txtAddress.Text = mRS!Address
    txtAddress2.Text = VBA.Format$(mRS!Address2)
    txtCity.Text = mRS!City
    txtState.Text = mRS!State
    txtZip.Text = mRS!Zip
    txtPhoneNumber.Text = mRS!PhoneNumber
  Else
    Dim nRes As Integer
    nRes = MsgBox("There are currently no agent companies in the database.  Would you like to add one?", vbYesNo, "Add Agent Company?")
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
  'throws an error if not visible and since this could
  'the form being shown because it was called up with
  'no data it may not be visible
  If Me.Visible Then txtCompanyName.SetFocus
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
  If CompanyHasAgentsInUse Then
    'if we allow them to delete an agent that has
    'set up a reservation referential integrity will
    'be destroyed and cascading deletes will remove
    'reservations
    MsgBox "This company has agents that are associated with existing reservations.  The company will not be deleted.", vbOKOnly + vbInformation, "Company Agents In Use"
  Else
    nRes = MsgBox("Are you sure you want to delete this agent company?", vbYesNo, "Delete Agent Company?")
    If nRes = vbYes Then
      mRS.Delete
      mRS.MoveNext
      If mRS.EOF Then mRS.MovePrevious
      mbDirtiedAgentsCompanies = True
      If Not ShowCurrentRecord Then Unload Me
    End If
  End If
End Sub
Private Function CompanyHasAgentsInUse() As Boolean
  Dim rs As Recordset
  Dim sSQL As String
  sSQL = "select Agents.AgentCompanyID from (AgentsCompanies inner join Agents on AgentsCompanies.AgentCompanyID = Agents.AgentCompanyID) inner join Reservations on Agents.AgentID = Reservations.AgentID where (((Agents.AgentCompanyID)=" & CStr(mRS!AgentCompanyID) & " ));"
  Set rs = New Recordset
  rs.Open sSQL, mCon, adOpenForwardOnly, adLockPessimistic
  If RecordsetIsEmpty(rs) Then
    CompanyHasAgentsInUse = False
  Else
    CompanyHasAgentsInUse = True
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
End Function
Private Sub cmdSelectSave_Click()
  If cmdSelectSave.Caption = "&Save" Then
    If DataValidates Then
      If mbAdding Then mRS.AddNew
      mRS!CompanyName = txtCompanyName.Text
      mRS!Address = txtAddress.Text
      mRS!Address2 = txtAddress2.Text
      mRS!City = txtCity.Text
      mRS!State = txtState.Text
      mRS!Zip = txtZip.Text
      mRS!PhoneNumber = txtPhoneNumber.Text
      mRS.Update
      mbDirtiedAgentsCompanies = True
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

