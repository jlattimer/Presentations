if (!(Get-Module "Microsoft.Xrm.Data.Powershell")) {
    Install-Module -Name Microsoft.Xrm.Data.Powershell -AcceptLicense -AllowClobber -Force -Scope AllUsers
}


$User = "crmadmin@org.onmicrosoft.com"
$PWord =  "password" | ConvertTo-SecureString -AsPlainText -Force
$Url = "https://org.crm.dynamics.com"

Write-Verbose "Executing with no parameters"

$Cred = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $User, $PWord
$Conn = Connect-CrmOnline -Credential $Cred -ServerUrl $Url

Write-Host "Publishing all customizations"
Publish-CrmAllCustomization -conn $Conn
Write-Host "Publishing all customizations complete"