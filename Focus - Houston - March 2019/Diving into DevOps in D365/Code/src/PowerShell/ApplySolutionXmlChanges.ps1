# Copies extracted solution xml to a git repository folder with the same solution name
#
# Prerequisites:
# Clone BuildTools repository
# Dependencies:
# PowerShell\SyncFolder.ps1

$Parameters = @{
    SourceFolder = "$(Agent.BuildDirectory)\Extracted\Unmanaged"
    TargetFolder = "$(Agent.BuildDirectory)\Repos\SolutionXml\"
    SolutionName = "$(D365SolutionName)"
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

$TargetSolutionFolder = $($Parameters.TargetFolder) + $($Parameters.SolutionName)
Write-Host ("TargetSolutionFolder: $TargetSolutionFolder")

Write-Host "Syncing $($Parameters.SourceFolder) to $TargetSolutionFolder"
& "$(Agent.BuildDirectory)\BuildTools\PowerShell\SyncFolder.ps1" -SourceFolder "$($Parameters.SourceFolder)" -TargetFolders "$TargetSolutionFolder"
Write-Host "Sync complete"