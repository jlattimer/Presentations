# Logs Azure DevOps build time to Application Insights

$AiKey = $(AppInsightsKey)

$startBuild = Get-Date -Date "$Env:System_PipelineStartTime"
Write-Host "Start time: $startBuild"

$endBuild = Get-Date
Write-Host "End time: $endBuild"

$ts = New-TimeSpan -Start $startBuild -End $endBuild
$tm = [math]::Round($ts.TotalMinutes, 2)
Write-Host "Build time (min): $tm"

# $(AppInsightsKey) should be your Application Insights Instrumentation Key
if (-Not ('$(AppInsightsKey)' -match("^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$")))
{
    Write-Host "Invalid Application Insights Instrumentation Key"
    exit 1
}
else 
{
    $date = $endBuild.ToUniversalTime()
    $json =
    '{
        "data": {
          "baseData": {
            "metrics": [
              {
                   "name": "Build Time: $(Build.DefinitionName)",
                   "kind": 0,
                   "value": ' + $tm + '
              }
            ],
            "properties": {
                "source": "Azure DevOps",
                "buildNumber": $(Build.BuildNumber),
                "jobStatus": "$(Agent.JobStatus)"
            }
          },
          "baseType": "MetricData"
        },
       "iKey": "' + $AiKey + '",
       "name": "Microsoft.ApplicationInsights.' + $AiKey + '.Metric",
        "time": "' + $date + '"
      }'

    $response = Invoke-RestMethod 'https://dc.services.visualstudio.com/v2/track' -Method POST -Body $json -ContentType 'application/json'
    
    if ($response.itemsAccepted -eq 1)
    {
        Write-Host 'Logged build time to Application Insights'
    }
    else
    {
        Write-Host 'Failed logging build time to Application Insights'
        exit 1
    }
}