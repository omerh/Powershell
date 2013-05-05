$NOW = Get-Date
# Days retention
$DAYS = "8"
$TIMETARGET = $NOW.AddDays(-$DAYS)
#Log path, can be a UNC path
$PATH = "C:\Log.log"

$FILES = Get-ChildItem $PATH -Recurse | where {$_.LastWriteTime -le "$TIMETARGET"}

foreach ($FILE in $FILES)
{
    Write-Host "Deleting file: $FILE"
    Remove-Item $File.FullName | Out-Null
}
