Attribute VB_Name = "basFlexGridHelpers"
Option Explicit
Public Sub SetColumnWidths(grd As VSFlexGrid)
  Dim nColumnsToSize As Integer
  Dim nControlWidth As Integer
  Dim nLeftOverWidth As Integer
  Dim nNewColWidth As Long
  Dim nLoop As Integer
  nColumnsToSize = grd.Cols
  nControlWidth = grd.ClientWidth
  nNewColWidth = (nControlWidth \ nColumnsToSize)
  For nLoop = 0 To (nColumnsToSize - 1)
    grd.ColWidth(nLoop) = nNewColWidth
  Next nLoop
End Sub
Public Sub FillGridFromRS(grd As VSFlexGrid, rs As Recordset)
  Dim fld As Field
  Dim nFieldCounter As Integer
  Dim nFields As Integer
  Dim lRowCount As Long
  Dim v()
  nFields = rs.Fields.Count
  grd.Cols = nFields
  For Each fld In rs.Fields
    grd.TextMatrix(0, nFieldCounter) = fld.Name
    nFieldCounter = nFieldCounter + 1
  Next fld
  v = rs.GetRows()
  For lRowCount = 0 To (UBound(v, 2))
    grd.Rows = grd.Rows + 1
    For nFieldCounter = 0 To nFields - 1
      grd.TextMatrix(lRowCount + 1, nFieldCounter) = VBA.Format$(v(nFieldCounter, lRowCount))
    Next nFieldCounter
  Next lRowCount
End Sub
'function for parsing ColComboList data was moved to miscellaneous for use
'with the ColComboList data format in multiple situations
