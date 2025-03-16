<#
 Beskrivning : 
   Skriptet exporterar på databas-tabellen [dbo].[Servers] till en csv fil.
   Tabellen finns i databasen Ateam.
   Tabellens kolumner som exporteras är 
    ID
    Servername
    ServerFQDN
    Ipadress
    ServiceName
#>
Start-Transcript -Path "$PSScriptRoot\Logs\TranscriptCheckServicesLog.txt"
cls
$Serverlistcsv = "$PSScriptRoot\Data\Out\ServerListCsv\Serverlist.csv"
$SaveServiceStatusCsvFile = "$PSScriptRoot\Data\In\ServiceCheck\Healthservice\HealthService.csv"
# Import Serverlist.csv Start
Try
 { # Start Try, Get Services from $Serverlistcsv
  $ImportServerListCsvFile = Import-Csv $Serverlistcsv -Delimiter ',' -Encoding UTF8 | 
  # "id","Servername","ServerFQDN","Ipadress","ServiceName" 
   ForEach { # Start Foreach
    New-Object PsObject -Prop @{# Start New Object 
          id = $_.id;
          Servername = $_.Servername;
          ServerFQDN = $_.ServerFQDN;
          Ipadress = $_.Ipadress;
          ServiceName = $_.ServiceName;
         }#End New Object
     } # End Foreach
 
 # Check if $SaveServiceStatus is True, if True, Delete file then run Foreach, otherwise run Foreach
 $FileCheckSaveServiceStatus = Test-Path -Path $SaveServiceStatusCsvFile -PathType Leaf
 If ( $FileCheckSaveServiceStatus -Eq $True ) 
  { # Start If
   $RemoveSaveServiceStatusCsvFile = Remove-Item -Path $SaveServiceStatusCsvFile -Force
   # Save Service in $SaveServiceStatusCsvFile 
   Foreach ( $Server in $ImportServerListCsvFile )
    { # Start Foreach 
      Invoke-Command -ScriptBlock { Get-Service $args[0];} -ComputerName $Server.ServerFQDN -ArgumentList $Server.ServiceName.Split(",") | Select-Object PSComputerName, ServiceName, Status | Export-Csv $SaveServiceStatusCsvFile -Force -NoTypeInformation -Append
    } # End Foreach 
  } # End If
 
 Else
  { # Start Else
   # Save Service in $SaveServiceStatusCsvFile 
   Foreach ( $Server in $ImportServerListCsvFile )
    { # Start Foreach 
      Invoke-Command -ScriptBlock { Get-Service $args[0];} -ComputerName $Server.ServerFQDN -ArgumentList $Server.ServiceName.Split(",") | Select-Object PSComputerName, ServiceName, Status | Export-Csv $SaveServiceStatusCsvFile -Force -NoTypeInformation -Append
    } # End Foreach 
  } # End Else
 } # End Try, Get Services from Servers

 Catch
 { # Start Catch
 Write-host "Could not get services from servers, Check on $Serverlistcsv"
 } # End Catch



