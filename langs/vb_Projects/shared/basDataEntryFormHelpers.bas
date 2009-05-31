Attribute VB_Name = "basDataEntryFormHelpers"
Option Explicit
Public Enum eFormState
  BROWSING
  EDITING
End Enum
Private Const ENABLE_COLOR = vbWindowBackground
Private Const DISABLE_COLOR = vbInactiveBorder
Public Sub SetDataEntryFormState(frm As Form, theState As eFormState)
  Dim ctl As Control
  Dim lColor As Long
  Dim bEnabled As Boolean
  If theState = BROWSING Then
    lColor = DISABLE_COLOR
    bEnabled = False
  Else 'EDITING
    lColor = ENABLE_COLOR
    bEnabled = True
  End If
  For Each ctl In frm.Controls
    If Not (TypeOf ctl Is Label) Or (TypeOf ctl Is Frame) Or (TypeOf ctl Is CommandButton) Then
      If (TypeOf ctl Is TextBox) Or (TypeOf ctl Is ComboBox) Then
        ctl.Locked = Not bEnabled
        ctl.BackColor = lColor
      ElseIf (TypeOf ctl Is CheckBox) Then
        ctl.Enabled = bEnabled
      End If
    End If
  Next ctl
End Sub
