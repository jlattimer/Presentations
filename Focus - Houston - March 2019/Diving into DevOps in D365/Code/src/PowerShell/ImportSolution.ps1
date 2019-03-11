# Import a solution
#
# https://docs.microsoft.com/en-us/dynamics365/customer-engagement/customize/import-update-export-solutions#export-solutions

#$Credentials = @{
#    Username = "crmadmin@org.onmicrosoft.com"
#    Password = "password"
#    Url = "https://org.crm.dynamics.com"
#}

$Credentials = @{
    Username = "$(CrmTestUsername)"
    Password = "$(CrmTestPassword)"
    Url      = "$(CrmTestUrl)"
}

$Parameters = @{
    ImportFileName                              = "test_1_0_0_0.zip"
    ImportPath                                  = "$(System.DefaultWorkingDirectory)/_test/solution/"
    PublishChange                               = $true
    ActivatePlugins                             = $true
    OverwriteUnManagedCustomizations            = $false
    ImportAsHoldingSolution                     = $false
    SkipDependancyOnProductUpdateCheckOnInstall = $false
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

# Import solution
$ImportFileFullPath = Join-Path -Path $Parameters.ImportPath -ChildPath $Parameters.ImportFileName
$Args = @{
    conn                                        = $Conn
    SolutionFilePath                            = $ImportFileFullPath
    PublishChanges                              = $Parameters.PublishChange
    ActivatePlugIns                             = $Parameters.ActivatePlugins
    OverwriteUnManagedCustomizations            = $Parameters.OverwriteUnManagedCustomizations
    ImportAsHoldingSolution                     = $Parameters.ImportAsHoldingSolution
    SkipDependancyOnProductUpdateCheckOnInstall = $Parameters.SkipDependancyOnProductUpdateCheckOnInstall
}

Write-Host "Importing solution: $ImportFileFullPath"
Write-Verbose "Importing with parameters:"
Write-Verbose ($Args | Out-String)
Import-CrmSolution @Args
Write-Host "Importing solution complete: $ImportFileFullPath"