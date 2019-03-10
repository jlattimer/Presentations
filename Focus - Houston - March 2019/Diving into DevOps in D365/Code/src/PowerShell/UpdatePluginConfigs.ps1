# Updates the secure & unsecure plug-in configurations
#
# Prerequisites 
# Either StepName or StepId needs to be populated

$Credentials = @{
    Username = "jlattimer@JLMVP.onmicrosoft.com"
    Password = "@aKWy8GT4he9VsO@"
    Url      = "https://jlmvpsandbox.crm.dynamics.com"
}

#$Credentials = @{
#    Username = "$(CrmTestUsername)"
#    Password = "$(CrmTestPassword)"
#    Url = "$(CrmTestUrl)"
#}

$Parameters = @{
    StepName               = "Demo.FakeXrmEasy.Plugin.BasicDebuggingPlugin: Create of account"
    StepId                 = $null
    NewUnsecureConfigValue = "test unsecure"
    NewSecureConfigValue   = "test secure"
}
Write-Verbose "Executing with parameters:"
Write-Verbose ($Parameters | Out-String)

If (!(Get-Module "Microsoft.Xrm.Data.Powershell")) {
    Install-Module -Name Microsoft.Xrm.Data.Powershell -AcceptLicense -AllowClobber -Force -Scope AllUsers
    Write-Host "Installed Microsoft.Xrm.Data.Powershell"
}

$User = $Credentials.Username
$PWord = $Credentials.Password | ConvertTo-SecureString -AsPlainText -Force
$Url = $Credentials.Url

$Cred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $User, $PWord
$Conn = Connect-CrmOnline -Credential $Cred -ServerUrl $Url

if ($Conn.IsReady -eq $false) {
    throw "Error connecting to CRM"
}

# Retrieve the plug-in step
$Filter = ""
if ($($Parameters.StepName)) {
    Write-Host "Using StepName: $($Parameters.StepName)"
    $Filter = "<filter><condition attribute='name' operator='eq' value='" + $($Parameters.StepName) + "'/></filter>"
}
else {
    Write-Host "Using StepId: $($Parameters.StepId)"
    $Filter = "<filter><condition attribute='sdkmessageprocessingstepid' operator='eq' value='" + $($Parameters.StepId) + "'/></filter>"
}
$Fetch = "<fetch><entity name='sdkmessageprocessingstep'><attribute name='configuration'/><attribute name='sdkmessageprocessingstepsecureconfigid'/><attribute name='sdkmessageprocessingstepid'/>$Filter<link-entity name='sdkmessageprocessingstepsecureconfig' from='sdkmessageprocessingstepsecureconfigid' to='sdkmessageprocessingstepsecureconfigid' link-type='outer' alias='sc'><attribute name='secureconfig'/><attribute name='sdkmessageprocessingstepsecureconfigid'/></link-entity></entity></fetch>"
Write-Host $Fetch

Write-Host "Retrieving step"
$SdkSteps = Get-CrmRecordsByFetch -Fetch $Fetch -conn $Conn -AllRows
Write-Host "Retrieve complete"

if ($SdkSteps.Count -eq 0) {
    throw "Unable to find plug-in step"
}

$StepId = $SdkSteps.CrmRecords[0].sdkmessageprocessingstepid
Write-Host "Found StepId: $StepId"

# Update unsecure configuration
if ($($Parameters.NewUnsecureConfigValue)) { 
    Write-Host "Updating step unsecure configuration"
    Set-CrmRecord -EntityLogicalName 'sdkmessageprocessingstep' `
        -Fields @{'configuration' = "$($Parameters.NewUnsecureConfigValue)"} -Id $StepId -conn $Conn
    Write-Host "Update step complete"
}

# Update secure configuration
if ($($Parameters.NewSecureConfigValue)) {

    $SecureConfigParameters = @{
        'Fields' = @{ 'secureconfig' = "$($Parameters.NewSecureConfigValue)" }
        'conn'   = $Conn
    }
    
    $SecureStepId = $SdkSteps.CrmRecords[0].sdkmessageprocessingstepsecureconfigid_Property.Value.Id

    if ($SecureStepId) {
        # Update secure configuration record
        Write-Host "Found SecureStepId: $SecureStepId"
        $SecureConfigParameters['Id'] = [System.Guid]$SecureStepId 

        Write-Host "Updating secure configuration"
        Set-CrmRecord -EntityLogicalName 'sdkmessageprocessingstepsecureconfig' @SecureConfigParameters 
        Write-Host "Update complete"
    } 
    else {
        # Create secure configuration record
        Write-Host "Creating secure configuration"
        $SecureConfigId = New-CrmRecord -EntityLogicalName 'sdkmessageprocessingstepsecureconfig' @SecureConfigParameters
        Write-Host "Create complete"

        # Update unsecure configuration record
        Write-Host "Updating step"
        $SecureConfigRef = New-CrmEntityReference -EntityLogicalName 'sdkmessageprocessingstepsecureconfig' -Id $SecureConfigId
        Set-CrmRecord -EntityLogicalName 'sdkmessageprocessingstep' -conn $Conn -Id $StepId `
            -Fields @{ 'sdkmessageprocessingstepsecureconfigid' = $SecureConfigRef }
        Write-Host "Update complete"
    }
}