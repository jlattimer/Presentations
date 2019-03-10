# Determines if any JavaScript files are included in the target solution
#
# Output Pipeline Variable: D365SolutionHasJavaScriptFiles (boolean to indicate if JavaScript is present in the solution)
# Output Pipeline Variable: D365SolutionJavaScriptFiles (comma delimited list of JavaScript file names)

$Parameters = @{
    SourceFolder = "$(Agent.BuildDirectory)\Extracted\Unmanaged\WebResources"
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

$HasJavaScriptFiles = $false
$JavaScriptFiles = ''

Write-Host "Searching for JavaScript"
if (Test-Path $($Parameters.SourceFolder)) {
    $JavaScriptFiles = (Get-ChildItem -recurse -Path $($Parameters.SourceFolder) -File *.js | select $_.Name) -join ','
    $HasJavaScriptFiles = $true
    Write-Host "Found: $JavaScriptFiles"
}
Write-Host "Search complete"

If (!$HasJavaScriptFiles) {
    Write-Host "No JavaScript files found"
}

Write-Host "##vso[task.setvariable variable=D365SolutionHasJavaScriptFiles;]$HasJavaScriptFiles"
Write-Host "##vso[task.setvariable variable=D365SolutionJavaScriptFiles;]$JavaScriptFiles"