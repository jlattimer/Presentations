# Updates a connection string in an app.config or web.config
#
# Prerequisites
# There is only 1 connection string in the ConnectionStrings element

$Parameters = @{
    File     = "F:\Delete Me\CSharpConsole7\CSharpConsole7\App.config" #Config file names change to assembly name + .config in debug/release folders
    Url      = "https://test.crm.dynamics.com"
    Username = "test@test.onmicrosoft.com"
    Password = "password"
    Domain   = "mydomain"
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

# Choose the correct connection string format
# Online using Office 365
# "Url=$($Parameters.Url); Username=$($Parameters.Username); Password=$($Parameters.Password); AuthType=Office365;"

# On-premises with provided user credentials
# "Url=$($Parameters.Url); Domain=mydomain; Username=$($Parameters.Username); Password=$($Parameters.Password); AuthType=AD;"

# On-premises using Windows integrated security 
# "Url=$($Parameters.Url); authtype=AD;"

# On-Premises (IFD) with claims
# "Url=$($Parameters.Url); Domain=$($Parameters.Domain); Username=$($Parameters.Domain)\$($Parameters.Username); Password=$($Parameters.Password); AuthType=IFD;"

$UpdatedConnectionString = "Url=$($Parameters.Url); Username=$($Parameters.Username); Password=$($Parameters.Password); AuthType=Office365;"

# Read file content
Write-Host "Reading file"
$FileContent = [xml](Get-Content -Path $($Parameters.File))

$ConfigNode = $FileContent.SelectSingleNode("configuration");
if ($ConfigNode -eq $null) {
    throw "Could not find configuration node"
}

$ConnStringsNode = $ConfigNode.SelectSingleNode("connectionStrings")
if ($ConnStringsNode -eq $null) {
    throw "Could not find connectionStrings node"
}

# Update connection string
$Updated = $false
foreach ($connString in $ConnStringsNode) {
    if ($null -eq $connString.add) {
        continue
    }

    if ($null -eq $connString.add.connectionString) {
        continue
    }

    $connString.add.connectionString = $UpdatedConnectionString
    Write-Host "Updated connection string"
    $Updated = $true
}

if ($Updated -eq $false) {
    throw "No valid connection string found to update"
}

Write-Host "Updating file"
$FileContent.Save($($Parameters.File))
Write-Host "Updated file"