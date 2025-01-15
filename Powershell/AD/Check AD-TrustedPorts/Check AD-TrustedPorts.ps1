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
Title : AD - Trusted Ports
Description : Check if AD-Trusted ports are open
https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/config-firewall-for-ad-domains-and-trusts
Version : 1.0
Release day : 2025-01-15
Github Link  : https://github.com/fardinbarashi
News :
 
#>

#----------------------------------- Settings ------------------------------------------
# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# List of ports to check
$Ports = @(
    @{Port=123; Protocol="UDP"; Service="W32Time"},
    @{Port=135; Protocol="TCP"; Service="RPC Endpoint Mapper"},
    @{Port=464; Protocol="TCP/UDP"; Service="Kerberos Password Change"},
    @{Port=389; Protocol="TCP/UDP"; Service="LDAP"},
    @{Port=636; Protocol="TCP"; Service="LDAP SSL"},
    @{Port=3268; Protocol="TCP"; Service="LDAP GC"},
    @{Port=3269; Protocol="TCP"; Service="LDAP GC SSL"},
    @{Port=53; Protocol="TCP/UDP"; Service="DNS"},
    @{Port=88; Protocol="TCP/UDP"; Service="Kerberos"},
    @{Port=445; Protocol="TCP"; Service="SMB"}
)

# Range of dynamic ports
$DynamicPorts = 49152..65535

# Error-Settings
$ErrorActionPreference = 'Continue'
#----------------------------------- Start Script ------------------------------------------
# Section 1 : Start check if ports are open
$Section = "Section 1 : Start check if ports are open"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 # Server to test (use the local server as default)
 $Server = Read-Host "Enter the server name or IP (default: localhost)" 
 if (-not $Server) { $Server = "localhost" }

 # Function to test ports
 function Test-Port { # Start function Test-Port 
    param (
        [string]$Server,
        [int]$Port,
        [string]$Protocol
    )

  try 
    { # Start Try
        if ($Protocol -eq "UDP") 
        { # Start If ($Protocol -eq "UDP") 
          $result = Test-NetConnection -ComputerName $Server -Port $Port -InformationLevel Detailed -WarningAction SilentlyContinue -CommonTCPPort None
           if ($result.TcpTestSucceeded -or $result.UdpTestSucceeded) 
            { # Start if ($result.TcpTestSucceeded -or $result.UdpTestSucceeded) 
              return "Open"
            } # End if ($result.TcpTestSucceeded -or $result.UdpTestSucceeded) 
           else 
            { # Start Else ($result.TcpTestSucceeded -or $result.UdpTestSucceeded) 
              return "Closed"
            } # End Else ($result.TcpTestSucceeded -or $result.UdpTestSucceeded) 
        } # End If ($Protocol -eq "UDP")

        elseif ($Protocol -eq "TCP") 
        { # Start elseif ($Protocol -eq "TCP")
          $result = Test-NetConnection -ComputerName $Server -Port $Port -WarningAction SilentlyContinue
           if ($result.TcpTestSucceeded) 
            { # Start if ($result.TcpTestSucceeded)
                return "Open"
            } # End if ($result.TcpTestSucceeded)
           else 
            { # Start Else ($result.TcpTestSucceeded)
                return "Closed"
            } # End Else ($result.TcpTestSucceeded)
        } # End elseif ($Protocol -eq "TCP") 
        
        else 
        { # Start else
            return "Unsupported Protocol"
        } # End else
    } # End Try
    
  catch 
   { # Start catch
    Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    Write-Host "ERROR on $Section" -ForegroundColor Red
    Write-Warning $Error[0]
    } # end catch
 } # End # Start function Test-Port 
 Write-Host ""

 # Results array
$Results = @()

# Test fixed ports
foreach ($PortInfo in $Ports) 
 { # Start foreach ($PortInfo in $Ports) 
    $Port = $PortInfo.Port
    $Protocol = $PortInfo.Protocol
    $Service = $PortInfo.Service

    $Status = Test-Port -Server $Server -Port $Port -Protocol $Protocol
    $Results += [PSCustomObject]@{ # Start $Results += [PSCustomObject]@
        Port     = $Port
        Protocol = $Protocol
        Service  = $Service
        Status   = $Status
   } # End $Results += [PSCustomObject]@
} # end foreach ($PortInfo in $Ports) 

# Test dynamic port range for TCP/UDP
foreach ($Port in $DynamicPorts) { # Start foreach ($Port in $DynamicPorts)
    $TCPStatus = Test-Port -Server $Server -Port $Port -Protocol "TCP"
    $UDPStatus = Test-Port -Server $Server -Port $Port -Protocol "UDP"

    if ($TCPStatus -eq "Open" -or $UDPStatus -eq "Open") { # Start if ($TCPStatus -eq "Open" -or $UDPStatus -eq "Open")
        $Results += [PSCustomObject]@{ # Start $Results += [PSCustomObject]@
            Port     = $Port
            Protocol = "TCP/UDP"
            Service  = "Dynamic Port"
            Status   = "Open"
        }  # End $Results += [PSCustomObject]@
    } # End if ($TCPStatus -eq "Open" -or $UDPStatus -eq "Open")
} # End foreach ($Port in $DynamicPorts)

# Output results
$Results | Format-Table -AutoSize

# Export to CSV
$Results | Export-Csv -Path "$PSScriptRoot\PortTestResults.csv" -NoTypeInformation -Force -Encoding UTF8

Write-Host "Port test completed. Results saved to PortTestResults.csv in the current directory." -ForegroundColor Green

} # End Try, $Section

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
