## The new relic installer commnads
#$COMMAND = "msiexec.exe /i C:\NewRelicAgent_xxxx.msi /qb NR_LICENSE_KEY=LICCENSE ADDLOCAL=ProgramsFeature,AllAppsEnvironmentFeature,IISRegistryFeature,ToolsShortcutFeature"
#$DEFAULTCOM = "msiexec.exe /i C:\NewRelicAgent_xxxx.msi /qb NR_LICENSE_KEY=LICENSE INSTALLLEVEL=1"


$SITESFOLDER = "IIS Websites location"
$FOLDERS = ChildItem $SITESFOLDER
foreach ($FLD in $FOLDERS)
{

    #Write-Host "Checking if there is a web.config file"
    $CONF = "$SITESFOLDER\$FLD\web.config"

    if (Test-Path $CONF)
    {
        #Write-Host "Web.config file found on $FLD"

        [xml]$xml = Get-Content $CONF

        $appSettingsNode = $xml.SelectSingleNode("//configuration/appSettings")

        if (-not $appSettingsNode)
        {
            Write-Host "There is no AppSettings in $FLD"
            $appSettings = $xml.configuration["appSettings"]
            $as = $xml.CreateElement("appSettings")
            $xml.SelectSingleNode("//configuration").AppendChild($as)
            $xml.Save($CONF)
        
            [xml]$xml = Get-Content $CONF
        
            $serviceURLNode = $xml.CreateNode('element',"add","")    
            $serviceURLNode.SetAttribute("key", "NewRelic.AgentEnabled")
            $serviceURLNode.SetAttribute("value", 'true' )
            $appSettingsNode =  $xml.SelectSingleNode("//configuration/appSettings").AppendChild($serviceURLNode)
  
            $serviceURLNode = $xml.CreateNode('element',"add","")    
            $serviceURLNode.SetAttribute("key", "NewRelic.AppName")
            $serviceURLNode.SetAttribute("value", $FLD )
            $appSettingsNode =  $xml.SelectSingleNode("//configuration/appSettings").AppendChild($serviceURLNode)
            $xml.Save($CONF)
        }

        else
        {
            if (-not $appSettingsNode.InnerXml.Contains("NewRelic.AgentEnabled"))
            {
                $serviceURLNode = $xml.CreateNode('element',"add","")    
                $serviceURLNode.SetAttribute("key", "NewRelic.AgentEnabled")
                $serviceURLNode.SetAttribute("value", 'true' )
                $appSettingsNode =  $xml.SelectSingleNode("//configuration/appSettings").AppendChild($serviceURLNode)
            }

            if (-not $appSettingsNode.InnerXml.Contains("NewRelic.AppName"))
            {
                $serviceURLNode = $xml.CreateNode('element',"add","")    
                $serviceURLNode.SetAttribute("key", "NewRelic.AppName")
                $serviceURLNode.SetAttribute("value", $FLD )
                $appSettingsNode =  $xml.SelectSingleNode("//configuration/appSettings").AppendChild($serviceURLNode)
            }

            $xml.Save($CONF)
        }
        }
        else
        {
            Write-Host "No web.config file found on $FLD" 
        }

}
