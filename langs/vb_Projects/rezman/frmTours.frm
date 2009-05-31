VERSION 5.00
Begin VB.Form frmTours 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Tours"
   ClientHeight    =   3030
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5430
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3030
   ScaleWidth      =   5430
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.TextBox txtDuration 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1500
      Locked          =   -1  'True
      TabIndex        =   3
      Top             =   420
      Width           =   2535
   End
   Begin VB.TextBox txtUnitPrice 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1500
      Locked          =   -1  'True
      TabIndex        =   5
      Top             =   780
      Width           =   2535
   End
   Begin VB.TextBox txtDescription 
      BackColor       =   &H8000000B&
      Height          =   315
      Left            =   1500
      Locked          =   -1  'True
      MaxLength       =   50
      TabIndex        =   1
      Top             =   60
      Width           =   2535
   End
   Begin VB.CommandButton cmdCloseCancel 
      Caption         =   "&Close"
      Height          =   495
      Left            =   4170
      TabIndex        =   10
      Top             =   2460
      Width           =   1215
   End
   Begin VB.CommandButton cmdSelectSave 
      Caption         =   "&Select"
      Height          =   495
      Left            =   4170
      TabIndex        =   9
      Top             =   1860
      Width           =   1215
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "&Delete"
      Height          =   495
      Left            =   4170
      TabIndex        =   8
      Top             =   1260
      Width           =   1215
   End
   Begin VB.CommandButton cmdEdit 
      Caption         =   "&Edit"
      Height          =   495
      Left            =   4170
      TabIndex        =   7
      Top             =   660
      Width           =   1215
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "&Add"
      Height          =   495
      Left            =   4170
      TabIndex        =   6
      Top             =   60
      Width           =   1215
   End
   Begin VB.CommandButton cmdLast 
      Caption         =   ">|"
      Height          =   495
      Left            =   2280
      TabIndex        =   14
      Top             =   2460
      Width           =   615
   End
   Begin VB.CommandButton cmdNext 
      Caption         =   ">"
      Height          =   495
      Left            =   1560
      TabIndex        =   13
      Top             =   2460
      Width           =   615
   End
   Begin VB.CommandButton cmdPrevious 
      Caption         =   "<"
      Height          =   495
      Left            =   840
      TabIndex        =   12
      Top             =   2460
      Width           =   615
   End
   Begin VB.CommandButton cmdFirst 
      Caption         =   "|<"
      Height          =   495
      Left            =   120
      TabIndex        =   11
      Top             =   2460
      Width           =   615
   End
   Begin VB.Label lblDuration 
      Caption         =   "Duration (min):"
      Height          =   315
      Left            =   60
      TabIndex        =   2
      Top             =   420
      Width           =   1215
   End
   Begin VB.Label lblUnitPrice 
      Caption         =   "Unit Price:"
      Height          =   315
      Left            =   60
      TabIndex        =   4
      Top             =   780
      Width           =   1215
   End
   Begin VB.Label lblDescription 
      Caption         =   "&Description:"
      Height          =   315
      Left            =   60
      TabIndex        =   0
      Top             =   60
      Width           =   1215
   End
End
Attribute VB_Name = "frmTours"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim mCon As Connection
Dim mRS As Recordset
Private mbAdding As Boolean
Private mbDirtiedTours As Boolean
Public Function ShowTour(con As Connection, frmParent As Form) As Boolean
  Dim sSQL As String
  Set mCon = con
  Set mRS = New Recordset
  sSQL = "SELECT TourListID, Description, Duration, UnitPrice FROM TourList;"
  mRS.Open sSQL, mCon, adOpenKeyset, adLockPessimistic
  'no need to unload, not shown yet
  If Not ShowCurrentRecord Then Exit Function
  Me.Show vbModal, frmParent
  ShowTour = mbDirtiedTours
End Function
Private Function ShowCurrentRecord() As Boolean
  ShowCurrentRecord = True
  If (mRS.RecordCount > 0) Then
    txtDescription.Text = mRS!Description
    txtDuration.Text = mRS!Duration
    txtUnitPrice.Text = mRS!UnitPrice
  Else
    Dim nRes As Integer
    nRes = MsgBox("There are currently no tours in the database.  Would you like to add one?", vbYesNo, "Add Tour?")
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
  If Me.Visible Then txtDescription.SetFocus
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
  If TourIsBeingUsed Then
    'if we allow them to delete an agent that has
    'set up a reservation referential integrity will
    'be destroyed
    MsgBox "This tour is associated with an existing reservation.  The tour will not be deleted.", vbOKOnly + vbInformation, "Tour In Use"
  Else
    nRes = MsgBox("Are you sure you want to delete the tour?", vbYesNo, "Delete Tour?")
    If nRes = vbYes Then
      mRS.Delete
      mRS.MoveNext
      If mRS.EOF Then mRS.MovePrevious
      mbDirtiedTours = True
      If Not ShowCurrentRecord Then Unload Me
    End If
  End If
End Sub
Private Function TourIsBeingUsed() As Boolean
  Dim rs As Recordset
  Dim sSQL As String
  sSQL = "select TourListID from Passengers where TourListID = " & CStr(mRS!TourListID)
  Set rs = New Recordset
  rs.Open sSQL, mCon, adOpenForwardOnly, adLockPessimistic
  If RecordsetIsEmpty(rs) Then
    TourIsBeingUsed = False
  Else
    TourIsBeingUsed = True
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
  If Len(txtDescription.Text) = 0 Then
    MsgBox "The description is not allowed to be blank.", vbOKOnly + vbInformation, "Description Blank"
    DataValidates = False
    txtDescription.SetFocus
    Exit Function
  End If
  If Not IsInteger(txtDuration.Text) Then
    MsgBox "Please enter a valid tour duration.", vbOKOnly + vbInformation, "Tour Duration Invalid"
    DataValidates = False
    txtDuration.SetFocus
    Exit Function
  End If
  If Not IsCurrency(txtUnitPrice.Text) Then
    MsgBox "Please enter a valid unit price.", vbOKOnly + vbInformation, "Unit Price Invalid"
    DataValidates = False
    txtUnitPrice.SetFocus
    Exit Function
  End If
End Function
Private Sub cmdSelectSave_Click()
  If cmdSelectSave.Caption = "&Save" Then
    If DataValidates Then
      If mbAdding Then mRS.AddNew
      mRS!Description = txtDescription.Text
      mRS!Duration = CInt(txtDuration.Text)
      mRS!UnitPrice = CCur(txtUnitPrice.Text)
      mRS.Update
      mbDirtiedTours = True
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

