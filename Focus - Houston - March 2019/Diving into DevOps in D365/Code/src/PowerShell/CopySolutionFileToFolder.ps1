# Copies a solution zip file to a git repository folder with the same name

$Parameters = @{
    DevOpsRepoName   = 'SolutionZip'
    TargetFolder     = 'Repos'
    SolutionFullPath = "$(Agent.BuildDirectory)\DownloadedSolutions\$(D365SolutionFilename)"
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

$FullRepoPath = "$(Agent.BuildDirectory)\$($Parameters.TargetFolder)\$($Parameters.DevOpsRepoName)"
Write-Host "FullRepoPath: $FullRepoPath"

$FileName = [System.IO.Path]::GetFileNameWithoutExtension($($Parameters.SolutionFullPath))
Write-Host "FileName: $FileName"

$SolutionFolderName = $FileName.Split('_')[0]
Write-Host "SolutionFolderName: $SolutionFolderName"

$FullRepoPath = "$FullRepoPath\$SolutionFolderName"
Write-Host "FullRepoPath: $FullRepoPath"

New-Item -ItemType Directory -Force -Path "$FullRepoPath"

Write-Host "Copying $($Parameters.SolutionFullPath) to $FullRepoPath"
Copy-Item -Path $($Parameters.SolutionFullPath) -Destination $FullRepoPath
Write-Host "Copy complete"