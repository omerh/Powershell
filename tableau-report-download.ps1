# Set working dir for runnning with tabcmd
Set-Location -Path "T:\Program Files\Tableau\Tableau Server\9.0\bin"
# Some vars
$timestemp = Get-Date -UFormat "%d%m%Y_%H%M%S"
$filelocation = "T:\"
$filename = "file-$timestemp.csv"
$filesaveloaction = "$filelocation\$filename"
#emails
$fromadd = "from address"
[string[]]$toadd = "1 email","2 email"
$smtp = "smtp server"
# file rotate
$keepfile = 5
#file / view to download
$file = "file to download"
$tableauUrl = "https://tableau url"
$tableauUser = "user"
$tableauPass = "password"

function TableauWork()
{
    #Login to server
    .\tabcmd.exe login -s $tableauUrl -u $tableauUser -p $tableauPass --no-certcheck
    #Download file
    .\tabcmd.exe get $file --no-certcheck -f $filesaveloaction
}
function sendEmail()
{
    Send-MailMessage -To $toadd -From $fromadd -Attachments $filesaveloaction -Subject "email subject $(Get-date)" -SmtpServer $smtp
}

function rotate()
{
    Get-ChildItem $filelocation -Recurse | sort CreationTime -Descending | select -Skip $keepfile | Remove-Item -Force
}

function checkRowCountExcel()
{
    $xlShiftDown = -4121
    $Excel = New-Object -ComObject Excel.Application
    $Excel.Visible = $false
    $Workbook = $Excel.workbooks.open($filesaveloaction)
    $Sheet = $Workbook.Worksheets.Item(1)
    $objectRange = $Sheet.UsedRange
    $RowCount = $objRange.Rows.Count
    $Sheet.Cells.Item(1,1).EntireRow.Delete()
    $eRow = $Sheet.cells.item(1,1).entireRow
    $active = $eRow.activate()
    $active = $eRow.insert($xlShiftDown)
    $eRow = $Sheet.cells.item(1,1).entireRow
    $active = $eRow.activate()
    $active = $eRow.insert($xlShiftDown)
    $Sheet.Cells.item(1,1) = "CID=222222"
    $Sheet.Cells.item(2,1) = "SUBID=23232"
    Write-Host "$RowCount"
    #$Excel.DisplayAlerts = $false
    $Workbook.Save()
    #$Excel.Save()
    $Excel.Quit()
    return $RowCount
}


TableauWork
Stop-Process -Name Excel
$returnRowCount = checkRowCountExcel

if ($returnRowCount -gt 0)
{
    Write-Host "Sending email"
    Stop-Process -Name Excel -Force
    sleep 2
    sendemail
}

rotate
