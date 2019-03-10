# Export the latest version of a solution
#
# https://docs.microsoft.com/en-us/dynamics365/customer-engagement/customize/import-update-export-solutions#export-solutions
#
# Output Pipeline Variable: D365SolutionName (soution uniquename)
# Output Pipeline Variable: D365SolutionVersion (solution version)
# Output Pipeline Variable: D365SolutionFilenamen (solution filename)


#$Credentials = @{
#    Username = "crmadmin@org.onmicrosoft.com"
#    Password = "password"
#    Url = "https://org.crm.dynamics.com"
#}

#$Credentials = @{
#    Username = 'jlattimer@JLMVP.onmicrosoft.com'
#    Password = 'RcEg!g6$3iZV3'
#    Url = 'https://jlmvp.crm.dynamics.com'
#}

$Credentials = @{
    Username = "$(CrmDevUsername)"
    Password = "$(CrmDevPassword)"
    Url      = "$(CrmDevUrl)"
}

$Parameters = @{
    SolutionUniqueName = 'FTSMA'
    OutputPath         = "$(Agent.BuildDirectory)\DownloadedSolutions"
    ExportAsManaged    = $false
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

If (!(Get-Module "Microsoft.Xrm.Data.Powershell")) {
    Install-Module -Name Microsoft.Xrm.Data.Powershell -AcceptLicense -AllowClobber -Force -Scope AllUsers
    Write-Host "Installed Microsoft.Xrm.Data.Powershell"
}

$User = $Credentials.Username
$PWord = $Credentials.Password | ConvertTo-SecureString -AsPlainText -Force
$Url = $Credentials.Url

$ReturnSolutionName = ''
$ReturnSolutionVersion = ''

$Cred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $User, $PWord
$Conn = Connect-CrmOnline -Credential $Cred -ServerUrl $Url

If ($Conn.IsReady -eq $false) {
    Throw "Error connecting to CRM"
}

# Create target folder
New-Item -ItemType Directory -Force -Path $($Parameters.OutputPath)
Write-Host "Created folder: $($Parameters.OutputPath)"

# Get parent solution by name
Write-Host "Searching for solution: $($Parameters.SolutionUniqueName)"
$Solutions = Get-CrmRecords -EntityLogicalName solution `
    -conn $Conn `
    -Fields 'solutionid', 'friendlyname', 'version', 'ismanaged', 'uniquename' `
    -FilterAttribute uniquename `
    -FilterOperator eq `
    -FilterValue $Parameters.SolutionUniqueName

If ($Solutions.CrmRecords.Count -eq 1) {
    $ParentSolutionId = $Solutions.CrmRecords[0].solutionid
    $ReturnSolutionName = $Solutions.CrmRecords[0].uniquename 
    $ReturnSolutionVersion = "_" + $Solutions.CrmRecords[0].version.Replace(".", "_")
    Write-Host "Found solution:" $ParentSolutionId "-" $Solutions.CrmRecords[0].friendlyname  "-" $Solutions.CrmRecords[0].version
}
Else {
    Throw "Unable to find solution: $Parameters.SolutionUniqueName"
}

# Export the solution
$ExportSolutionFile = $ReturnSolutionName + $(If ($ExportAsManaged) {"_managed"}) + $ReturnSolutionVersion + '.zip'
$Args = @{
    SolutionName                         = $ReturnSolutionName
    conn                                 = $Conn
    SolutionFilePath                     = $OutputPath
    SolutionZipFileName                  = $ExportSolutionFile
    Managed                              = $ExportAsManaged
    ExportEmailTrackingSettings          = $false
    ExportGeneralSettings                = $false
    ExportIsvConfig                      = $false
    ExportMarketingSettings              = $false
    ExportOutlookSynchronizationSettings = $false
    ExportRelationshipRoles              = $false
    ExportSales                          = $false
}

Write-Host "Exporting solution: $ExportSolutionFile"
Write-Verbose "Exporting with parameters:"
Write-Verbose ($Args | Out-String)
Export-CrmSolution @Args
Write-Host "Exporting solution complete: $ExportSolutionFile"

Write-Host "##vso[task.setvariable variable=D365SolutionName;]$ReturnSolutionName"
Write-Host "##vso[task.setvariable variable=D365SolutionVersion;]$ReturnSolutionVersion"
Write-Host "##vso[task.setvariable variable=D365SolutionFilename;]$ExportSolutionFile"