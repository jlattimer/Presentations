# Finds the name of the published solution file artifact
#
# Output Pipeline Variable: D365SolutionFileName (soution zip file name)

$Parameters = @{
    ArtifactFolder = "$(System.DefaultWorkingDirectory)/_test/solution/"
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

# Location zip file
$SolutionFile = (Get-ChildItem -Path $($Parameters.ArtifactFolder) | Where-Object { $_.Extension -eq '.zip' }) | Select-Object Name -ExpandProperty Name

Write-Host "SolutionFile: $SolutionFile"

Write-Host "##vso[task.setvariable variable=D365SolutionFileName;]$SolutionFile"