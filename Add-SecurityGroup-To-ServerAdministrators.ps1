$Domain = "domain.com"
$SecGroup = "Security-Group-Name"
# Can be replaced with {“SRVxxxx”,”SRVxxxx”}
$Servers = Get-Content "C:\DDESRV.txt"
foreach($srv in $Servers)
{
    Write-Host "working on $srv"
    ([adsi]"WinNT://$srv/Administrators,group").Add("WinNT://$Domain/$SecGroup,group")
}


