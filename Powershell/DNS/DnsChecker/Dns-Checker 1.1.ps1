<#
System requirements
PSVersion                      5.1.19041.2364                                                                                                       
PSEdition                      Desktop                                                                                                              
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}                                                                                              
BuildVersion                   10.0.19041.2364                                                                                                      
CLRVersion                     4.0.30319.42000                                                                                                      
WSManStackVersion              3.0                                                                                                                  
PSRemotingProtocolVersion      2.3                                                                                                                  
SerializationVersion           1.1.0.1      

About Script 
Author : Fardin Barashi
Title : DNS-Checker 
Description : DNS-Checker is a quick way to remove dns instead for using DNS-Manager that comes with OS
Version : 1.1
Release day : 2023-02-22
Github Link  : https://github.com/fardinbarashi
News : 2023-03-01 : Tombstone on the Wins
#>

#----------------------------------- Settings ------------------------------------------
# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt" 
Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-OutPut ".. Starting TranScript"


#----------------------------------- Start Script ------------------------------------------
# Section 1 : Query user for what server to get dns-entries in Zone $($Zonename)
$Section = "Section 1 : Query user for what server to get dns-entries in Zone $($Zonename)"

Try
 { # Start Try, $Section
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Output "Start $Section"
  Write-Output ""

  # Run Query
  Write-Output "Zonenames in the DNS"
  Get-DnsServerZone | Select-Object ZoneName | FL

  Write-Output $GetZonenames

  $Zonename = Read-Host "Select Your Zonename"
  # Check if String $Zonename is empty
  If([string]::IsNullOrEmpty($Zonename))
      { # Start If([string]::IsNullOrEmpty($Zonename))
       Write-Output "String Zonename is empty in the string, add a zone in the script"
      } # End If([string]::IsNullOrEmpty($Zonename))
     Else 
      { # Start Else([string]::IsNullOrEmpty($Zonename))
        # Ask User what Server to check for in the DNS
        $Query = Read-Host "Which server do you want to search after in the dns"
          If([string]::IsNullOrEmpty($Query))
           { # Start If([string]::IsNullOrEmpty($Query))
            Write-Output "You did not enter anything. Please try again."
            Write-Output "Stopping script."
            Stop-Transcript
            Exit
           }  # End If([string]::IsNullOrEmpty($Query))
          Else
           { # Start Else, If([string]::IsNullOrEmpty($Query))
            Get-Date -Format "yyyy/MM/dd HH:mm:ss"
            Write-Output "Searching dns record for $($Query) in $($Zonename)"
            $GetDnsRecords = Get-DnsServerResourceRecord -ZoneName $Zonename -Name $Query -Verbose
            If ($GetDnsRecords -Eq $Null)
             { # Start If ($GetDnsRecords -Eq $Null)
              Write-Output "No DNS-Entries have been found for$($Query) in $($Zonename)"
              Write-Output "Stopping script."
              Stop-Transcript
              Exit
             } # End If ($GetDnsRecords -Eq $Null)
            Else 
             { # Start Else, If($GetDnsRecords -Eq $Null)
              Get-Date -Format "yyyy/MM/dd HH:mm:ss"
              Get-DnsServerResourceRecord -ZoneName $Zonename -Name $Query 
              Get-DnsServerResourceRecord -ZoneName $Zonename -Name $Query | Remove-DnsServerResourceRecord -ZoneName $Zonename -Name $Query -Verbose      
              Write-Output "Open CMD and do a tombstone in wins"
              Start-Process -FilePath "C:\Windows\System32\cmd.exe" -Verb RunAs -ArgumentList "/k", "echo netsh wins set name $Query tombstone"           
             } # End Else, If($GetDnsRecords -Eq $Null)           
           }  # End Else, If([string]::IsNullOrEmpty($Query))         


      } # End Else([string]::IsNullOrEmpty($Zonename))
 } # End Try, $Section
Catch
 { # Start Catch, $Section
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host "ERROR on $Section" -ForegroundColor Red
  Write-Warning $Error[0]
  Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
  Stop-Transcript
  Exit 
 } # End Catch, $Section

#----------------------------------- End Script ------------------------------------------
Stop-Transcript