# Extract customization xml from a solution zip file
# 
# https://docs.microsoft.com/en-us/dynamics365/customer-engagement/developer/compress-extract-solution-file-solutionpackager
#
# Prerequisites:
# Clone BuildTools repository

$Parameters = @{
    SolutionPackagerPath      = "$(Agent.BuildDirectory)\BuildTools\SDK\SolutionPackager\SolutionPackager.exe"
    SolutionFilePath          = "$(Agent.BuildDirectory)\DownloadedSolutions\"
    SolutionFilename          = "$(D365SolutionFilename)"
    IsManaged                 = $false
    OutputPath                = "$(Agent.BuildDirectory)\Extracted\Unmanaged"
    MappingFilePath           = ""
    TreatPackWarningsAsErrors = $false
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

# Extract solution file
$PackageType = If ($Parameters.IsManaged) {'Managed'} Else {'Unmanaged'}
Write-Host "PackageType: $PackageType"

$SolutionFullPath = "$($Parameters.SolutionFilePath)$($Parameters.SolutionFilename)"
Write-Host "SolutionFullPath: $SolutionFullPath"

$Map = If (![string]::IsNullOrEmpty($Parameters.MappingFilePath)) {"/map:'$($Parameters.MappingFilePath)'"}
Write-Host "Map: $Map"

Write-Host "Extracting solution file: $SolutionFullPath"
$ExtractOuput = & "$($Parameters.SolutionPackagerPath)" /action:Extract /zipfile:"$SolutionFullPath" /folder:"$($Parameters.OutputPath)" `
    /packagetype:$PackageType /errorlevel:Info /allowWrite:Yes /allowDelete:Yes $Map
Write-Host $ExtractOuput

# Check for errors
If ($LastExitCode -ne 0) {
    Throw "Solution Extract operation failed with exit code: $LastExitCode"
}
Else {
    If (($null -ne $ExtractOuput) -and ($ExtractOuput -like "*warnings encountered*")) {
        If ($Parameters.TreatPackWarningsAsErrors) {
            Throw "Solution Packager encountered warnings. Check the output"
        }
        Else {
            Write-Warning "Solution Packager encountered warnings. Check the output"
        }
    }
    Else {
        Write-Host "Solution Extract completed successfully"
    }
}
Write-Host "Extraction complete"