<#
System requirements
PSVersion                      5.1.19041.2364
PSEdition                      Desktop
PSCompatibleVersions           1.0, 2.0, 3.0, 4.0
BuildVersion                   10.0.19041.2364
CLRVersion                     4.0.30319.42000
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1

About Script : 
Author : Fardin Barashi
Title : Check Logins in Server
Description : A quick script to get all eventid 4624 in log 'Security'
https://learn.microsoft.com/en-us/windows/win32/wes/eventschema-elements

Version : 1.0
Release day : 2025-07-07
Github Link  : https://github.com/fardinbarashi
News :
 
#>

#----------------------------------- Settings ------------------------------------------
# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force

# Path
$CsvPath = "$PSScriptRoot\Files\Report\Csv\logon events OnServer; $($env:COMPUTERNAME) $($LogFileDate).csv" 
$DateFilter = (Get-Date).AddDays(-35)

Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# Error-Settings
$ErrorActionPreference = 'Continue'
#----------------------------------- Start Script ------------------------------------------
# Section 1 : Get EventsID from Server
$Section = "Section 1 : Get EventsID from Server"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 $XPath = "Event[System[EventID=4624]] and Event[EventData[Data[@Name='TargetDomainName'] != 'Window Manager']] and Event[EventData[Data[@Name='TargetDomainName'] != 'NT AUTHORITY']] and (Event[EventData[Data[@Name='LogonType'] = '2']] or Event[EventData[Data[@Name='LogonType'] = '11']])"
 Write-Host ""

 # Get Win-Events from Log Security with the id 4624, use $datefilter as starttime
 $events = Get-WinEvent -FilterHashTable @{
 LogName = 'Security'
 ID = 4624
 StartTime = $DateFilter
} -MaxEvents 100000 -ErrorAction SilentlyContinue

$result = @(
    foreach ($event in $events) { # Start foreach ($event in $events)
        [xml]$xml = $event.ToXml()
        $attrsht = [ordered]@{ # Start $attrsht = [ordered]@{
            TimeCreated        = $xml.event.system.TimeCreated.SystemTime
            EventId            = $xml.event.system.EventID
            SubjectDomainName  = $xml.event.EventData.Data[2].'#text'
            TargetUserName     = $xml.event.EventData.Data[5].'#text'
            LogonType          = $xml.event.EventData.Data[8].'#text'
            LogonProcessName   = $xml.event.EventData.Data[9].'#text'
            IpAddress          = $xml.event.EventData.Data[18].'#text'
        }  # End $attrsht = [ordered]@{
        New-Object -TypeName PSObject -Property $attrsht }) # End foreach ($event in $events)

# Export as Csv
$result | Export-Csv $CsvPath -NoClobber -NoTypeInformation -Delimiter ";" -Force -Verbose
Write-Host $Section... "100%" -ForegroundColor Green
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

#----------------------------------- End Script ------------------------------------------
Stop-Transcript