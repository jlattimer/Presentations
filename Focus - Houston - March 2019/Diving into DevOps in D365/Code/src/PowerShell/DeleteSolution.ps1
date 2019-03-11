# Deletes a solution or solution patch

$Credentials = @{
    Username = "$(CrmTestUsername)"
    Password = "$(CrmTestPassword)"
    Url = "$(CrmTestUrl)"
}

# TODO: Need to figure out how to remove version number
$Parameters = @{
    SolutionUniqueName = "test_Patch_3308efe8_1_0_1_0.zip"
    ErrorIfMissing     = $false
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

$SolutionName = $($Parameters.SolutionUniqueName)

If ($SolutionName.EndsWith('.zip', "CurrentCultureIgnoreCase")) {
    $SolutionName = $SolutionName.TrimEnd('.zip')
    $SolutionName = $SolutionName.Trim
}
Write-Host "SolutionName: $SolutionName"

# Find the solution id
$Solutions = Get-CrmRecords -EntityLogicalName solution `
    -conn $Conn `
    -Fields 'solutionid', 'friendlyname', 'version', 'ismanaged', 'uniquename' `
    -FilterAttribute uniquename `
    -FilterOperator eq `
    -FilterValue $SolutionName

# Delete the solution
If ($Solutions.CrmRecords.Count -eq 1) {
    Write-Host "Deleting Solution: $SolutionName"
    Remove-CrmRecord -EntityLogicalName solution -Id $Solutions.CrmRecords[0].solutionid -conn $Conn
    Write-Host "Deletion complete"
}
Else {
    If ($Parameters.ErrorIfMissing) {
        Throw "Unable to find solution: $SolutionName"
    }
    Else {
        Write-Host "Unable to find solution: $SolutionName"
    }
}