Attribute VB_Name = "basADOHelpers"
Option Explicit
Public Function RecordsetIsEmpty(rs As Recordset) As Boolean
  RecordsetIsEmpty = rs.EOF And rs.BOF
End Function
Public Sub FillList(ctl As Control, con As Connection, sSQL As String, sDisplayField As String, sItemDataField As String)
  'works with ComboBox and ListBox
  Dim rs As Recordset
  Set rs = New Recordset
  rs.Open sSQL, con, adOpenForwardOnly, adLockPessimistic
  ctl.Clear
  Do Until rs.EOF
    ctl.AddItem rs(sDisplayField)
    ctl.ItemData(ctl.NewIndex) = rs(sItemDataField)
    rs.MoveNext
  Loop
End Sub

