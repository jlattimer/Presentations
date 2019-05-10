# This script builds the project, unpacks the solution, updates file names and file 
# references, re-packs solutions and then deploys to a D365 CE organization
# task: deploy

$Credentials = @{
    Username = 'username@test.onmicrosoft.com'
    Password = 'password'
    Url      = 'https://test.crm.dynamics.com'
}


$Parameters = @{
    TestOnly                                    = $true # does not imcrement versions or deploy if true
    ControlPath                                 = (Get-Item $PSScriptRoot).Parent.FullName
    SolutionFileName                            = 'solution.zip'
    PublishChange                               = $true
    ActivatePlugins                             = $false
    OverwriteUnManagedCustomizations            = $false
    ImportAsHoldingSolution                     = $false
    SkipDependancyOnProductUpdateCheckOnInstall = $true
}

function GetPcfSolutionPackagerPath {
    $NugetGlobal = & "nuget" locals global-packages -list | Out-String
    $NugetGlobalParts = $NugetGlobal.Split(" ")
    $SolutionPackagerPath = Join-Path -Path $NugetGlobalParts[1].Trim() -ChildPath 'microsoft.powerapps.msbuild.solution'
    $PcfBuildSoltuionPath = Get-ChildItem -Path $SolutionPackagerPath | Where-Object { $_.PSIsContainer } | Sort-Object -Descending CreationTime | Select-Object name, creationtime
    $SolutionPackagerPath = Join-Path -Path $SolutionPackagerPath -ChildPath $PcfBuildSoltuionPath[0].Name
    $SolutionPackagerPath = Join-Path -Path $SolutionPackagerPath -ChildPath 'content\solutionpackager.exe'
    
    return $SolutionPackagerPath
}

Write-Host "Executing with parameters:"
Write-Host ($Parameters | Out-String)

# Find Solution Packager path
Write-Host "Finding Solution Packager path"
$SolutionPackagerPath = GetPcfSolutionPackagerPath
Write-Host "Found Solution Packager path: $SolutionPackagerPath"

# Clean up
Write-Host "Clean up started"
Remove-Item -LiteralPath "$($Parameters.ControlPath)\out\controls\MapView" -Force -Recurse
Remove-Item -LiteralPath "$($Parameters.ControlPath)\obj" -Force -Recurse
Remove-Item -LiteralPath "$($Parameters.ControlPath)\solution\obj" -Force -Recurse
Remove-Item -LiteralPath "$($Parameters.ControlPath)\solution\bin" -Force -Recurse
Write-Host "Clean up complete"

# Update Solution.xml version
$SolutionXmlPath = "$($Parameters.ControlPath)\solution\other\solution.xml"
Write-Host "Reading file: $SolutionXmlPath"
$SolutionXmlFileContent = [xml](Get-Content -Path "$SolutionXmlPath ")
$SolutionVersionNode = $SolutionXmlFileContent.SelectSingleNode('ImportExportXml').SelectSingleNode('SolutionManifest').SelectSingleNode('Version')
$SolutionVersion = [System.Version]::Parse($SolutionVersionNode.InnerXml)

$NewVersionString = "$($SolutionVersion.Major.ToString()).$($SolutionVersion.Minor.ToString()).$($SolutionVersion.Build.ToString()).$(($SolutionVersion.MinorRevision + 1).ToString())"
$SolutionVersionNode.InnerXml = $NewVersionString
Write-Host "Updating Solution.xml file"
if ($Parameters.TestOnly -ne $true) {
    $SolutionXmlFileContent.Save("$SolutionXmlPath")
}
Write-Host "Updated Solution.xml file"

# Update ControlManifestInput.xml
$ManifestPath = "$($Parameters.ControlPath)\MapView\ControlManifest.Input.xml"
Write-Host "Reading file: $ManifestPath"
$ManifestXmlFileContent = [xml](Get-Content -Path "$ManifestPath")
$ManifestControlNode = $ManifestXmlFileContent.SelectSingleNode('manifest').SelectSingleNode('control')
$ManifestVersion = [System.Version]::Parse($ManifestControlNode.Attributes["version"].Value)

$NewVersionString = "$($ManifestVersion.Major.ToString()).$($ManifestVersion.Minor.ToString()).$(($ManifestVersion.Build + 1).ToString())"
$ManifestControlNode.Attributes["version"].Value = $NewVersionString
Write-Host "Updating ControlManifestInput.xml file"
if ($Parameters.TestOnly -ne $true) {
    $ManifestXmlFileContent.Save("$ManifestPath")
}
Write-Host "Updated ControlManifestInput.xml file"

#Create solution (this also builds)
Set-Location "$($Parameters.ControlPath)\solution"
dotnet build

# Extract solution
$ImportPath = "$($Parameters.ControlPath)\solution\bin\Debug"
$ImportFileFullPath = Join-Path -Path "$ImportPath" -ChildPath $Parameters.SolutionFileName
$ExtractPath = Join-Path -Path "$ImportPath" -ChildPath "solution"
Write-Host "Extracting solution: $ImportFileFullPath"
& "$SolutionPackagerPath" /action:extract /zipfile:"$($Parameters.ControlPath)\solution\bin\Debug\$($Parameters.SolutionFileName)" `
    /folder:"$($Parameters.ControlPath)\solution\bin\Debug\solution"
Remove-Item -Path $ImportFileFullPath -Force -Recurse
Write-Host "Extracted solution: $ImportFileFullPath"

# Copy images to sub-folder
Write-Host "Moving & renaming images and fixing CSS file"
New-Item -Path "$ExtractPath\Controls\MapView\images" -ItemType Directory
Copy-Item -Path "..\node_modules\leaflet\dist\images\*.png" -Destination "$ExtractPath\Controls\MapView\images"
# Copy-Item -Path "$ExtractPath\Controls\MapView\*.png" -Destination "$ExtractPath\Controls\MapView\images"
# Remove-Item -Path "$ExtractPath\Controls\MapView\*.png"
Copy-Item -Path "$ExtractPath\Controls\MapView\*.png" -Destination "$ExtractPath\Controls\MapView\images"
Remove-Item -Path "$ExtractPath\Controls\MapView\*.png"

# Update CSS file
$CssFilePath = "$ExtractPath\Controls\MapView\leaflet.css"
Write-Host "Updating CSS file: $CssFilePath"
Get-ChildItem "$ExtractPath\Controls\MapView\images" | 
Foreach-Object {
    $newName = $_.Name.Replace('-', '_');
    (Get-Content $CssFilePath).replace($_.Name, $newName) | Set-Content $CssFilePath
}
Write-Host "Updated CSS file: $CssFilePath"

# Update CSS file #2
$Css2FilePath = "$ExtractPath\Controls\MapView\leaflet-defaulticon-compatibility.webpack.css"
Write-Host "Updating CSS 2 file: $Css2FilePath"
Get-ChildItem "$ExtractPath\Controls\MapView\images" | 
Foreach-Object {
    $newName = $_.Name.Replace('-', '_');
    (Get-Content $Css2FilePath).replace($_.Name, $newName) | Set-Content $Css2FilePath
}
(Get-Content $Css2FilePath).replace('~leaflet/dist/images', 'images') | Set-Content $Css2FilePath
Write-Host "Updated CSS file: $Css2FilePath"

# Update JS file
$JsFilePath = "$ExtractPath\Controls\MapView\leaflet.js"
Write-Host "Updating JS file: $JsFilePath"
Get-ChildItem "$ExtractPath\Controls\MapView\images" | 
Foreach-Object {
    $newName = $_.Name.Replace('-', '_');
    $nameWithSlash = $_.Name.Replace(".", "\.")
    $newNameWithSlash = $nameWithSlash.Replace('-', '_');
    (Get-Content $JsFilePath).replace($_.Name, $newName).replace($nameWithSlash, $newNameWithSlash) | Set-Content $JsFilePath
}
Write-Host "Updated JS file: $JsFilePath"

# Fix image names
Get-ChildItem "$ExtractPath\Controls\MapView\images" | 
Foreach-Object {
    $newName = $_.Name.Replace('-', '_');
    Rename-Item -Path "$ExtractPath\Controls\MapView\images\$_" -NewName "$ExtractPath\Controls\MapView\images\$newName"
}
Write-Host "Move & rename images complete"

# # Update [Content_Types].xml - Add missing type 
# $SolutionContentTypesPath = "$ExtractPath\[Content_Types].xml"
# Write-Host "Reading file: $SolutionContentTypesPath"
# $SolutionContentTypesFileContent = [xml](Get-Content -LiteralPath "$SolutionContentTypesPath")
# $SolutionContentTypesTypesNode = $SolutionContentTypesFileContent.LastChild
# $child = $SolutionContentTypesFileContent.CreateElement("Default", "http://schemas.openxmlformats.org/package/2006/content-types")
# $child.SetAttribute('ContentType', 'application/octet-stream')
# $child.SetAttribute('Extension', 'png')
# $child.GetAttributeNode("path")
# $SolutionContentTypesTypesNode.InsertAfter($child, $SolutionContentTypesTypesNode.FirstChild)
# Write-Host "Updating [Content_Types].xml file: $SolutionContentTypesPath"
# $SolutionContentTypesFileContent.Save("$SolutionContentTypesPath")
# Write-Host "Updated [Content_Types].xml file: $SolutionContentTypesPath"

# Update ControlManifestInput.xml
$SolutionManifestPath = "$ExtractPath\Controls\MapView\ControlManifest.xml"
Write-Host "Reading file: $SolutionManifestPath"
$SolutionManifestFileContent = [xml](Get-Content -Path "$SolutionManifestPath" -Encoding UTF8)
# $SolutionManifestFileContent.SelectSingleNode('manifest').SelectSingleNode('control').SelectSingleNode('resources').SelectNodes('library') |
# ForEach-Object {
#     $libraryNode = [System.Xml.XmlNode]$_
#     $libraryNode.SelectNodes('packaged_library') |
#     ForEach-Object {
#         $fileNode = [System.Xml.XmlNode]$_
#         $pathValue = $fileNode.GetAttributeNode('path')
#         if ($pathValue.Value.EndsWith('png')) {
#             $newName = $pathValue.Value.Replace('-', '_')
#             $fileNode.SetAttribute('path', "images/$newName")
#         }
#     }
# }
$SolutionManifestResourcesNode = $SolutionManifestFileContent.SelectSingleNode('manifest').SelectSingleNode('control').SelectSingleNode('resources')
$SolutionManifestResourcesNode.SelectNodes('img') | 
ForEach-Object {
    if ($_.GetAttributeNode('path').Value -eq 'lat_preview.png') {
        $_.ParentNode.RemoveChild($_)
    }
}

Get-ChildItem "$ExtractPath\Controls\MapView\images" | 
Foreach-Object {
    $child = $SolutionManifestFileContent.CreateElement("img")
    $child.SetAttribute("path", "images/$_");
    $SolutionManifestResourcesNode.AppendChild($child)
}

Write-Host "Updating ControlManifestInput.xml file: $SolutionManifestPath"
$SolutionManifestFileContent.Save("$SolutionManifestPath")
Write-Host "Updated ControlManifestInput.xml file: $SolutionManifestPath"

# Re-compress solution
Write-Host "Re-compressing solution: $ExtractPath"
& "$SolutionPackagerPath" /action:pack /zipfile:"$($Parameters.ControlPath)\solution\bin\Debug\$($Parameters.SolutionFileName)" `
    /folder:"$($Parameters.ControlPath)\solution\bin\Debug\solution"
Remove-Item -Path $ExtractPath -Force -Recurse
Write-Host "Re-compressed solution: $ExtractPath"

# Connect to D365 CE
$User = $Credentials.Username
$PWord = $Credentials.Password | ConvertTo-SecureString -AsPlainText -Force
$Url = $Credentials.Url

$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
$Conn = Connect-CrmOnline -Credential $Cred -ServerUrl $Url

If ($Conn.IsReady -eq $false) {
    Throw "Error connecting to CRM"
}

# Import solution
$Args = @{
    conn                                        = $Conn
    SolutionFilePath                            = $ImportFileFullPath
    PublishChanges                              = $Parameters.PublishChange
    ActivatePlugIns                             = $Parameters.ActivatePlugins
    OverwriteUnManagedCustomizations            = $Parameters.OverwriteUnManagedCustomizations
    ImportAsHoldingSolution                     = $Parameters.ImportAsHoldingSolution
    SkipDependancyOnProductUpdateCheckOnInstall = $Parameters.SkipDependancyOnProductUpdateCheckOnInstall
}

Write-Host "Importing solution: $ImportFileFullPath"
Write-Verbose "Importing with parameters:"
Write-Verbose ($Args | Out-String)
if ($Parameters.TestOnly -ne $true) {
    Import-CrmSolution @Args
}
Write-Host "Importing solution complete: $ImportFileFullPath"