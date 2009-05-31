VERSION 5.00
Begin VB.Form frmResources 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Aircrafts"
   ClientHeight    =   4035
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5475
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4035
   ScaleWidth      =   5475
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox txtMaxWeight 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      TabIndex        =   14
      Top             =   1560
      Width           =   2535
   End
   Begin VB.TextBox txtResourceDescription 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   1
      Top             =   120
      Width           =   2535
   End
   Begin VB.TextBox txtMaxPassengers 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1560
      Locked          =   -1  'True
      TabIndex        =   3
      Top             =   840
      Width           =   2535
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "&Add"
      Height          =   495
      Left            =   4200
      TabIndex        =   4
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton cmdEdit 
      Caption         =   "&Edit"
      Height          =   495
      Left            =   4200
      TabIndex        =   5
      Top             =   720
      Width           =   1215
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "&Delete"
      Height          =   495
      Left            =   4200
      TabIndex        =   6
      Top             =   1320
      Width           =   1215
   End
   Begin VB.CommandButton cmdSelectSave 
      Caption         =   "&Select"
      Height          =   495
      Left            =   4200
      TabIndex        =   7
      Top             =   1920
      Width           =   1215
   End
   Begin VB.CommandButton cmdCloseCancel 
      Caption         =   "&Close"
      Height          =   495
      Left            =   4200
      TabIndex        =   8
      Top             =   2520
      Width           =   1215
   End
   Begin VB.CommandButton cmdFirst 
      Caption         =   "|<"
      Height          =   495
      Left            =   480
      TabIndex        =   9
      Top             =   3480
      Width           =   615
   End
   Begin VB.CommandButton cmdPrevious 
      Caption         =   "<"
      Height          =   495
      Left            =   1200
      TabIndex        =   10
      Top             =   3480
      Width           =   615
   End
   Begin VB.CommandButton cmdNext 
      Caption         =   ">"
      Height          =   495
      Left            =   1920
      TabIndex        =   11
      Top             =   3480
      Width           =   615
   End
   Begin VB.CommandButton cmdLast 
      Caption         =   ">|"
      Height          =   495
      Left            =   2640
      TabIndex        =   12
      Top             =   3480
      Width           =   615
   End
   Begin VB.Label lblMaxWeight 
      Caption         =   "Maximum &Weight:"
      Height          =   555
      Left            =   150
      TabIndex        =   13
      Top             =   1560
      Width           =   1215
   End
   Begin VB.Label lblResourceDescription 
      Caption         =   "&Resource Description:"
      Height          =   555
      Left            =   150
      TabIndex        =   0
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label lblMaxPassengers 
      Caption         =   "&Maximum Passengers:"
      Height          =   555
      Left            =   150
      TabIndex        =   2
      Top             =   840
      Width           =   1215
   End
End
Attribute VB_Name = "frmResources"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim mCon As Connection
Dim mRS As Recordset
Private mbAdding As Boolean
Private mbDirtiedResources As Boolean
Private mobjAppSettings As clsAppSettings
Public Function ShowResources(con As Connection, frmParent As Form, objappsettings As clsAppSettings) As Boolean
  Dim sSQL As String
  Set mCon = con
  Set mobjAppSettings = objappsettings
  Set mRS = New Recordset
  sSQL = "SELECT ResourceID, Description, MaxPassengers, MaxWeight FROM Resources;"
  mRS.Open sSQL, mCon, adOpenKeyset, adLockPessimistic
  'no need to unload, not shown yet
  If Not ShowCurrentRecord Then Exit Function
  Me.Caption = mobjAppSettings.ResourceNamePlural
  lblResourceDescription.Caption = mobjAppSettings.ResourceName & " Description:"
  Me.Show vbModal, frmParent
  ShowResources = mbDirtiedResources
End Function
Public Sub SelectResource(con As Connection, frmParent As Form)
'  Set mCon = con
'  Set mRS = mCon.Execute("select * from agents")
'  ShowCurrentRecord
'  Show
End Sub
Private Function ShowCurrentRecord() As Boolean
  ShowCurrentRecord = True
  If (mRS.RecordCount > 0) Then
    txtResourceDescription.Text = mRS!Description
    txtMaxPassengers.Text = mRS!MaxPassengers
    txtMaxWeight.Text = mRS!MaxWeight
  Else
    Dim nRes As Integer
    nRes = MsgBox("There are currently no " & mobjAppSettings.ResourceNamePlural & " in the database.  Would you like to add one?", vbYesNo, "Add " & mobjAppSettings.ResourceName & "?")
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
  If Me.Visible Then txtResourceDescription.SetFocus
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
  If ResourceIsBeingUsed Then
    'if we allow them to delete an agent that has
    'set up a reservation referential integrity will
    'be destroyed and cascading deletes will remove
    'reservations
    MsgBox "This " & mobjAppSettings.ResourceName & " is associated with an existing reservation.  The " & mobjAppSettings.ResourceName & " will not be deleted.", vbOKOnly + vbInformation, mobjAppSettings.ResourceName & " In Use"
  Else
    nRes = MsgBox("Are you sure you want to delete the " & mobjAppSettings.ResourceName & "?", vbYesNo, "Delete " & mobjAppSettings.ResourceName & "?")
    If nRes = vbYes Then
      mRS.Delete
      mRS.MoveNext
      If mRS.EOF Then mRS.MovePrevious
      mbDirtiedResources = True
      If Not ShowCurrentRecord Then Unload Me
    End If
  End If
End Sub
Private Function ResourceIsBeingUsed() As Boolean
  Dim rs As Recordset
  Dim sSQL As String
  sSQL = "select ResourceID from Parties where ResourceID = " & CStr(mRS!ResourceID)
  Set rs = New Recordset
  rs.Open sSQL, mCon, adOpenForwardOnly, adLockPessimistic
  If RecordsetIsEmpty(rs) Then
    ResourceIsBeingUsed = False
  Else
    ResourceIsBeingUsed = True
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
  If Len(txtResourceDescription.Text) = 0 Then
    MsgBox "The " & mobjAppSettings.ResourceName & " description is not allowed to be blank.", vbOKOnly + vbInformation, mobjAppSettings.ResourceName & " Description Blank"
    DataValidates = False
    txtResourceDescription.SetFocus
    Exit Function
  End If
  If Not IsByte(txtMaxPassengers.Text) Then
    MsgBox "Please enter the maximum number of passengers.", vbOKOnly + vbInformation, "Max Passengers Invalid"
    DataValidates = False
    txtMaxPassengers.SetFocus
    Exit Function
  End If
  If Not IsInteger(txtMaxWeight.Text) Then
    MsgBox "Please enter the maximum weight.", vbOKOnly + vbInformation, "Max Weight Invalid"
    DataValidates = False
    txtMaxWeight.SetFocus
    Exit Function
  End If
  If CInt(txtMaxWeight.Text) < 0 Then
    MsgBox "Please enter the maximum weight.", vbOKOnly + vbInformation, "Max Weight Invalid"
    DataValidates = False
    txtMaxWeight.SetFocus
    Exit Function
  End If
End Function
Private Sub cmdSelectSave_Click()
  If cmdSelectSave.Caption = "&Save" Then
    If DataValidates Then
      If mbAdding Then mRS.AddNew
      mRS!Description = txtResourceDescription.Text
      mRS!MaxPassengers = txtMaxPassengers.Text
      mRS!MaxWeight = txtMaxWeight.Text
      mRS.Update
      mbDirtiedResources = True
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
