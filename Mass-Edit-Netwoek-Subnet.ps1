$servers = Get-Content C:\ServerList.txt

foreach($server in $servers){
  $nic = Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $server| where {$_.IPAddress -match '192.168.17'}
  Write-Host $nic
  $nic.EnableStatic($NIC.IPAddress, @("255.255.254.0"))
  Write-Host "Nic After chaneg"
  Write-Host $nic
}
