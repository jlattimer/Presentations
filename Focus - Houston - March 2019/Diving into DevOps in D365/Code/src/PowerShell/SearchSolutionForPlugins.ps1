# Determines if any plug-ins are included in the target solution
#
# Output Pipeline Variable: D365SolutionHasPluginAssemblies (boolean to indicate if plugins are present in the solution)
# Output Pipeline Variable: D365SolutionPluginAssemblies (comma delimited list of plug-in assembly names)

$Parameters = @{
    SourceFolder = "$(Agent.BuildDirectory)\Extracted\Unmanaged\PluginAssemblies"
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

$HasPluginAssemblies = $false
$PluginAssemblies = ''

Write-Host "Searching for plug-ins"
if (Test-Path $($Parameters.SourceFolder)) {
    $PluginAssemblies = (Get-ChildItem -recurse -Path $($Parameters.SourceFolder) -File *.dll | select $_.Name) -join ','
    $HasPluginAssemblies = $true
    Write-Host "Found: $PluginAssemblies"
}
Write-Host "Search complete"

If (!$HasPluginAssemblies) {
    Write-Host "No plug-in assemblies found"
}

Write-Host "##vso[task.setvariable variable=D365SolutionHasPluginAssemblies;]$HasPluginAssemblies"
Write-Host "##vso[task.setvariable variable=D365SolutionPluginAssemblies;]$PluginAssemblies"