$xl=New-Object -ComObject Excel.Application
$wb=$xl.WorkBooks.Open('C:\tmp\Servers.xlsx')
$ws=$wb.WorkSheets.item(1)
$xl.Visible=$true

$ws.Cells.Item(1,1)=1

$wb.SaveAs('C:\tmp\Servers.xlsx')
$xl.Quit()