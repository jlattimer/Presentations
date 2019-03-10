# Commits changes to a git repository
# 
# Prerequisites:
# Ensure Azure DevOps Agent Job Options: Allow scripts to access the OAuth token is checked
# Ensure Project Collection Build Service Repository Permission: Contribute is Allow 

$Parameters = @{
    DevOpsRepoName = 'SolutionXml'
    TargetFolder   = 'Repos'
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

$FullRepoPath = "$(Agent.BuildDirectory)\$($Parameters.TargetFolder)\$($Parameters.DevOpsRepoName)"
Write-Host "FullRepoPath: $FullRepoPath"

cd "$FullRepoPath"

$msg = "Commit from Azure DevOps CI"
git config --global user.email "you@example.com"
git config --global user.name "Azure DevOps CI"

git add *
git commit -a -m $msg

Write-Host "Committing changes to: $($Parameters.DevOpsRepoName)"
git -c http.extraheader="Authorization: bearer $(System.AccessToken)" push origin master
Write-Host "Commit complete"