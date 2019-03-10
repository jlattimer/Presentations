# Pack extracted customization xml into a solution zip file
# 
# https://docs.microsoft.com/en-us/dynamics365/customer-engagement/developer/compress-extract-solution-file-solutionpackager
#
# Prerequisites:
# Clone BuildTools repository

$Parameters = @{
    SolutionPackagerPath      = "$(Agent.BuildDirectory)\BuildTools\SDK\SolutionPackager\SolutionPackager.exe"
    SolutionName              = "$(D365SolutionFilename)"
    SourcePath                = "$(Agent.BuildDirectory)\Extracted\Unmanaged"
    OutputPath                = "$(Agent.BuildDirectory)\Packed\Unmanaged"
    IsManaged                 = $false
    MappingFilePath           = ""
    TreatPackWarningsAsErrors = $false
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

# Pack solution file
$PackageType = If ($Parameters.IsManaged) {'Managed'} Else {'Unmanaged'}
Write-Host "PackageType: $PackageType"

$SolutionFullPath = "$($Parameters.OutputPath)\$($Parameters.SolutionName)"
Write-Host "SolutionFullPath: $SolutionFullPath"

$Map = If (![string]::IsNullOrEmpty($Parameters.MappingFilePath)) {"/map:'$($Parameters.MappingFilePath)'"}
Write-Host "Map: $Map"

Write-Host "Packing solution file: $SolutionFullPath"
$PackOuput = & "$($Parameters.SolutionPackagerPath)" /action:Pack /zipfile:"$SolutionFullPath" /folder:"$($Parameters.SourcePath)" `
    /packagetype:$PackageType /errorlevel:Info $Map
Write-Host $PackOuput

# Check for errors
If ($LastExitCode -ne 0) {
    Throw "Solution Pack operation failed with exit code: $LastExitCode"
}
Else {
    If (($null -ne $PackOuput) -and ($PackOuput -like "*warnings encountered*")) {
        If ($Parameters.TreatPackWarningsAsErrors) {
            Throw "Solution Packager encountered warnings. Check the output"
        }
        Else {
            Write-Warning "Solution Packager encountered warnings. Check the output"
        }
    }
    Else {
        Write-Host "Solution Pack completed successfully"
    }
}
Write-Host "Pack complete"