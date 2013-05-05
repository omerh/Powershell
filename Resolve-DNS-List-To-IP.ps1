#Creating an excel object
$a = New-Object -comobject Excel.Application
$a.visible = $True

#Creating a sheet
$b = $a.Workbooks.Add()
$c = $b.Worksheets.Item(1)

#Creating excel headers
$c.Cells.Item(1,1) = "DNS"
$c.Cells.Item(1,2) = "IP"

# Excel Styling
$d = $c.UsedRange
$d.Interior.ColorIndex = 19
$d.Font.ColorIndex = 11
$d.Font.Bold = $True


$m = 2
$j = 2

$x = get-content C:\dnslist.txt

foreach ($i in $x)
    {
        $c.cells.item($m,1) = $i
        
        $ipadd = [System.Net.Dns]::GetHostAddresses("$i")  | Select-Object IPAddressToString
        foreach($ip in $ipadd)
        {
        $c.cells.item($m,2) = $ip.IPAddressToString
        $m = $m + 1
        }
}

# Optional if excel visible is true.
$d.EntireColumn.AutoFit()

#Save to file
$b.SaveAs("C:\out.xls")
