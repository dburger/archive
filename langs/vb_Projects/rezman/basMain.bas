Attribute VB_Name = "basMain"
Option Explicit
Public Sub Main()
  Dim objRezmanData As clsRezmanData
  Dim con As Connection
  Set objRezmanData = New clsRezmanData
  Set con = objRezmanData.GetConnection
  If Not con Is Nothing Then
    frmScheduler.ShowScheduler con
  Else
    MsgBox "Unable to establish a connection to the RezMan database.", vbOKOnly + vbCritical, "Database Error"
  End If
End Sub

'I am going to put relevant notes in the basMain

'file dependencies -
'Visual Basic should do a good job of tracking its own dependencies
'as for the constituent controls -

'vsFlex -> only needs the vsFlex.ocx

'vsView -> djbReports.exe needs the vsView.ocx
'HOWEVER, I beleive rezman.exe needs vsView.oca because
'rezman uses the constants of vsView.ocs

'ctSchedule -> needs ctSchedule.ocx and mfc42.dll and msvcrt40.dll
