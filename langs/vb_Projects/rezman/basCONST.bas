Attribute VB_Name = "basCONST"
Option Explicit

Public Const DOUBLE_QUOTE As String = """"
Public Const SPACE As String = " "
Public Const TAXRATE_CELL_PREFIX As String = "Tax @ "
Public Const NEW_PARTY_ID As String = "NEW"
Public Const NEW_RES_ID As String = "NEW"

'yeah I know it is high but the PartyWeight can't
'effectively be checked for causing overflow because
'the pilot weight is stored independently and if they
'change the pilot weight to some huge new value the next
'time they view a reservation it will overflow the integers
'that are being used to calculate the total
'this is set to 1000 so for someone to crash the program with
'an overflow would require a Pilot of weight 1000 and
'31 passengers weighing 1000 plus the little more to
'get to 32,000 + value that would cause the integer
'calculations on Party Weigh to cause an error
Public Const MAX_HUMAN_WEIGHT As Integer = 1000


Public Const CURRENCY_COL_FORMAT As String = "$#,###.00"

Public Const REGISTRY_APP_NAME As String = "RezMan"

'this constant controls what the first hour is visible
'in the schedule control
Public Const SCHEDULE_HOUR_AT_BORDER As Integer = 7

Public Const PASS_TAB As Integer = 1
Public Const PROD_TAB As Integer = 2
Public Const PAYM_TAB As Integer = 3

'grid location constants
Public Const PASS_SUMMARY_ROWS As Integer = 1
Public Const PROD_SUMMARY_ROWS As Integer = 1
Public Const PAYM_SUMMARY_ROWS As Integer = 7

'grid summary row offset constants
'value holds rows from botton with bottom row being 1
Public Const PASS_SUMMARY_ROW_TotalWeight As Integer = 1

Public Const PAYM_SUMMARY_ROW_RemainingBalance As Integer = 1
Public Const PAYM_SUMMARY_ROW_PaymentsTotal As Integer = 2
Public Const PAYM_SUMMARY_ROW_GrandTotal As Integer = 3
Public Const PAYM_SUMMARY_ROW_Tax As Integer = 4
Public Const PAYM_SUMMARY_ROW_Subtotal As Integer = 5
Public Const PAYM_SUMMARY_ROW_ProductsTotal As Integer = 6
Public Const PAYM_SUMMARY_ROW_TourPriceTotal As Integer = 7

Public Const PROD_SUMMARY_ROW_Total As Integer = 1

'grid column location constants

Public Const PASS_COL_TourDescription As Integer = 0
Public Const PASS_COL_TourPrice As Integer = 1
Public Const PASS_COL_FirstName As Integer = 2
Public Const PASS_COL_LastName As Integer = 3
Public Const PASS_COL_Address As Integer = 4
Public Const PASS_COL_Address2 As Integer = 5
Public Const PASS_COL_City As Integer = 6
Public Const PASS_COL_State As Integer = 7
Public Const PASS_COL_Zip As Integer = 8
Public Const PASS_COL_PhoneNumber As Integer = 9
Public Const PASS_COL_Weight As Integer = 10
Public Const PASS_COL_Province As Integer = 11
Public Const PASS_COL_Country As Integer = 12

Public Const PROD_COL_Quantity As Integer = 0
Public Const PROD_COL_Description As Integer = 1
Public Const PROD_COL_UnitPrice As Integer = 2
Public Const PROD_COL_Total As Integer = 3

Public Const PAYM_COL_PaymentType As Integer = 0
Public Const PAYM_COL_CardNumber As Integer = 1
Public Const PAYM_COL_NameOnCard As Integer = 2
Public Const PAYM_COL_ExpirationDate As Integer = 3
'in same column
Public Const PAYM_COL_TaxRate As Integer = 3
Public Const PAYM_COL_Amount As Integer = 4
