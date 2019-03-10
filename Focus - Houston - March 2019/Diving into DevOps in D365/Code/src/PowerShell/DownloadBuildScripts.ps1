# Download PowerShell scripts from an existing Git repo and write to agent file system 
# under "$(Build.SourcesDirectory)/BuildScripts"

# Ensure Build Agent Job Allow scripts to access the OAuth token is checked

$Parameters = @{
    AzureDevOpsInstanceName = 'jlattimer'
    AzureDevOpsProjectName  = 'AATEST'
    Repo                    = 'TestBuildScripts'
    RepoPath                = 'prod/test.ps1'
    RepoBranch              = 'master'
}
Write-Verbose 'Executing with parameters:'
Write-Verbose ($Parameters | Out-String)

# Download file content
$AuthHeader = @{ Authorization = "Bearer $(System.AccessToken)" };
$Uri = 'https://' + $Parameters.AzureDevOpsInstanceName + '.visualstudio.com/' + $Parameters.AzureDevOpsProjectName + '/_apis/git/repositories/' + 
$Parameters.Repo + '/items?path=' + $Parameters.RepoPath + '&$format=json&includeContent=true&versionDescriptor.version=' + $Parameters.RepoBranch + 
'&versionDescriptor.versionType=branch&api-version=4.1'
Write-Host $Uri

Write-Host 'Downloading file content for:'$Parameters.RepoPath
$File = Invoke-RestMethod -Method Get -ContentType application/json -Uri $Uri -Headers $AuthHeader
Write-Host 'Download complete'

Write-Verbose 'File content:'
Write-Verbose $File.content

# Create folder path
$Path = Split-Path -Path $Parameters.RepoPath
Write-Host 'Path:'$Path
$Filename = Split-Path -Path $Parameters.RepoPath -Leaf
Write-Host '$Filename:'$Filename
$Path = Join-Path -Path "$(Build.SourcesDirectory)/BuildScripts" -ChildPath $Path
Write-Host 'Path:'$Path
New-Item -ItemType Directory -Force -Path $Path

# Create file
$FullPath = Join-Path -Path $Path -ChildPath $Filename
Write-Host 'Writing to file:'$FullPath
Set-Content -Path $FullPath -Value $File.content
Write-Host 'Writing complete'