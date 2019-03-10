# Replaces plug-ins in extracted solution xml with debug/release built versions

$Parameters = @{
    SourceFolder = "$(Agent.BuildDirectory)\Repos\Plugins"
    XmlFolder    = "$(Agent.BuildDirectory)\Extracted\Unmanaged\PluginAssemblies"
    AssemblyList = "$(D365SolutionPluginAssemblies)"
    BuildConfig  = 'release'
}
Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

$Assemblies = $($Parameters.AssemblyList).Split(',')

# Find bin\debug|release folders in solution
Write-Host "Searching for plug-in folders"
$AssemblyFolders = (Get-ChildItem $($Parameters.SourceFolder) -Recurse | Where-Object `
    { $_.PSIsContainer -and $_.FullName.EndsWith("bin\$($Parameters.BuildConfig)", 'CurrentCultureIgnoreCase')}) | select Fullname
Write-Host "Search complete"

# Search folders for matching assembly
Write-Host "Processing solution assemblies"
ForEach ($file in $Assemblies) {
    Write-Host "  Lookng for file: $file"
    $Found = $false

    ForEach ($folder in $AssemblyFolders) {
        Write-Host "    Searching folder: $($folder.Fullname)"

        # Skip test projects
        If (Test-Path "$($folder.Fullname)\Microsoft.VisualStudio.TestPlatform.TestFramework.dll" -PathType Leaf) {
            Write-Host '    Skipping test folder'
            continue
        }

        # Search for matching assembly with periods removed (like in solution xml)
        $AssemblyPath = Get-ChildItem -Path "$($folder.Fullname)" | Where-Object { $_.Name.Replace('.', '') -eq $file.Replace('.', '') } `
            | select Fullname -ExpandProperty FullName

        If ($AssemblyPath) {
            Write-Host "    Found: $AssemblyPath"
            $Found = $true       

            # Find matching assembly in extracted solution xml
            $XmlPluginAssembly = Get-ChildItem -recurse -Path $($Parameters.XmlFolder) -File $file | select Fullname -ExpandProperty FullName
            Write-Host "    XmlPluginAssembly: $XmlPluginAssembly"

            # Copy assembly to extracted solution xml
            Write-Host "    Copying $AssemblyPath to $XmlPluginAssembly"
            Copy-Item -Path $AssemblyPath -Destination $XmlPluginAssembly
            Write-Host "    Copy complete"
            break
        }
    }

    if (!$Found) {
        Write-Error "Unable to find assembly: $file"
    }
}
Write-Host "Processing complete"