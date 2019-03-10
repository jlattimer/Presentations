# Clones an Azure DevOps git repository
# 
# Prerequisites:
# Ensure Azure DevOps Agent Job Options: Allow scripts to access the OAuth token is checked

$Parameters = @{
    DevOpsAccountName = 'jlattimer'
    DevOpsProjectName = 'ALMTest'
    DevOpsRepoName    = 'Plugins'
    TargetFolder      = "Repos"
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

$CloneToFolder = "$($Parameters.TargetFolder)\$($Parameters.DevOpsRepoName)"
New-Item -ItemType Directory -Force -Path $CloneToFolder
Write-Host "Created folder: $CloneToFolder"

Write-Host "Cloning repo: $($Parameters.DevOpsRepoName)"
git clone https://vsts:$(System.AccessToken)@$($Parameters.DevOpsAccountName).visualstudio.com/$($Parameters.DevOpsProjectName)/_git/$($Parameters.DevOpsRepoName) $CloneToFolder
Write-Host "Clone complete"