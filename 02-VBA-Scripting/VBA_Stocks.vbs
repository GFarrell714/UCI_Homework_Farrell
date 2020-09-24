
Sub CalculateTotalStockVolume()

    Dim stock As String
    Dim volume As Long
    Dim lRow As Long
    Dim temp_stock As String
    Dim Tot_volume As Double
    Dim cntr As Integer
    Dim open_stock As Double
    Dim close_stock As Double
    Dim yearly_change As Double
    Dim perc_change As Double
    Dim Column_Headers() As String
    Column_Headers = Split("Ticker,Yearly Change,Percent Change,Total Stock Volume", ",")
        
    temp_stock = ""
    Tot_volume = 0
    cntr = 2
    a = 9
    
    For k = 0 To 3
        ActiveWorkbook.ActiveSheet.Cells(1, a) = Column_Headers(k)
        ActiveWorkbook.ActiveSheet.Cells(1, a).Font.Bold = True
        a = a + 1
    Next k
    ActiveWorkbook.ActiveSheet.Columns("L").ColumnWidth = 20
    
    lRow = ActiveWorkbook.ActiveSheet.Cells(Rows.Count, 1).End(xlUp).row
    
    For i = 2 To Int(lRow)
        stock = ActiveWorkbook.ActiveSheet.Cells(i, 1).Value
        volume = ActiveWorkbook.ActiveSheet.Cells(i, 7).Value
        
        If temp_stock = "" Or temp_stock = stock Then
            If temp_stock = "" Then
                open_stock = ActiveWorkbook.ActiveSheet.Cells(i, 3).Value
            Else
                close_stock = ActiveWorkbook.ActiveSheet.Cells(i, 6).Value
            End If
            Tot_volume = Tot_volume + volume
            temp_stock = stock
            
        ElseIf (temp_stock <> stock) Then
            ActiveWorkbook.ActiveSheet.Cells(cntr, 9) = temp_stock
            ActiveWorkbook.ActiveSheet.Cells(cntr, 12) = Tot_volume
            yearly_change = close_stock - open_stock
            ActiveWorkbook.ActiveSheet.Cells(cntr, 10) = yearly_change
            
            If open_stock <> 0 Then
                perc_change = (yearly_change / open_stock)
                ActiveWorkbook.ActiveSheet.Cells(cntr, 11) = perc_change
            
            End If


            ActiveWorkbook.ActiveSheet.Cells(cntr, 11).NumberFormat = "0.00%"
            If yearly_change > 0 Then
                ActiveWorkbook.ActiveSheet.Cells(cntr, 10).Interior.ColorIndex = 4
            Else
                ActiveWorkbook.ActiveSheet.Cells(cntr, 10).Interior.ColorIndex = 3
            End If
            
            temp_stock = stock
            open_stock = ActiveWorkbook.ActiveSheet.Cells(i, 3).Value
            Tot_volume = volume
            cntr = cntr + 1
        End If
    Next i
    ActiveWorkbook.ActiveSheet.Cells(cntr, 9) = temp_stock
    ActiveWorkbook.ActiveSheet.Cells(cntr, 12) = Tot_volume
    yearly_change = close_stock - open_stock
    ActiveWorkbook.ActiveSheet.Cells(cntr, 10) = yearly_change
    
    If open_stock <> 0 Then
        perc_change = (yearly_change / open_stock)
        ActiveWorkbook.ActiveSheet.Cells(cntr, 11) = perc_change
    End If
    
    ActiveWorkbook.ActiveSheet.Cells(cntr, 11).NumberFormat = "0.00%"
    If yearly_change > 0 Then
        ActiveWorkbook.ActiveSheet.Cells(cntr, 13).Interior.ColorIndex = 4
    Else
        ActiveWorkbook.ActiveSheet.Cells(cntr, 13).Interior.ColorIndex = 3
    End If
End Sub







Sub ComputeMaxAndMin()
    
    Dim lLastRow As Long
    Dim row As Long
    Dim Column_Headers() As String
    Column_Headers = Split("Greatest % Increase,Greatest % Decrease,Greatest Total Volume", ",")
    a = 2
    
    lLastRow = Range("K" & Rows.Count).End(xlUp).row
    
    For i = 0 To 2
        ActiveWorkbook.ActiveSheet.Cells(a, 15) = Column_Headers(i)
        ActiveWorkbook.ActiveSheet.Cells(a, 15).Font.Bold = True
        a = a + 1
    Next i
    ActiveWorkbook.ActiveSheet.Range("P1") = "Ticker"
    ActiveWorkbook.ActiveSheet.Cells(1, 16).Font.Bold = True
    ActiveWorkbook.ActiveSheet.Range("Q1") = "Value"
    ActiveWorkbook.ActiveSheet.Cells(1, 17).Font.Bold = True
    ActiveWorkbook.ActiveSheet.Columns("O").ColumnWidth = 20
    
    ActiveWorkbook.ActiveSheet.Range("Q2").Formula = "=Max(K1:K" & lLastRow & ")"
    row = WorksheetFunction.Match(ActiveWorkbook.ActiveSheet.Range("Q2").Value, ActiveWorkbook.ActiveSheet.Range("K2:K" & lLastRow), 0)
    ActiveWorkbook.ActiveSheet.Range("P2") = ActiveWorkbook.ActiveSheet.Range("I" & (row + 1)).Value
    ActiveWorkbook.ActiveSheet.Range("Q2").NumberFormat = "0.00%"
    
    ActiveWorkbook.ActiveSheet.Range("Q3").Formula = "=Min(K1:K" & lLastRow & ")"
    row = WorksheetFunction.Match(ActiveWorkbook.ActiveSheet.Range("Q3").Value, ActiveWorkbook.ActiveSheet.Range("K2:K" & lLastRow), 0)
    ActiveWorkbook.ActiveSheet.Range("P3") = ActiveWorkbook.ActiveSheet.Range("I" & (row + 1)).Value
    ActiveWorkbook.ActiveSheet.Range("Q3").NumberFormat = "0.00%"
    
    ActiveWorkbook.ActiveSheet.Range("Q4").Formula = "=Max(L1:L" & lLastRow & ")"
    row = WorksheetFunction.Match(ActiveWorkbook.ActiveSheet.Range("Q4").Value, ActiveWorkbook.ActiveSheet.Range("L2:L" & lLastRow), 0)
    ActiveWorkbook.ActiveSheet.Range("P4") = ActiveWorkbook.ActiveSheet.Range("I" & (row + 1)).Value
End Sub






Sub RunAcrossWorkbook()

    Dim xCl As Worksheet
    Application.ScreenUpdating = False
    For Each xCl In Worksheets
        xCl.Select

        Call CalculateTotalStockVolume
        
        Call ComputeMaxAndMin
    Next
    Application.ScreenUpdating = True
    MsgBox ("If you are reading this, then it's a miracle!!!")
End Sub

