VERSION 5.00
Begin VB.Form frmAgents 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Agents"
   ClientHeight    =   4215
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5550
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4215
   ScaleWidth      =   5550
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdLast 
      Caption         =   ">|"
      Height          =   495
      Left            =   2640
      TabIndex        =   26
      Top             =   3480
      Width           =   615
   End
   Begin VB.CommandButton cmdNext 
      Caption         =   ">"
      Height          =   495
      Left            =   1920
      TabIndex        =   25
      Top             =   3480
      Width           =   615
   End
   Begin VB.CommandButton cmdPrevious 
      Caption         =   "<"
      Height          =   495
      Left            =   1200
      TabIndex        =   24
      Top             =   3480
      Width           =   615
   End
   Begin VB.CommandButton cmdFirst 
      Caption         =   "|<"
      Height          =   495
      Left            =   480
      TabIndex        =   23
      Top             =   3480
      Width           =   615
   End
   Begin VB.CommandButton cmdCloseCancel 
      Caption         =   "&Close"
      Height          =   495
      Left            =   4200
      TabIndex        =   22
      Top             =   2520
      Width           =   1215
   End
   Begin VB.CommandButton cmdSelectSave 
      Caption         =   "&Select"
      Height          =   495
      Left            =   4200
      TabIndex        =   21
      Top             =   1920
      Width           =   1215
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "&Delete"
      Height          =   495
      Left            =   4200
      TabIndex        =   20
      Top             =   1320
      Width           =   1215
   End
   Begin VB.CommandButton cmdEdit 
      Caption         =   "&Edit"
      Height          =   495
      Left            =   4200
      TabIndex        =   19
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "&Add"
      Height          =   495
      Left            =   4200
      TabIndex        =   18
      Top             =   120
      Width           =   1215
   End
   Begin VB.ComboBox cboAgentsCompany 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      TabIndex        =   17
      Top             =   3000
      Width           =   2535
   End
   Begin VB.TextBox txtPhoneNumber 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   15
      Top             =   2640
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
   Begin VB.Label lblCompany 
      Caption         =   "Company:"
      Height          =   495
      Left            =   120
      TabIndex        =   16
      Top             =   3000
      Width           =   1215
   End
   Begin VB.Label lblPhoneNumber 
      Caption         =   "&Phone Number:"
      Height          =   495
      Left            =   120
      TabIndex        =   14
      Top             =   2640
      Width           =   1215
   End
   Begin VB.Label lblZip 
      Caption         =   "&Zip:"
      Height          =   495
      Left            =   120
      TabIndex        =   12
      Top             =   2280
      Width           =   1215
   End
   Begin VB.Label lblState 
      Caption         =   "&State:"
      Height          =   495
      Left            =   120
      TabIndex        =   10
      Top             =   1920
      Width           =   1215
   End
   Begin VB.Label lblCity 
      Caption         =   "&City:"
      Height          =   495
      Left            =   120
      TabIndex        =   8
      Top             =   1560
      Width           =   1215
   End
   Begin VB.Label lblAddress2 
      Caption         =   "Address2"
      Height          =   495
      Left            =   120
      TabIndex        =   6
      Top             =   1200
      Width           =   1215
   End
   Begin VB.Label lblAddress 
      Caption         =   "Address"
      Height          =   495
      Left            =   120
      TabIndex        =   4
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label lblLastName 
      Caption         =   "&Last Name:"
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   480
      Width           =   1215
   End
   Begin VB.Label lblFirstName 
      Caption         =   "&First Name:"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
End
Attribute VB_Name = "frmAgents"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim mCon As Connection
Dim mRS As Recordset
Private mbAdding As Boolean
Private mbDirtiedAgents As Boolean
Public Function ShowAgent(con As Connection, frmParent As Form) As Boolean
  Dim sSQL As String
  Set mCon = con
  Set mRS = New Recordset
  sSQL = "SELECT Agents.*, AgentsCompanies.CompanyName FROM AgentsCompanies INNER JOIN Agents ON AgentsCompanies.AgentCompanyID = Agents.AgentCompanyID;"
  mRS.Open sSQL, mCon, adOpenKeyset, adLockPessimistic
  'no need to unload, not shown yet
  If Not ShowCurrentRecord Then Exit Function
  Me.Show vbModal, frmParent
  ShowAgent = mbDirtiedAgents
End Function
Public Sub SelectAgent(con As Connection, frmParent As Form)
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
    'this one is allowed to be null so
    'we prevent that null problem
    txtAddress2.Text = VBA.Format$(mRS!Address2)
    txtCity.Text = mRS!City
    txtState.Text = mRS!State
    txtZip.Text = mRS!Zip
    txtPhoneNumber.Text = mRS!PhoneNumber
    FillList cboAgentsCompany, mCon, "select AgentCompanyID, CompanyName from AgentsCompanies", "CompanyName", "AgentCompanyID"
    ComboFetchByText cboAgentsCompany, mRS!CompanyName
  Else
    Dim nRes As Integer
    nRes = MsgBox("There are currently no agents in the database.  Would you like to add one?", vbYesNo, "Add Agent?")
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
  cboAgentsCompany.ListIndex = -1
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
  If AgentIsBeingUsed Then
    'if we allow them to delete an agent that has
    'set up a reservation referential integrity will
    'be destroyed and it will cascade delete reservations
    MsgBox "This agent is associated with an existing reservation.  The agent will not be deleted.", vbOKOnly + vbInformation, "Agent In Use"
  Else
    nRes = MsgBox("Are you sure you want to delete the agent?", vbYesNo, "Delete Agent?")
    If nRes = vbYes Then
      mRS.Delete
      mRS.MoveNext
      If mRS.EOF Then mRS.MovePrevious
      mbDirtiedAgents = True
      If Not ShowCurrentRecord Then Unload Me
    End If
  End If
End Sub
Private Function AgentIsBeingUsed() As Boolean
  Dim rs As Recordset
  Dim sSQL As String
  sSQL = "select AgentID from Reservations where AgentID = " & CStr(mRS!AgentID)
  Set rs = New Recordset
  rs.Open sSQL, mCon, adOpenForwardOnly, adLockPessimistic
  If RecordsetIsEmpty(rs) Then
    AgentIsBeingUsed = False
  Else
    AgentIsBeingUsed = True
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
  If cboAgentsCompany.ListIndex = -1 Then
    MsgBox "You must select the company that the agent belongs to.", vbOKOnly + vbInformation, "Select Agent Company"
    DataValidates = False
    cboAgentsCompany.SetFocus
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
      mRS!Address2 = VBA.Format$(txtAddress2.Text)
      mRS!City = txtCity.Text
      mRS!State = txtState.Text
      mRS!Zip = txtZip.Text
      mRS!PhoneNumber = txtPhoneNumber.Text
      mRS!AgentCompanyID = CLng(cboAgentsCompany.ItemData(cboAgentsCompany.ListIndex))
      mRS.Update
      mbDirtiedAgents = True
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
