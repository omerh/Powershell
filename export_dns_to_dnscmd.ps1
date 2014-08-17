$zonelist = Get-Content C:\domains.txt
foreach ($zone in $zonelist)
{
    $zonename = $zone.Trim()
    $dnsserver = "your new dns server"
    $dnsrecords = Get-DnsServerResourceRecord -ZoneName $zonename
    foreach ($dnsrecord in $dnsrecords)
    {
        [string]$host = $dnsrecord.HostName
        $ip = $dnsrecord.RecordData.IPv4Address
        [string]$type = $dnsrecord.RecordType
    
        if($dnsrecord.RecordType -eq "A")
        {
            "DNSCMD $dnsserver /recordadd $zonename $host $type $ip" >> C:\out_dnscmd.txt
        }
    }
}
