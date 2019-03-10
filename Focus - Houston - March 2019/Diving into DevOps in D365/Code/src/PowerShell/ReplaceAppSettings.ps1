# Updates an app settings in an app.config or web.config

# Add key/value pairs where the key matches the app settings key
$Parameters = @{
    File           = "F:\Delete Me\CSharpConsole7\CSharpConsole7\App.config" #Config file names change to assembly name + .config in debug/release folders
    OnlineCrmUrl   = "https://test.crm.dynamics.com"
    OnlineUsername = "test@test.onmicrosoft.com"
    OnlinePassword = "password"
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

# Read file content
Write-Host "Reading file"
$FileContent = [xml](Get-Content -Path "$($Parameters.File)")

$ConfigNode = $FileContent.SelectSingleNode("configuration");
if ($ConfigNode -eq $null) {
    throw "Could not find configuration node"
}

$AppSettingsNode = $ConfigNode.SelectSingleNode("appSettings")
if ($AppSettingsNode -eq $null) {
    throw "Could not find appSettings node"
}

# Update matching app settings
$Updated = $false
foreach ($appSetting in $AppSettingsNode.ChildNodes | Where { $_ -is [System.Xml.XmlElement] }) {
    If ($Parameters.ContainsKey($appSetting.Key)) {
        $appSetting.value = $Parameters.Item($appSetting.Key)
        Write-Host "Updated: $($appSetting.Key)"
        $Updated = $true
    }
}

If ($Updated -eq $false) {
    throw "No app settings found to update"
}

Write-Host "Updating file"
$FileContent.Save($($Parameters.File))
Write-Host "Updated file"