VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form frmReportSelector 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "Report Selector"
   ClientHeight    =   1770
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4425
   ClipControls    =   0   'False
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1770
   ScaleWidth      =   4425
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton cmdClose 
      Caption         =   "Close"
      Height          =   495
      Left            =   3120
      TabIndex        =   3
      Top             =   1200
      Width           =   1215
   End
   Begin VB.CommandButton cmdCreate 
      Caption         =   "&Create"
      Height          =   495
      Left            =   3120
      TabIndex        =   2
      Top             =   660
      Width           =   1215
   End
   Begin VB.ComboBox cboReport 
      Height          =   315
      ItemData        =   "frmReportSelector.frx":0000
      Left            =   900
      List            =   "frmReportSelector.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   1
      Top             =   120
      Width           =   3405
   End
   Begin MSComCtl2.DTPicker dpEndDate 
      Height          =   315
      Left            =   900
      TabIndex        =   4
      Top             =   1260
      Width           =   1515
      _ExtentX        =   2672
      _ExtentY        =   556
      _Version        =   393216
      Format          =   24444929
      CurrentDate     =   36295
   End
   Begin MSComCtl2.DTPicker dpStartDate 
      Height          =   315
      Left            =   900
      TabIndex        =   5
      Top             =   720
      Width           =   1515
      _ExtentX        =   2672
      _ExtentY        =   556
      _Version        =   393216
      Format          =   24444929
      CurrentDate     =   36295
   End
   Begin VB.Label lblEndDate 
      Caption         =   "End Date:"
      Height          =   285
      Left            =   60
      TabIndex        =   7
      Top             =   1320
      Width           =   795
   End
   Begin VB.Label lblStartDate 
      Caption         =   "Start Date:"
      Height          =   285
      Left            =   60
      TabIndex        =   6
      Top             =   780
      Width           =   885
   End
   Begin VB.Label lblReport 
      Caption         =   "Report:"
      Height          =   285
      Left            =   60
      TabIndex        =   0
      Top             =   150
      Width           =   645
   End
End
Attribute VB_Name = "frmReportSelector"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mobjParty As clsParty
Private mobjReservation As clsReservation
Private mCon As Connection
'these strings will hold the delimited PaymentList
'and ProductList stuff according the to vsFlexGrid
'ColComboList property, this will be parsed later to
'change ids into product descriptions and payment
'types
Private msPaymentTypes As String
Private msProductList As String
Private msTourList As String
Private msPilotWeight As String
Private mobjAppSettings As clsAppSettings
Public Sub ShowReportSelector(objParty As clsParty, objReservation As clsReservation, objappsettings As clsAppSettings, sPaymentTypes As String, sProductList As String, sTourList As String, sPilotWeight As String, con As Connection, frmParent As Form)
  Dim dtPreviousMonthDate As Date
  Dim nDaysInMonth As Integer
  Set mobjParty = objParty
  Set mobjReservation = objReservation
  Set mCon = con
  msPaymentTypes = sPaymentTypes
  msProductList = sProductList
  msTourList = sTourList
  msPilotWeight = sPilotWeight
  Set mobjAppSettings = objappsettings
  cboReport.AddItem "Agent"
  If mobjParty Is Nothing Then
    cboReport.ListIndex = 0
  Else 'can do party/reservation specific reports
    cboReport.AddItem "Party"
    cboReport.AddItem "Reservation"
    cboReport.ListIndex = 2
  End If
  dtPreviousMonthDate = DateAdd("m", -1, Now)
  dpStartDate.Value = dtPreviousMonthDate
  dpStartDate.Day = 1
  dpEndDate.Value = dtPreviousMonthDate
  nDaysInMonth = DaysInMonth(dtPreviousMonthDate)
  dpEndDate.Day = nDaysInMonth
  Me.Show vbModal, frmParent
End Sub
Private Sub cboReport_click()
  Select Case cboReport.Text
    Case "Party", "Reservation"
      ChangeDateSelectors False
    Case Else
      ChangeDateSelectors True
  End Select
End Sub
Private Sub cmdClose_Click()
  Unload Me
End Sub
Private Sub cmdCreate_Click()
  Select Case cboReport.Text
    Case "Agent"
      ShowAgentReport
    Case "Party"
      ShowPartyReport
    Case "Reservation"
      ShowReservationReport
  End Select
End Sub
Private Sub ChangeDateSelectors(bEnabled As Boolean)
  dpStartDate.Enabled = bEnabled
  dpEndDate.Enabled = bEnabled
End Sub
Private Sub ShowAgentReport()
  Dim objReport As djbReports.clsReport
  Dim objReservation As clsReservation
  Dim objAgents As clsAgents
  Dim objAgent As clsAgent
  Dim nReservationCounter As Integer
  Dim nAgentCount As Integer
  Dim nAgentCounter As Integer
  Set objAgents = New clsAgents
  objAgents.Load dpStartDate, dpEndDate, mCon
  nAgentCount = objAgents.Count
  Set objReport = New djbReports.clsReport
  objReport.TableSep = vbTab & ";"
  objReport.StartDoc
  nReservationCounter = 1
  nAgentCounter = 1
  For Each objAgent In objAgents
    ShowTitle "Agent Report", objReport
    objReport.TextAlign = taCenterTop
    objReport.Text = "Agent Report for " & FormatDateTime(dpStartDate, vbShortDate) & " to " & FormatDateTime(dpEndDate, vbShortDate) & "." & VBA.String$(2, vbCrLf)
    objReport.TextAlign = taLeftTop
    ShowAgentInformation objAgent, objReport
    objReport.Text = vbCrLf
    For Each objReservation In objAgent.Reservations
      objReport.Text = "Reservation #" & CStr(nReservationCounter)
      ShowPassengers objReservation.Passengers, msTourList, objReservation.GetLeadPassengerName, objReport
      objReport.Text = vbCrLf
      ShowProducts objReservation, msProductList, objReservation.GetLeadPassengerName, objReport
      objReport.Text = vbCrLf
      ShowPayments objReservation, msPaymentTypes, objReservation.GetLeadPassengerName, objReport
      objReport.Text = vbCrLf
      nReservationCounter = nReservationCounter + 1
    Next objReservation
    objReport.Text = "Reservation Summary for Agent " & objAgent.FirstName & " " & objAgent.LastName & " for " & FormatDateTime(dpStartDate, vbShortDate) & " to " & FormatDateTime(dpEndDate, vbShortDate) & "." & VBA.String$(2, vbCrLf)
    objReport.Text = "Total Reservations:  " & objAgent.Reservations.Count & vbCrLf
    objReport.Text = VBA.String$(80, "-") & VBA.String$(2, vbCrLf)
    If nAgentCounter < nAgentCount Then objReport.NewPage
    nReservationCounter = 1
    nAgentCounter = nAgentCounter + 1
  Next objAgent
  'have to remove the last NewPage that was added to make ready
  'for the next Agent, which there wasn't
  objReport.EndDoc
  objReport.Caption = "Agent Report"
  objReport.ShowReport
End Sub
Private Sub ShowReservationReport()
  Dim objReport As djbReports.clsReport
  Dim objLeadPassenger As clsPassenger
  Set objReport = New djbReports.clsReport
  objReport.TableSep = vbTab & ";"
  Set objLeadPassenger = mobjReservation.Passengers(1)
  objReport.StartDoc
  ShowTitle "Reservation Report", objReport
  ShowPartyInfo objReport
  objReport.Text = objLeadPassenger.FirstName & " " & objLeadPassenger.LastName & vbCr
  objReport.Text = objLeadPassenger.Address & vbCr
  If Len(objLeadPassenger.Address2) Then
    objReport.Text = objLeadPassenger.Address2 & vbCr
  End If
  objReport.Text = objLeadPassenger.City & ", " & objLeadPassenger.State & " " & objLeadPassenger.Province & " " & objLeadPassenger.Zip & vbCr
  objReport.Text = objLeadPassenger.Country & VBA.String$(2, vbCr)
  ShowPassengers mobjReservation.Passengers, msTourList, objLeadPassenger.LastName, objReport
  objReport.Text = VBA.String$(2, vbCr)
  ShowProducts mobjReservation, msProductList, objLeadPassenger.LastName, objReport
  objReport.Text = VBA.String$(2, vbCr)
  ShowPayments mobjReservation, msPaymentTypes, objLeadPassenger.LastName, objReport
  objReport.Text = VBA.String$(2, vbCr)
  objReport.Text = "Note:  " & mobjReservation.Notes
  objReport.EndDoc
  objReport.Caption = "Reservation Report"
  objReport.ShowReport
End Sub
Private Sub ShowPartyReport()
  Dim objReport As djbReports.clsReport
  Dim objLeadPassenger As clsPassenger
  Dim objReservation As clsReservation
  Set objReport = New djbReports.clsReport
  objReport.TableSep = vbTab & ";"
  objReport.StartDoc
  ShowTitle "Party Report", objReport
  ShowPartyInfo objReport
  For Each objReservation In mobjParty.Reservations
    ShowPassengers objReservation.Passengers, msTourList, objReservation.GetLeadPassengerName, objReport
    objReport.Text = vbCr
  Next
  objReport.Text = "Total Passengers:  " & mobjParty.PassengerCount & vbCr
  objReport.Text = "Total Weight:  " & mobjParty.TotalWeight(frmScheduler.GetPilotWeightFromTagStringByID(mobjParty.PilotEmployeeID))
  objReport.EndDoc
  objReport.Caption = "Party Report"
  objReport.ShowReport
End Sub
Private Sub ShowTitle(sReportType As String, objReport As djbReports.clsReport)
  objReport.TextAlign = taCenterTop
  objReport.Font.Size = "32"
  objReport.Font.Bold = True
  objReport.Text = mobjAppSettings.CompanyName & vbCr
  objReport.Font.Size = 14
  objReport.Text = mobjAppSettings.Address & vbCr
  objReport.Text = mobjAppSettings.City & "," & mobjAppSettings.State & vbCr
  objReport.Text = mobjAppSettings.PhoneNumber & "  *  " & mobjAppSettings.EmailAddress & "  *  " & mobjAppSettings.WWWAddress & VBA.String$(2, vbCr)
  objReport.Text = sReportType & VBA.String$(2, vbCr)
  objReport.Font.Size = 12
  objReport.Font.Bold = False
  objReport.TextAlign = taLeftTop
End Sub
Private Sub ShowPartyInfo(objReport As djbReports.clsReport)
  objReport.Text = "Party ID:  " & mobjParty.PartyID & "      Date:  " & mobjParty.DateOf
  objReport.Text = "Start Time:  " & TimeFromMinutesSinceMidnight(mobjParty.StartTime) & "   End Time:  " & TimeFromMinutesSinceMidnight(mobjParty.EndTime) & VBA.String$(2, vbCr)
End Sub
Private Sub ShowPassengers(objPassengers As clsPassengers, sTourList As String, sReservationName As String, objReport As djbReports.clsReport)
  Dim objPassenger As clsPassenger
  Dim sTemp As String
  Dim sHeader As String
  Dim sFormat As String
  Dim nCounter As Integer
  Dim astr() As String
  sHeader = "First Name" & vbTab & "Last Name" & vbTab & "Weight" & vbTab & "Tour Package" & vbTab & "Price;"
  sFormat = "<1.2in" & vbTab & "<1.2in" & vbTab & ">1.2in" & vbTab & ">1.5in" & vbTab & ">1.2in;"
  For Each objPassenger In objPassengers
    sTemp = sTemp & objPassenger.FirstName & vbTab
    sTemp = sTemp & objPassenger.LastName & vbTab
    sTemp = sTemp & objPassenger.Weight & vbTab
    sTemp = sTemp & objPassenger.TourListID & vbTab
    sTemp = sTemp & FormatCurrency(objPassenger.TourPrice, 2, vbTrue, vbFalse, vbTrue) & ";"
  Next objPassenger
  sTemp = sTemp & vbTab & "Total Weight:" & vbTab & objPassengers.TotalWeight & vbTab & "Total Tour Price:" & vbTab & FormatCurrency(objPassengers.TotalTourPrice, 2, vbTrue, vbFalse, vbTrue)
  'extra line for table header row
  If objReport.TableBreaksPage(sFormat & "F" & vbTab & "L" & vbTab & "W" & vbTab & "T" & vbTab & "T;" & sHeader & sTemp) Then objReport.NewPage
  objReport.AddTable "^6.3in", "PASSENGERS FROM " & sReservationName & " RESERVATION", "", RGB(200, 200, 200)
  objReport.StartTable
  objReport.AddTable sFormat, sHeader, sTemp, RGB(200, 200, 200), vbWhite
  For nCounter = 1 To objPassengers.Count
    sTemp = objReport.GetSingleTableCell(tcText, nCounter, 4)
    astr = ExtractRowFromDataString(sTourList, sTemp)
    objReport.LetSingleTableCell(tcText, nCounter, 4) = astr(0)
  Next nCounter
  objReport.EndTable
End Sub
Private Sub ShowProducts(objReservation As clsReservation, sProductList As String, sReservationName As String, objReport As djbReports.clsReport)
  'the sProduct list contains the same string as the ColComboData for the vsFlexGrid
  'on the frmScheduler screen, this is a very slick way to get the Product Description
  'from the ProductID
  Dim astr() As String
  Dim objProduct As clsProduct
  Dim objProducts As clsProducts
  Dim nCounter As Integer
  Dim sTemp As String
  Dim sHeader As String
  Dim sFormat As String
  sHeader = "Quantity" & vbTab & "Product" & vbTab & "Unit Price" & vbTab & "Extended Price;"
  sFormat = ">1.5in" & vbTab & "<1.6in" & vbTab & ">1.6in" & vbTab & ">1.6in;"
  Set objProducts = objReservation.Products
  For Each objProduct In objProducts
    sTemp = sTemp & objProduct.GetRowString & ";"
  Next objProduct
  sTemp = sTemp & objReservation.Products.TotalRowString
  'extra line for table header row
  If objReport.TableBreaksPage(sFormat & "Q" & vbTab & "P" & vbTab & "U" & vbTab & "E;" & sHeader & sTemp) Then objReport.NewPage
  objReport.AddTable "^6.3in", "PRODUCTS FROM " & sReservationName & " RESERVATION", "", RGB(200, 200, 200)
  objReport.StartTable
  objReport.AddTable sFormat, sHeader, sTemp, RGB(200, 200, 200), vbWhite
  For nCounter = 1 To objProducts.Count
    sTemp = objReport.GetSingleTableCell(tcText, nCounter, 2)
    astr = ExtractRowFromDataString(sProductList, sTemp)
    objReport.LetSingleTableCell(tcText, nCounter, 2) = astr(0)
  Next nCounter
  objReport.EndTable
End Sub
Private Sub ShowPayments(objReservation As clsReservation, sPaymentTypes As String, sReservationName As String, objReport As djbReports.clsReport)
  'same as above proc
  Dim astr() As String
  Dim nCounter As Integer
  Dim objPayment As clsPayment
  Dim objPayments As clsPayments
  Dim sTemp As String
  Dim sHeader As String
  Dim sFormat As String
  Dim fTaxRate As Single
  Dim cTourPriceTotal As Currency
  Dim cProductsTotal As Currency
  sHeader = "Payment Type" & vbTab & "Name on Card" & vbTab & "Card Number" & vbTab & "Expiration Date" & vbTab & "Amount;"
  sFormat = "<1.1in" & vbTab & " <1.3in" & vbTab & " <2.2in" & vbTab & " <.9in" & vbTab & " >.8in;"
  Set objPayments = objReservation.Payments
  For Each objPayment In objPayments
    sTemp = sTemp & objPayment.GetRowString & ";"
  Next objPayment
  fTaxRate = objReservation.TaxRate
  cTourPriceTotal = objReservation.Passengers.TotalTourPrice
  cProductsTotal = objReservation.Products.GetProductTotal
  sTemp = sTemp & objReservation.Passengers.RTourPriceTotalRowStringForPayments & ";"
  sTemp = sTemp & objReservation.Products.RTotalRowStringForPayments & ";"
  sTemp = sTemp & objReservation.Payments.RSubtotalRowString(cTourPriceTotal, cProductsTotal) & ";"
  sTemp = sTemp & objReservation.Payments.RTaxRowString(fTaxRate, cTourPriceTotal, cProductsTotal) & ";"
  sTemp = sTemp & objReservation.Payments.RGrandTotalRowString(fTaxRate, cTourPriceTotal, cProductsTotal) & ";"
  sTemp = sTemp & objReservation.Payments.RTotalPaymentsRowString & ";"
  sTemp = sTemp & objReservation.Payments.RRemainingBalanceRowString(fTaxRate, cTourPriceTotal, cProductsTotal)
  'extra line for table header row
  If objReport.TableBreaksPage(sFormat & "P" & vbTab & "N" & vbTab & "C" & vbTab & "E" & vbTab & "A;" & sHeader & sTemp) Then objReport.NewPage
  objReport.AddTable "^6.3in", "PAYMENTS FROM " & sReservationName & " RESERVATION", "", RGB(200, 200, 200)
  objReport.StartTable
  objReport.AddTable sFormat, sHeader, sTemp, RGB(200, 200, 200), vbWhite
  For nCounter = 1 To objPayments.Count
    sTemp = objReport.GetSingleTableCell(tcText, nCounter, 1)
    astr = ExtractRowFromDataString(sPaymentTypes, sTemp)
    objReport.LetSingleTableCell(tcText, nCounter, 1) = astr(0)
  Next nCounter
  objReport.EndTable
End Sub
Private Sub ShowAgentInformation(objAgent As clsAgent, objReport As djbReports.clsReport)
  With objAgent
    objReport.Text = .FirstName & " " & .LastName & vbCrLf
    objReport.Text = .Address & vbCrLf
    If Len(.Address2) Then objReport.Text = .Address2 & vbCrLf
    objReport.Text = .City & ", " & .State & "  " & .Zip & vbCrLf
    objReport.Text = .PhoneNumber & vbCrLf
  End With
End Sub
