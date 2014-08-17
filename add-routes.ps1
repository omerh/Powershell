$servers = Get-Content d:\serverlist.txt
cd D:\Install\Pstools
foreach($server in $servers)
{
	(.\psexec.exe \\"$server" route add 192.168.11.0 mask 255.255.255.0 10.24.0.1 -p)
	(.\psexec.exe \\"$server" route add 192.168.12.0 mask 255.255.255.0 10.24.0.1 -p)
	(.\psexec.exe \\"$server" route add 192.168.21.0 mask 255.255.255.0 10.24.0.1 -p)
	(.\psexec.exe \\"$server" route add 192.168.22.0 mask 255.255.255.0 10.24.0.1 -p)
}
