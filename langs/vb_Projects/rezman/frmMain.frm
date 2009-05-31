VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFLXGRD.OCX"
Begin VB.Form frmMain 
   Caption         =   "Rezman 1.0"
   ClientHeight    =   7620
   ClientLeft      =   60
   ClientTop       =   -4065
   ClientWidth     =   11130
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   ScaleHeight     =   508
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   742
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdDelete 
      Caption         =   "&Delete"
      Height          =   255
      Left            =   120
      TabIndex        =   24
      Top             =   4725
      Width           =   1095
   End
   Begin VB.CommandButton cmdNew 
      Caption         =   "&New"
      Height          =   255
      Left            =   120
      TabIndex        =   23
      Top             =   3960
      Width           =   1095
   End
   Begin MSFlexGridLib.MSFlexGrid grdParties 
      Height          =   5055
      Left            =   3000
      TabIndex        =   22
      Top             =   0
      Width           =   5055
      _ExtentX        =   8916
      _ExtentY        =   8916
      _Version        =   393216
      AllowBigSelection=   0   'False
      FocusRect       =   2
   End
   Begin MSFlexGridLib.MSFlexGrid grdDetail 
      Height          =   975
      Left            =   1680
      TabIndex        =   21
      Top             =   6600
      Width           =   7815
      _ExtentX        =   13785
      _ExtentY        =   1720
      _Version        =   393216
   End
   Begin ComctlLib.TabStrip tabgrdDetail 
      Height          =   375
      Left            =   1680
      TabIndex        =   19
      Top             =   6240
      Width           =   7815
      _ExtentX        =   13785
      _ExtentY        =   661
      _Version        =   327682
      BeginProperty Tabs {0713E432-850A-101B-AFC0-4210102A8DA7} 
         NumTabs         =   3
         BeginProperty Tab1 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "&Passengers"
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab2 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Products"
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
         BeginProperty Tab3 {0713F341-850A-101B-AFC0-4210102A8DA7} 
            Caption         =   "Payment"
            Object.Tag             =   ""
            ImageVarType    =   2
         EndProperty
      EndProperty
   End
   Begin VB.ListBox lstReservations 
      DragIcon        =   "frmMain.frx":0000
      Height          =   1035
      ItemData        =   "frmMain.frx":0152
      Left            =   1200
      List            =   "frmMain.frx":0154
      TabIndex        =   13
      Top             =   3960
      Width           =   1575
   End
   Begin VB.ComboBox cboPilot 
      BackColor       =   &H8000000F&
      Height          =   315
      Left            =   720
      Locked          =   -1  'True
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   5520
      Width           =   2535
   End
   Begin VB.CommandButton cmdSaveEdit 
      Caption         =   "&Edit"
      Height          =   255
      Left            =   120
      TabIndex        =   6
      Top             =   4200
      Width           =   1095
   End
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancel"
      Enabled         =   0   'False
      Height          =   255
      Left            =   120
      TabIndex        =   5
      Top             =   4470
      Width           =   1095
   End
   Begin VB.ComboBox cboAgent 
      BackColor       =   &H8000000F&
      Height          =   315
      Left            =   720
      Locked          =   -1  'True
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   5880
      Width           =   2535
   End
   Begin VB.TextBox txtDateMade 
      BackColor       =   &H8000000F&
      Height          =   315
      Left            =   4320
      Locked          =   -1  'True
      TabIndex        =   3
      Top             =   5520
      Width           =   1695
   End
   Begin VB.TextBox txtNotes 
      BackColor       =   &H8000000F&
      Height          =   735
      Left            =   6720
      Locked          =   -1  'True
      MaxLength       =   255
      MultiLine       =   -1  'True
      TabIndex        =   2
      Top             =   5520
      Width           =   2775
   End
   Begin VB.CommandButton cmdAddDetailItem 
      Caption         =   "&Add Passenger"
      Enabled         =   0   'False
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   6720
      Width           =   1455
   End
   Begin VB.CommandButton cmdDeleteDetailItem 
      Caption         =   "&Delete Passenger"
      Enabled         =   0   'False
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   7200
      Width           =   1455
   End
   Begin VB.Frame frameCalendar 
      BorderStyle     =   0  'None
      ClipControls    =   0   'False
      Height          =   2535
      Left            =   0
      TabIndex        =   12
      Top             =   0
      Width           =   2895
      Begin MSComCtl2.MonthView cldMain 
         Height          =   2370
         Left            =   120
         TabIndex        =   20
         Top             =   0
         Width           =   2700
         _ExtentX        =   4763
         _ExtentY        =   4180
         _Version        =   393216
         ForeColor       =   -2147483630
         BackColor       =   -2147483633
         Appearance      =   1
         StartOfWeek     =   24510465
         CurrentDate     =   36026
      End
   End
   Begin VB.Label lblReservationInformation 
      Alignment       =   2  'Center
      Caption         =   "RESERVATION INFORMATION"
      Height          =   255
      Left            =   30
      TabIndex        =   18
      Top             =   5160
      Width           =   8055
   End
   Begin VB.Label lblReservations 
      Alignment       =   2  'Center
      Caption         =   "&Reservations"
      Height          =   210
      Left            =   135
      TabIndex        =   17
      Top             =   3720
      Width           =   2595
   End
   Begin VB.Label lblSelectedAircraft 
      Caption         =   "SELECTED AIRCRAFT"
      Height          =   255
      Left            =   120
      TabIndex        =   16
      Top             =   3360
      Width           =   2535
   End
   Begin VB.Label lblSelectedTime 
      Caption         =   "SELECTED TIME(+cont nodrop ic)"
      DragIcon        =   "frmMain.frx":0156
      Height          =   255
      Left            =   120
      TabIndex        =   15
      Top             =   3000
      Width           =   2535
   End
   Begin VB.Label lblSelectedDate 
      Caption         =   "SELECTED DATE(+cont drag icon)"
      DragIcon        =   "frmMain.frx":02A8
      Height          =   255
      Left            =   120
      TabIndex        =   14
      Top             =   2640
      Width           =   2535
   End
   Begin VB.Label lblPilot 
      Caption         =   "&Pilot:"
      Height          =   375
      Left            =   120
      TabIndex        =   11
      Top             =   5520
      Width           =   1215
   End
   Begin VB.Label lblAgent 
      Caption         =   "&Agent:"
      Height          =   375
      Left            =   120
      TabIndex        =   10
      Top             =   5880
      Width           =   1215
   End
   Begin VB.Label lblDateMade 
      Caption         =   "&Date Made:"
      Height          =   255
      Left            =   3360
      TabIndex        =   9
      Top             =   5520
      Width           =   1215
   End
   Begin VB.Label lblNotes 
      Caption         =   "&Notes:"
      Height          =   375
      Left            =   6120
      TabIndex        =   8
      Top             =   5520
      Width           =   495
   End
   Begin VB.Menu mnuActions 
      Caption         =   "&Actions"
      Begin VB.Menu mnuActionsNewReservation 
         Caption         =   "&New Reservation"
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuActionsCut 
         Caption         =   "Cu&t"
         Shortcut        =   ^X
      End
      Begin VB.Menu mnuActionsCopy 
         Caption         =   "&Copy"
         Shortcut        =   ^C
      End
      Begin VB.Menu mnuActionsPaste 
         Caption         =   "&Paste"
         Shortcut        =   ^V
      End
      Begin VB.Menu mnuActionsDelete 
         Caption         =   "&Delete"
         Shortcut        =   {DEL}
      End
   End
   Begin VB.Menu mnuDataMaintenance 
      Caption         =   "&Data Maintenance"
      Begin VB.Menu mnuAgents 
         Caption         =   "&Agents"
      End
      Begin VB.Menu mnuAgentsCompanies 
         Caption         =   "&Agents Companies"
      End
      Begin VB.Menu mnuAircrafts 
         Caption         =   "&Aircrafts"
      End
      Begin VB.Menu mnuEmployees 
         Caption         =   "&Employees"
      End
      Begin VB.Menu mnuPaymentTypes 
         Caption         =   "&Payment Types"
      End
      Begin VB.Menu mnuProducts 
         Caption         =   "&Products"
      End
      Begin VB.Menu mnuSepBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuConfigure 
         Caption         =   "&Configure Settings"
      End
   End
   Begin VB.Menu mnuReports 
      Caption         =   "&Reports"
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuAboutRezman 
         Caption         =   "&About RezMan 1.0"
      End
   End
   Begin VB.Menu mnuExit 
      Caption         =   "E&xit"
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'types and enums
Private Type TAircraftInfoType
  AircraftID As Long
  MaxPassengers As Integer
End Type

Private Type TUserSettings
  StartTime As String
  EndTime As String
  TimeInterval As String
  TimeSlots As Integer
  DataSourceLocation As String
  AllowOverbooking As Integer
End Type

Private Enum rmViewModes
  rmViewMode
  rmEditMode
End Enum

Private Enum rmCurrentSelectionAction
  rmSaveSelections
  rmSetSelections
End Enum

'module level variables
Private mCon As Connection
'the array that holds the PartyID's mirroring the grdParties
Private alPartyID() As Long
'the object that holds the current party
Private mobjParty As clsParty
'MouseDown events would always start a drag and interfere with
'a mCutDragInfo structure so I had to hold in two seperate data
'structures
'the holder for a cut
Private mobjCutInfo As clsCutDragInfo
'the holder for a drag
Private mobjDragInfo As clsCutDragInfo
'the holder of aircraft info
Private anAircraftInfo() As TAircraftInfoType
'user settings are stored here
Private mUserSettings As TUserSettings
'this variable is to prevent display events from firing before the form
'is actually visible or when the grdParties is being filled
Private mbExecutegrdParties_EnterCell As Boolean
Private mnNumPassBeforeEdit As Integer
Private mobjDrawing As New clsDrawing
Private mnOldTab As Integer

Private Sub cldMain_SelChange(ByVal StartDate As Date, ByVal EndDate As Date, Cancel As Boolean)
  ShowParties
  lblSelectedDate.Caption = FormatDateTime(cldMain.Value, vbShortDate)
End Sub
Private Sub cmdAddDetailItem_Click()
  Dim lProductListID As Long
  Select Case cmdAddDetailItem.Caption
    Case "&Add Passenger"
      Dim sPreviousRow As String
      If grdDetail.Rows > 1 Then
        'add based on previous row
        sPreviousRow = GetRowString(grdDetail.Rows - 1, grdDetail)
        grdDetail.AddItem sPreviousRow
      Else
        grdDetail.Rows = grdDetail.Rows + 1
      End If
      grdDetail.Col = 1
      grdDetail.Row = grdDetail.Rows - 1
      grdDetail.SetFocus
      If Not mUserSettings.AllowOverbooking Then
        If (grdDetail.Rows - 1) - mnNumPassBeforeEdit = GetMaxPassCanAdd Then cmdAddDetailItem.Enabled = False
      End If
      cmdDeleteDetailItem.Enabled = True
    Case "&Add Payment"
      grdDetail.AddItem "", grdDetail.Rows - 2
    Case "&Add Product"
      lProductListID = frmSelectListBox.SelectID(mCon, Me, "select ProductListID, Description from ProductList", "Description", "ProductListID", "Select Product", "")
      If lProductListID <> 0 Then
        'pooper fix
        'must fill in known items here
        grdDetail.AddItem "New Product"
        grdDetail.RowData(grdDetail.Rows - 1) = lProductListID
      End If
  End Select
End Sub
Private Sub cmdCancel_Click()
  ViewMode = rmViewMode
  ShowParties
End Sub

Private Sub cmdDeleteDetailItem_Click()
  Select Case cmdDeleteDetailItem.Caption
    Case "&Delete Passenger"
      grdDetail.RemoveItem grdDetail.Row
      cmdAddDetailItem.Enabled = True
      If (grdDetail.Rows = 1) Then cmdDeleteDetailItem.Enabled = False
    Case "&Delete Payment"
      grdDetail.RemoveItem grdDetail.Row
      If (grdDetail.Rows = 1) Then cmdDeleteDetailItem.Enabled = False
    Case "&Delete Product"
      grdDetail.RemoveItem grdDetail.Row
      If (grdDetail.Rows = 1) Then cmdDeleteDetailItem.Enabled = False
  End Select
End Sub
Private Sub ShowParties()
  Dim nRow As Integer
  Dim nCol As Integer
  Dim nCounter As Integer
  Dim sSQL As String
  Dim rs As Recordset
  'with fancy one
  'grdParties.Clear flexClearScrollable, flexClearEverything
  'now
  'we don't want to do it if it doesn't hold data yet
  'didn't know how to check ubound so do it this way
  On Error Resume Next
  ClearParties
  On Error GoTo 0
  ReDim alPartyID(grdParties.Cols, mUserSettings.TimeSlots + 1)
  mbExecutegrdParties_EnterCell = False
  Set rs = New Recordset
  sSQL = "SELECT Parties.PartyID, Count(*) AS NumPassengers, Aircrafts.AircraftID, Aircrafts.MaxPassengers, Parties.Time " & _
  "FROM (Aircrafts INNER JOIN Parties ON Aircrafts.AircraftID = Parties.AircraftID) INNER JOIN (Reservations INNER JOIN Passengers ON Reservations.ReservationID = Passengers.ReservationID) ON Parties.PartyID = Reservations.PartyID " & _
  "GROUP BY Parties.PartyID, Aircrafts.AircraftID, Aircrafts.MaxPassengers, Parties.Time, Parties.Date " & _
  "HAVING (((Parties.Date)=#" & cldMain.Value & "#));"
  rs.Open sSQL, mCon, adOpenForwardOnly, adLockPessimistic
  'this will store what they have selected before we refill grid
  CurrentSelections rmSaveSelections
  Do Until rs.EOF
    nCol = GetAircraftColumn(rs!AircraftID, rs)
    nRow = GetTimeSlotRow(FormatDateTime(rs!Time, vbShortTime))
    If (nCol = 0) Or (nRow = 0) Then
      If nCol = 0 Then
        MsgBox "A party was found in the database that refers to an invalid aircraft.  It will not be shown.", vbOKOnly + vbCritical, "Invalid Aircraft"
      End If
      If nRow = 0 Then
        MsgBox "A party was found in the database that refers to a time slot that does not exist with your current configuration and will not be shown.", vbOKOnly + vbCritical, "Invalid Time Slot"
      End If
    Else
      grdParties.Col = nCol
      grdParties.Row = nRow
      grdParties.CellAlignment = flexAlignCenterCenter
      'should this be taken from the data base or aircraft info?
      If rs!NumPassengers < anAircraftInfo(grdParties.Col).MaxPassengers Then
        grdParties.CellBackColor = RGB(0, 255, 0)
      Else
        grdParties.CellBackColor = RGB(255, 0, 0)
      End If
      grdParties.Text = rs!NumPassengers & " [" & anAircraftInfo(grdParties.Col).MaxPassengers & "]"
      alPartyID(nCol, nRow) = rs!PartyID
    End If
    rs.MoveNext
  Loop
  'this will restore what they had selected before we filled grid
  CurrentSelections rmSetSelections
  ShowPartyDetail
  mbExecutegrdParties_EnterCell = True
  grdParties_EnterCell
End Sub

Private Sub cmdSaveEdit_Click()
  Dim objReservation As clsReservation
  Set objReservation = mobjParty.Reservations(lstReservations.Text)
  If cmdSaveEdit.Caption = "&Edit" Then
    mnNumPassBeforeEdit = objReservation.Passengers.Count
    'we need to set all to dirty because these detail items
    'are all saved by deleting everything there and then
    'inserting them back into the database
    objReservation.Passengers.SetAllDirty
    objReservation.Payments.SetAllDirty
    objReservation.Products.SetAllDirty
    ViewMode = rmEditMode
  Else 'Saving
    PutCurrentgrdDetailDataInReservation objReservation
    If DataValidates Then
      If Not OnParty Then
        'if the grid were sitting on a party and they chose new or edit
        'these items couldn't have changed, only need to change
        'if not on party
        mobjParty.AircraftID = anAircraftInfo(grdParties.Col).AircraftID
        mobjParty.DateOf = cldMain.Value
        mobjParty.Time = grdParties.TextMatrix(grdParties.Row, 0)
      End If
      'they can change the Pilot, so we do it here
      mobjParty.PilotEmployeeID = cboPilot.ItemData(cboPilot.ListIndex)
      objReservation.AgentID = cboAgent.ItemData(cboAgent.ListIndex)
      objReservation.DateMade = CDate(txtDateMade.Text)
      objReservation.Notes = txtNotes.Text
      'we load in the grid that is currently be displayed because it
      'could have changed, the others would be up to date because they
      'would have been Loaded from the grid when they become the old
      'tab
      mobjParty.Save mCon
      ViewMode = rmViewMode
      ShowParties
    End If
  End If
End Sub
Private Sub PutCurrentgrdDetailDataInReservation(objReservation As clsReservation)
  'this sub puts the data of the currently showing
  'detail grid (Passengers or Payments or Products)
  'into the object hierarchy
  Select Case tabgrdDetail.SelectedItem.Index
    Case PASS_TAB
      objReservation.Passengers.LoadFromGrid grdDetail
    Case PAYM_TAB
      objReservation.Payments.LoadFromGrid grdDetail
    Case PROD_TAB
      objReservation.Products.LoadFromGrid grdDetail
  End Select
End Sub
Private Sub Form_DragOver(Source As Control, X As Single, Y As Single, State As Integer)
  grdParties.DragIcon = lblSelectedTime.DragIcon
  lstReservations.DragIcon = lblSelectedTime.DragIcon
End Sub
Private Sub Form_Load()
  Dim dtNow As Date
  frmSplash.ShowSplash
  RunStartUpSequence
  dtNow = FormatDateTime(Now, vbShortDate)
  cldMain.Value = dtNow
  cldMain_SelChange dtNow, dtNow, False
  frmSplash.EndSplash
End Sub
Private Sub SetUpPilots()
  FillList cboPilot, mCon, "select [FirstName] & ' ' & [LastName] as FullName, EmployeeID from employees where IsPilot=Yes", "FullName", "EmployeeID"
End Sub
Private Sub SetUpAgents()
  FillList cboAgent, mCon, "select [FirstName] & ' ' & [LastName] as FullName, AgentID from agents", "FullName", "AgentID"
End Sub
Private Sub SetUpDetailGrid()
  grdDetail.FormatString = "|First Name|Last Name|Address|Address 2|City|State|Zip|Phone Number|Weight|Province|Country"
End Sub
Private Sub SetUpPartiesGrid()
  Dim sSQL As String
  Dim nCol As Integer
  Dim nRowLoop As Integer
  Dim sHeaders As String
  Dim nNumAircraft As Integer
  Dim rs As Recordset
  Dim dtTemp As Date
  dtTemp = CDate(mUserSettings.StartTime)
  nCol = 1
  sSQL = "select * from aircrafts"
  Set rs = New Recordset
  rs.Open sSQL, mCon, adOpenForwardOnly, adLockReadOnly
  nNumAircraft = CountRecords(rs)
  ReDim anAircraftInfo(nNumAircraft + 1)
  rs.Requery
  Do Until rs.EOF
    sHeaders = sHeaders & "|" & rs!HelicopterID
    'here is where the id's are tracked
    anAircraftInfo(nCol).AircraftID = rs!AircraftID
    anAircraftInfo(nCol).MaxPassengers = rs!MaxPassengers
    nCol = nCol + 1
    rs.MoveNext
  Loop
  grdParties.Cols = nCol
  grdParties.Rows = mUserSettings.TimeSlots + 1
  rs.Close
  sHeaders = sHeaders & ";"
  With grdParties
    For nRowLoop = 1 To mUserSettings.TimeSlots
      sHeaders = sHeaders & "|" & FormatDateTime(dtTemp, vbShortTime)
      dtTemp = dtTemp + mUserSettings.TimeInterval
    Next nRowLoop
  End With
  grdParties.FormatString = sHeaders
  SetColumnWidths grdParties
  SetColumnWidths grdDetail
End Sub
Private Sub Form_Paint()
  mobjDrawing.DrawEdge lblReservations, Me
  mobjDrawing.DrawEdge lblReservationInformation, Me
End Sub
Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  If cmdCancel.Enabled Then
    MsgBox "The program is currently in an edit state. Please complete or cancel your edit before closing the program", vbInformation, "Editing"
    Cancel = True
  End If
End Sub
Private Sub Form_Resize()
  Const HORI_SPACE = 4
  If (Me.ScaleWidth - (grdParties.Left + HORI_SPACE)) > 0 Then
    grdParties.Width = Me.ScaleWidth - grdParties.Left - HORI_SPACE
    lblReservationInformation.Width = Me.ScaleWidth - HORI_SPACE
    grdDetail.Width = Me.ScaleWidth - grdDetail.Left - HORI_SPACE
    tabgrdDetail.Width = grdDetail.Width
    If (Me.ScaleWidth - txtNotes.Left - HORI_SPACE) > 0 Then txtNotes.Width = Me.ScaleWidth - txtNotes.Left - HORI_SPACE
  End If
  If (Me.ScaleHeight - grdDetail.Top) > 0 Then grdDetail.Height = Me.ScaleHeight - grdDetail.Top
  SetColumnWidths grdParties
  SetColumnWidths grdDetail
End Sub
Private Function CanAddReservations() As Boolean
  CanAddReservations = (GetMaxPassCanAdd > 0) Or mUserSettings.AllowOverbooking
End Function
Private Function GetMaxPassCanAdd() As Integer
  GetMaxPassCanAdd = GetMaxPass - GetNumPass
End Function
Private Function GetMaxPass() As Integer
  GetMaxPass = anAircraftInfo(grdParties.Col).MaxPassengers
End Function
Private Function GetNumPass() As Integer
  If Len(grdParties.Text) = 0 Then
    GetNumPass = 0
  Else
    GetNumPass = CInt(Left$(grdParties.Text, (InStr(1, grdParties.Text, "[") - 2)))
  End If
End Function
Private Function GetAircraftColumn(lAircraftID As Long, rs As Recordset)
  Dim nCol As Integer
  Dim nCols As Integer
  nCols = grdParties.Cols
  nCol = 1
  Do
    If anAircraftInfo(nCol).AircraftID = rs!AircraftID Then Exit Do
    nCol = nCol + 1
    'this will cause GetAircraftColumn to be 0 if it
    'was not found
    If nCol > nCols Then Exit Function
  Loop
  GetAircraftColumn = nCol
End Function
Private Function GetTimeSlotRow(sTime As String) As Integer
  Dim nRow As Integer
  Dim nLastRowIndex As Integer
  nLastRowIndex = grdParties.Rows - 1
  nRow = 1
  Do
    If grdParties.TextMatrix(nRow, 0) = sTime Then Exit Do
    nRow = nRow + 1
    'this will cause GetTimeSlotRow to be 0 if it couldn't
    'locate the time for the Party
    If nRow > nLastRowIndex Then Exit Function
  Loop
  GetTimeSlotRow = nRow
End Function
Private Sub GetUserSettings()
  Dim sTemp As String
  mUserSettings.StartTime = GetSetting("RezMan", "User Settings", "Start Time", "07:00")
  mUserSettings.EndTime = GetSetting("RezMan", "User Settings", "End Time", "17:30")
  mUserSettings.TimeInterval = GetSetting("RezMan", "User Settings", "Time Interval", "00:30")
  mUserSettings.TimeSlots = CountTimeSlots(mUserSettings.StartTime, mUserSettings.EndTime, mUserSettings.TimeInterval)
  mUserSettings.DataSourceLocation = GetSetting("RezMan", "User Settings", "Data Source", App.Path & "\rez.mdb")
  sTemp = GetSetting("Rezman", "User Settings", "Allow Overbooking", "True")
  mUserSettings.AllowOverbooking = (sTemp = "True")
End Sub
Private Sub grdDetail_BeforeEdit(ByVal Row As Long, ByVal Col As Long, Cancel As Boolean)
  If (tabgrdDetail.SelectedItem.Index = PAYM_TAB) And (Col = 1) Then
    'crap, this grid doesn't do it
    'grdDetail.ComboList = gobjPaymentTypes.GetPaymentTypeList
  Else
    'grdDetail.ComboList = ""
  End If
End Sub
Private Sub grdDetail_AfterEdit(ByVal Row As Long, ByVal Col As Long)
  Dim objReservation As clsReservation
  Select Case tabgrdDetail.SelectedItem.Index
    Case PAYM_TAB
      If Col = 1 Then
        grdDetail.RowData(Row) = gobjPaymentTypes.LookupPaymentTypeID(grdDetail.TextMatrix(Row, 1))
      ElseIf Col = 4 Then
        'reload the Payments, note that we don't just change the one
        'that has changed because if they added a Payment it isn't in
        'the object hierarchy yet.
        Set objReservation = mobjParty.Reservations(lstReservations.Text)
        objReservation.Payments.LoadFromGrid grdDetail
        'and show the new total
        objReservation.Payments.ShowTotals grdDetail, objReservation.Products.GetProductTotal
      End If
    Case PROD_TAB
      Debug.Print "calc totals"
  End Select
End Sub
Private Sub grdDetail_RowColChange()
  Dim nRows As Integer
  If EditingAReservation Then
    If tabgrdDetail.SelectedItem.Index = PAYM_TAB Then
      nRows = grdDetail.Rows
      'this could be shortened?
      If grdDetail.Row = (nRows - 1) Or grdDetail.Row = (nRows - 2) Then
        cmdDeleteDetailItem.Enabled = False
      Else
        cmdDeleteDetailItem.Enabled = True
      End If
    End If
  End If
End Sub
Private Sub grdParties_DragDrop(Source As Control, X As Single, Y As Single)
  If (mobjDragInfo.ID <> SelectedPartyID) _
    And (((mobjDragInfo.NumPassengers + GetNumPass) <= GetMaxPass) Or mUserSettings.AllowOverbooking) Then
    mobjDragInfo.Drop mobjParty, mCon, Me, cldMain.Value, grdParties.TextMatrix(grdParties.Row, 0), anAircraftInfo(grdParties.Col).AircraftID
    ShowParties
  End If
End Sub
Private Sub grdParties_DragOver(Source As Control, X As Single, Y As Single, State As Integer)
  SelectCellNonFixed grdParties
  'doesn't matter what the source is, the info that it needs to know as to drop
  'or not is still contained in mobjDragInfo
  If (((mobjDragInfo.NumPassengers + GetNumPass) > GetMaxPass) And Not mUserSettings.AllowOverbooking) Then
    grdParties.DragIcon = lblSelectedTime.DragIcon
    lstReservations.DragIcon = lblSelectedTime.DragIcon
  Else
    grdParties.DragIcon = lblSelectedDate.DragIcon
    lstReservations.DragIcon = lblSelectedDate.DragIcon
  End If
End Sub
Private Sub grdParties_EnterCell()
  Dim bOnParty As Boolean
  If mbExecutegrdParties_EnterCell Then
    'the actions menu and reservation buttons
    'states should be set here!
    bOnParty = OnParty
    cmdNew.Enabled = CanAddReservations
    cmdSaveEdit.Enabled = bOnParty
    'cmdCancel is never changed by an enter cell
    'only when in the state of a New or Edited
    'reservation
    cmdDelete.Enabled = bOnParty
    lblSelectedTime.Caption = grdParties.TextMatrix(grdParties.Row, 0)
    lblSelectedAircraft.Caption = grdParties.TextMatrix(0, grdParties.Col)
    ShowPartyDetail
  End If
End Sub
Private Function SelectedPartyID() As Long
  SelectedPartyID = alPartyID(grdParties.Col, grdParties.Row)
End Function
Private Sub ShowPartyDetail()
  Dim objReservation As clsReservation
  If OnParty Then
    Debug.Print "showing detail"
    Set mobjParty = Nothing
    Set mobjParty = New clsParty
    mobjParty.Load SelectedPartyID, mCon
    lstReservations.Clear
    ComboFetchByItemData cboPilot, mobjParty.PilotEmployeeID
    For Each objReservation In mobjParty.Reservations
      lstReservations.AddItem objReservation.ReservationID
    Next objReservation
    'the following will cause a lstReservations_Click() event
    'which will invoke objReservation.FillDetailForm frm so
    'we don't do it explicitly
    lstReservations.ListIndex = 0
    cmdSaveEdit.Caption = "&Edit"
  Else
    Set mobjParty = Nothing
    lstReservations.Clear
    cboPilot.ListIndex = -1
    cboAgent.ListIndex = -1
    txtDateMade.Text = ""
    txtNotes.Text = ""
    grdDetail.Rows = 1
  End If
End Sub
Private Sub grdParties_GotFocus()
  grdParties.BackColorFixed = vbHighlight
  grdParties.ForeColorFixed = vbHighlightText
End Sub
Private Sub grdParties_LostFocus()
  grdParties.BackColorFixed = vbButtonFace
  grdParties.ForeColorFixed = vbButtonText
End Sub
Private Sub grdParties_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  'can't let them select the fixed col/rows
  SelectCellNonFixed grdParties
  grdParties.SetFocus
  If Not (mobjParty Is Nothing) And Button = vbLeftButton Then
    'beginning of drag, so set all information
    mobjDragInfo.ID = mobjParty.PartyID
    mobjDragInfo.NumPassengers = GetNumPass
    mobjDragInfo.ReservationOrParty = rmParty
    Set mobjDragInfo.CutObject = mobjParty
    grdParties.Drag vbBeginDrag
  Else
    mobjDragInfo.Clear
  End If
End Sub
Private Sub grdParties_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
  If Button = vbRightButton Then PopupMenu mnuActions
End Sub


Private Sub lblReservations_Click()
  lstReservations.SetFocus
End Sub
Private Sub lstReservations_Click()
  If lstReservations.Text <> "NEW" Then ShowReservationDetail
End Sub
Private Property Let ViewMode(mode As rmViewModes)
  Const RES_TOP = 6480
  Const SPACE_BETWEEN = 360
  Const PILOT_TOP = 7680
  If mode = rmEditMode Then
    'disable top
    frameCalendar.Enabled = False
    SetControlEditState lblReservations, False
    SetControlEditState lstReservations, False
    SetControlEditState grdParties, False
    'why the double, above and below
    grdParties.Enabled = False
    mnuActions.Enabled = False
    mnuDataMaintenance.Enabled = False
    mnuReports.Enabled = False
    'enable bottom
    SetControlEditState cboAgent, True
    SetControlEditState cboPilot, True
    SetControlEditState txtDateMade, True
    SetControlEditState txtNotes, True
    SetControlEditState grdDetail, True
    lblReservationInformation.BackColor = vbHighlight
    lblReservationInformation.ForeColor = vbHighlightText
    'indicate that grdParties and lstReservations is disabled
    SetControlEditState grdParties, False
    SetControlEditState lstReservations, False
    cmdNew.Enabled = False
    cmdSaveEdit.Caption = "&Save"
    cmdSaveEdit.Enabled = True
    cmdCancel.Enabled = True
    cmdDelete.Enabled = False
    SetUpgrdDetailButtons
    cboPilot.SetFocus
  Else ' rezmanViewMode
    cmdSaveEdit.Caption = "&Edit"
    cmdCancel.Enabled = False
    'disable editing
    SetControlEditState cboAgent, False
    SetControlEditState cboPilot, False
    SetControlEditState txtDateMade, False
    SetControlEditState txtNotes, False
    SetControlEditState grdDetail, False
    lblReservationInformation.BackColor = vbButtonFace
    lblReservationInformation.ForeColor = vbButtonText
    'indicate that grdParties and lstReservations are selectable
    SetControlEditState grdParties, True
    SetControlEditState lstReservations, True
    cmdAddDetailItem.Enabled = False
    cmdDeleteDetailItem.Enabled = False
    'enable top
    frameCalendar.Enabled = True
    SetControlEditState lblReservations, True
    SetControlEditState lstReservations, True
    SetControlEditState grdParties, True
    grdParties.Enabled = True
    mnuActions.Enabled = True
    mnuDataMaintenance.Enabled = True
    mnuReports.Enabled = True
    lstReservations.SetFocus
  End If
End Property
Private Function DataValidates() As Boolean
  Dim objReservation As clsReservation
  If cboPilot.ListIndex = -1 Then
    DataValidates = False
    MsgBox "You must choose a pilot.", vbOKOnly, "Choose Pilot"
    Exit Function
  End If
  If cboAgent.ListIndex = -1 Then
    DataValidates = False
    MsgBox "You must choose an agent.", vbOKOnly, "Choose Agent"
    Exit Function
  End If
  If Len(txtDateMade.Text) = 0 Then
    DataValidates = False
    MsgBox "You must enter the date made for the reservation.", vbOKOnly, "Enter Date Made"
    Exit Function
  End If
  If Len(txtNotes.Text) = 0 Then
    DataValidates = False
    MsgBox "You must enter notes for the reservation.", vbOKOnly, "Enter Notes"
    Exit Function
  End If
  'make sure visible tab information has been put in the
  'mobjParty object hierarchy
  Set objReservation = mobjParty.Reservations(lstReservations.Text)
  If objReservation.Passengers.Count = 0 Then
    DataValidates = False
    MsgBox "You must have passengers for a reservation.", vbOKOnly, "Enter Passengers"
    Exit Function
  End If
  If objReservation.Products.Count = 0 Then
    DataValidates = False
    MsgBox "You must have products for a reservation.", vbOKOnly, "Enter Products"
    Exit Function
  End If
  If objReservation.Payments.Count = 0 Then
    DataValidates = False
    MsgBox "You must have a payment for a reservation.", vbOKOnly, "Enter Payment"
    Exit Function
  End If
  DataValidates = True
End Function
Private Sub lstReservations_DragOver(Source As Control, X As Single, Y As Single, State As Integer)
  lstReservations.DragIcon = lblSelectedDate.DragIcon
End Sub
Private Sub lstReservations_GotFocus()
  lblReservations.BackColor = vbHighlight
  lblReservations.ForeColor = vbHighlightText
End Sub
Private Sub lstReservations_LostFocus()
  lblReservations.BackColor = vbButtonFace
  lblReservations.ForeColor = vbButtonText
End Sub
Private Sub lstReservations_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  Dim objReservation As clsReservation
  'right click doesn't do this
  lstReservations.SetFocus
  If OnReservation And Button = vbLeftButton Then
    Set objReservation = mobjParty.Reservations(lstReservations.Text)
    'beginning of drag, so set all information
    mobjDragInfo.ID = objReservation.ReservationID
    mobjDragInfo.NumPassengers = objReservation.Passengers.Count
    mobjDragInfo.ReservationOrParty = rmReservation
    Set mobjDragInfo.CutObject = objReservation
    lstReservations.Drag vbBeginDrag
  End If
End Sub
Private Sub lstReservations_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
  If Button = vbRightButton Then
    PopupMenu mnuActions
  End If
End Sub
Private Sub mnuAboutRezman_Click()
  frmSplash.ShowAbout Me
End Sub
Private Sub mnuActions_Click()
  Dim bOnParty As Boolean
  bOnParty = OnParty
  mnuActionsNewReservation.Enabled = CanAddReservations
  mnuActionsCut.Enabled = bOnParty
  mnuActionsCopy.Enabled = bOnParty
  mnuActionsPaste.Enabled = (mobjCutInfo.IsValid) And (((mobjCutInfo.NumPassengers + GetNumPass) <= GetMaxPass) Or mUserSettings.AllowOverbooking)
  mnuActionsDelete.Enabled = bOnParty
  'now based on what has the focus
  If grdParties.BackColorFixed = vbHighlight Then
    mnuActionsCut.Caption = "Cu&t Party"
    mnuActionsCopy.Caption = "&Copy Party"
    mnuActionsDelete.Caption = "&Delete Party"
  ElseIf lblReservations.BackColor = vbHighlight Then
    mnuActionsCut.Caption = "Cu&t Reservation"
    mnuActionsCopy.Caption = "&Copy Reservation"
    mnuActionsDelete.Caption = "&Delete Reservation"
  Else 'neither has focus
    mnuActionsCut.Enabled = False
    mnuActionsCopy.Enabled = False
    mnuActionsPaste.Enabled = False
    mnuActionsDelete.Enabled = False
  End If
End Sub
Private Sub mnuActionsCut_Click()
  If mnuActionsCut.Caption = "Cu&t Party" Then
    'beginning of cut, so we set all information
    mobjCutInfo.ID = mobjParty.PartyID
    mobjCutInfo.NumPassengers = GetNumPass
    mobjCutInfo.ReservationOrParty = rmParty
    Set mobjCutInfo.CutObject = mobjParty
  Else 'Cu&t Reservation
    'beginning of cut, so set all information
    mobjCutInfo.ID = CLng(lstReservations.Text)
    mobjCutInfo.NumPassengers = grdDetail.Rows - 1
    mobjCutInfo.ReservationOrParty = rmReservation
    Set mobjCutInfo.CutObject = mobjParty.Reservations(lstReservations.Text)
  End If
End Sub
Private Sub mnuActionsCopy_Click()
  If mnuActionsCopy.Caption = "&Copy Party" Then
  
  Else '&Copy Reservation
  
  End If
End Sub
Private Sub mnuActionsDelete_Click()
  Dim nRes As VbMsgBoxResult
  If mnuActionsDelete.Caption = "&Delete Party" Then
    nRes = MsgBox("Are you sure you want to delete the selected party and all of the reservations contained in the party?", vbQuestion + vbYesNo, "Delete Party?")
    If nRes = vbYes Then
      mobjParty.Delete mCon
      ShowParties
    End If
  Else '&Delete Reservation
    nRes = MsgBox("Are you sure you want to delete the selected reservtions?", vbQuestion + vbYesNo, "Delete Reservation?")
    If nRes = vbYes Then
      If lstReservations.ListCount = 1 Then
        'only one reservation, so just delete the party
        mobjParty.Delete mCon
      Else
        mobjParty.Reservations(lstReservations.Text).Delete mCon
      End If
    End If
    ShowParties
  End If
End Sub
Private Sub mnuActionsNewReservation_Click()
  Dim objReservation As clsReservation
  cboAgent.ListIndex = -1
  txtDateMade.Text = FormatDateTime(Now, vbShortDate)
  txtNotes.Text = ""
  grdDetail.Rows = 1
  mnNumPassBeforeEdit = 0
  'setting the ListIndex to -1 will indicate that this is a NEW
  'reservation, otherwise the ListIndex will be on the reservation
  'that is being EDITED
  'lstReservations.ListIndex = -1
  'above is old, now,
  If Not OnParty Then
    Set mobjParty = New clsParty
  End If
  Set objReservation = mobjParty.Reservations.Add("NEW")
  lstReservations.AddItem "NEW"
  lstReservations.ListIndex = lstReservations.NewIndex
  ViewMode = rmEditMode
End Sub
Private Sub mnuActionsPaste_Click()
  mobjCutInfo.Drop mobjParty, mCon, Me, cldMain.Value, grdParties.TextMatrix(grdParties.Row, 0), anAircraftInfo(grdParties.Col).AircraftID
  ShowParties
End Sub
Private Sub mnuAgents_Click()
  frmAgents.ShowAgent mCon, Me
  'in case they added agents or changed the name
  'it must be updated on main form
  SetUpAgents
  ShowPartyDetail
End Sub
Private Sub mnuAgentsCompanies_Click()
  frmAgentsCompanies.ShowAgentsCompany mCon, Me
End Sub
Private Sub mnuAircrafts_Click()
  frmAircrafts.ShowAircraft mCon, Me
  'in case they added aircraft or changed the name
  'it must be updated on the main form
  SetUpPartiesGrid
  ShowParties
End Sub
Private Sub mnuConfigure_Click()
  If frmConfigure.ShowConfigure(Me) Then
    RunStartUpSequence
  End If
End Sub
Private Sub mnuEmployees_Click()
  frmEmployees.ShowEmployee mCon, Me
  'in case they added pilots or changed the name
  'it must be updated on the main form
  SetUpPilots
  ShowPartyDetail
End Sub
Private Sub mnuExit_Click()
  Unload Me
End Sub
Private Sub mnuPaymentTypes_Click()
  frmPaymentTypes.ShowPaymentTypes mCon, Me
  SetUpPaymentTypes
End Sub
Private Sub mnuProducts_Click()
  frmProducts.ShowProduct mCon, Me
End Sub
Private Function OnParty() As Boolean
  OnParty = (SelectedPartyID <> 0)
End Function
Private Function OnReservation() As Boolean
  OnReservation = lstReservations.ListIndex <> -1
End Function
Private Sub SetUpConnection()
  Set mCon = New Connection
  Set mobjParty = New clsParty
  'uncomment to use OLE DB Jet Driver
  mCon.Provider = "Microsoft.Jet.OLEDB.3.51"
  mCon.Open mUserSettings.DataSourceLocation
  
  'comment to use OLE DB ODBC Driver
  'mCon.ConnectionString = "DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" & mUserSettings.DataSourceLocation
  'mCon.Open
End Sub
Private Sub SetUpCutDragInfo()
  Set mobjCutInfo = New clsCutDragInfo
  Set mobjDragInfo = New clsCutDragInfo
End Sub
Private Sub RunStartUpSequence()
  mbExecutegrdParties_EnterCell = False
  GetUserSettings
  SetUpConnection
  SetUpPartiesGrid
  SetUpPilots
  SetUpAgents
  SetUpDetailGrid
  SetUpCutDragInfo
  SetUpPaymentTypes
  'surely this will be forced when I set the date to Today?
  'cldMain_SelChange
  mbExecutegrdParties_EnterCell = True
  ShowParties
End Sub
Private Sub SetUpPaymentTypes()
  Set gobjPaymentTypes = New clsPaymentTypes
  gobjPaymentTypes.LoadPaymentTypes mCon
End Sub
Private Sub CurrentSelections(Action As rmCurrentSelectionAction)
  Static nGridCol As Integer
  Static nGridRow As Integer
  If Action = rmSaveSelections Then
    nGridCol = grdParties.Col
    nGridRow = grdParties.Row
  Else 'rmSetSelections
    grdParties.Col = nGridCol
    grdParties.Row = nGridRow
  End If
End Sub
Private Sub tabgrdDetail_BeforeClick(Cancel As Integer)
  mnOldTab = tabgrdDetail.SelectedItem.Index
End Sub
Private Sub tabgrdDetail_Click()
  Dim nTab As Integer
  Dim objReservation As clsReservation
  nTab = tabgrdDetail.SelectedItem.Index
  Select Case nTab
    Case PASS_TAB
      cmdAddDetailItem.Caption = "&Add Passenger"
      cmdDeleteDetailItem.Caption = "&Delete Passenger"
    Case PAYM_TAB
      cmdAddDetailItem.Caption = "&Add Payment"
      cmdDeleteDetailItem.Caption = "&Delete Payment"
    Case PROD_TAB
      cmdAddDetailItem.Caption = "&Add Product"
      cmdDeleteDetailItem.Caption = "&Delete Product"
  End Select
  If OnReservation Then
    Set objReservation = mobjParty.Reservations(lstReservations.Text)
    If EditingAReservation Then
      Select Case mnOldTab
        Case PASS_TAB
          objReservation.Passengers.LoadFromGrid grdDetail
        Case PROD_TAB
          objReservation.Products.LoadFromGrid grdDetail
        Case PAYM_TAB
          objReservation.Payments.LoadFromGrid grdDetail
      End Select
    End If
    Select Case nTab
      Case PASS_TAB
        objReservation.Passengers.FillGrid grdDetail
      Case PAYM_TAB
        objReservation.Payments.FillGrid grdDetail, objReservation.Products.GetProductTotal
      Case PROD_TAB
        objReservation.Products.FillGrid grdDetail
    End Select
    If EditingAReservation Then SetUpgrdDetailButtons
  End If
End Sub
Private Function EditingAReservation() As Boolean
  EditingAReservation = (lblReservationInformation.BackColor = vbHighlight)
End Function
Private Sub SetUpgrdDetailButtons()
  'this sub assumes they need to be set up
  'i.e. OnParty and in edit mode, otherwise
  'they are always disabled
  Select Case tabgrdDetail.SelectedItem.Index
    Case PASS_TAB
      'they are editing, set up the add/delete buttons
      If mUserSettings.AllowOverbooking Then
        cmdAddDetailItem.Enabled = True
      Else
        cmdAddDetailItem.Enabled = (GetMaxPassCanAdd > 0)
      End If
      cmdDeleteDetailItem.Enabled = (grdDetail.Rows > 1)
    Case PAYM_TAB
      cmdAddDetailItem.Enabled = True
      cmdDeleteDetailItem.Enabled = (grdDetail.Rows > 1)
    Case PROD_TAB
      cmdAddDetailItem.Enabled = True
      cmdDeleteDetailItem.Enabled = (grdDetail.Rows > 1)
  End Select
End Sub
Private Sub ShowReservationDetail()
  Dim objReservation As clsReservation
  Set objReservation = mobjParty.Reservations(lstReservations.Text)
  ComboFetchByItemData cboAgent, objReservation.AgentID
  txtDateMade.Text = objReservation.DateMade
  txtNotes.Text = objReservation.Notes
  Select Case tabgrdDetail.SelectedItem.Index
    Case PASS_TAB
      objReservation.Passengers.FillGrid grdDetail
    Case PAYM_TAB
      objReservation.Payments.FillGrid grdDetail, objReservation.Products.GetProductTotal
    Case PROD_TAB
      objReservation.Products.FillGrid grdDetail
  End Select
End Sub
Public Sub ClearParties()
  Dim nCol As Integer
  Dim nRow As Integer
  Dim nCols As Integer
  Dim nRows As Integer
  'nCols = UBound(alPartyID())
  'nRows = UBound(alPartyID())
  nCols = grdParties.Cols - 1
  nRows = grdParties.Rows - 1
  mbExecutegrdParties_EnterCell = False
  LockWindowUpdate grdParties.hwnd
  For nCol = 1 To nCols
    For nRow = 1 To nRows
      If alPartyID(nCol, nRow) <> 0 Then
        With grdParties
          .Col = nCol
          .Row = nRow
          .CellBackColor = RGB(0, 0, 0)
          .Text = ""
        End With
      End If
    Next nRow
  Next nCol
  LockWindowUpdate 0
  mbExecutegrdParties_EnterCell = True
  'maybe fire it here?
'  Dim nCol As Integer
'  Dim nRow As Integer
'  LockWindowUpdate grd.hwnd
'  For nCol = 1 To (grd.Cols - 1)
'    For nRow = 1 To (grd.Rows - 1)
'      With grd
'        .Col = nCol
'        .Row = nRow
'        .CellBackColor = RGB(0, 0, 0)
'        .Text = ""
'      End With
'    Next nRow
'  Next nCol
'  LockWindowUpdate 0
End Sub
