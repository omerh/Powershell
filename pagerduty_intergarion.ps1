Param(
  [string]$status,
  [string]$device,
  [string]$name,  
  [string]$message,
  [string]$linksensor,
  [string]$deviceid,
  [string]$lastdown,
  [string]$group
)

if ($status -eq "down") { $eventcreate = "trigger" } else { $eventcreate = "resolve" }
if ($linksensor -eq $null) { $linksensor = "https://linkto_your_incident" }
if ($deviceid -eq $nul) { $deviceid = 000 }
if ($lastdown -eq $null) { $lastdown = 99999 } 

# acording to group set the currect pagerduty API key.
if ($group.ToLower() -eq "eyeshare") { $apikey = "your_api_key" } 
ElseIf ($group.ToLower() -eq "dba") { $apikey = "another_api_key" }
Else { $apikey = "another_api_key" }

## not mandatory
$linksensor = $linksensor -replace ('________________', '__________________')

$Description = "$status - $device $name $message | more info $linksensor  , deviceid: $deviceid | was last down $lastdown | Incident link $linksensor"
	
$Body = @{
  "service_key"=$apikey;
  "incident_key"="$device|$name"; 
  "event_type"= "$eventcreate";
  "description"="$Description";
  "client_url"="$linksensor";
  "details"="$message"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://events.pagerduty.com/generic/2010-04-15/create_event.json" -ContentType application/json -Method POST -Body $Body 
	$Body | out-file "D:\pager$deviceid.txt"

# Debug
"status: $status ; device: $device ; name: $name ; message: $message ; linksensor: $linksensor ; deviceid: $deviceid ; last down: $lastdown ; location: $location ; group: $group" >> D:\param_debug.txt
