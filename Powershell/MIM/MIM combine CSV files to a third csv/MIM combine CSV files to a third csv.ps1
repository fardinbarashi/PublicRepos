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

About Script : Template for Ps-5 Scripts
Author : Fardin Barashi
Title : Template Powershell version 5.x
Description MIM csv Combiner
Version : 1.0
Release day : 2023-01-31
Github Link  : https://github.com/fardinbarashi
News : 


1.The script retrieves active users from MIM and saves it in a csv file $FromMim.
2.The script retrieves active users from AD and saves it in a csv file$FromAD.
3.The script creates a third csv file, $CombinedCsv
#>
#----------------------------------- Settings ------------------------------------------
# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# Error-Settings
$ErrorActionPreference = 'Continue'

# Export location
$FromMim = "$PSScriptRoot\CsvFiles\FromMim\FromMim.csv"
$FromAD = "$PSScriptRoot\CsvFiles\FromAD\FromAD.csv"
$CombinedCsv = "$PSScriptRoot\CsvFiles\CombinedCsv\Allusers.csv"

#----------------------------------- Start Script ------------------------------------------
# Section 1 : Import Modules
$Section1 = "Section 1 : Import Module"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "$Section1 ...0%" -ForegroundColor Yellow
 Write-Host ""
 # Run Query
 Write-host  "===================================="
 Write-host  "Initialization script..."
 Write-host  ""

 Write-host "Step 1 : Import Modules.. 0%" -ForegroundColor Yellow
 Import-Module LithnetRMA -Verbose
 Write-host "Import Module LithnetRMA"

 Import-Module ActiveDirectory -Verbose
 Write-host "Import Module ActiveDirectory" 
   
 # Init connection to fim
 Write-host  "Initializing connection to MIM"
 Set-ResourceManagementClient -BaseAddress "http://localhost:5725" # Set host to query, should be localhost unless run from another server.


 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section1" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch


# Section 2 : Create Filepath 
$Section2 = "Section 2 : Create Filepath  "
Try
{ # Start Try, $Section2
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "$Section1 ...100%" -ForegroundColor Green
 Write-Host ""

 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "$Section2 ...0%" -ForegroundColor Yellow
 Write-Host ""
 # Run Query
  
  # FileCheck $FromMim
     $FileCheckFromMim = Get-ChildItem -Path $FromMim -Recurse -Force | Test-Path -PathType Leaf
      If( $FileCheckFromMim -Eq $Null )
      { # Start If,  If( $FileCheckFromMim -Eq $Null )
       Write-host $FileCheckFromMim "Is Empty"
      }  # End If,  If( $FileCheckFromMim -Eq $Null )
     Else 
      { # Start Else,  If( $FileCheckFromMim -Eq $Null )
       Write-host "Removing Previous $FromMim" -ForegroundColor Magenta
       Get-ChildItem -Path $FromMim -Force -Recurse | Remove-Item -Force
      } # End Else,  If( $FileCheckFromMim -Eq $Null )

  # FileCheck $FromAD 
   $FileCheckFromAD = Get-ChildItem -Path $FromAD -Recurse -Force | Test-Path -PathType Leaf
     If( $FileCheckFromAD -Eq $Null )
      { # Start If,  If( $FileCheckFromAD -Eq $Null )
        Write-host $FileCheckFromAD "Is Empty"
      } # End If,  If( $FileCheckFromAD -Eq $Null )
     Else 
      { # Start If,  If( $FileCheckFromAD -Eq $Null )
       Write-host "Removing Previous $FromAD" -ForegroundColor Magenta
       Get-ChildItem -Path $FromAD -Force -Recurse | Remove-Item -Force
      } # End Else,  If( $FileCheckFromAD -Eq $Null )
   
  # FileCheck $CombinedCsv
   $FileCheckCombinedCsv = Get-ChildItem -Path $CombinedCsv -Recurse -Force | Test-Path -PathType Leaf
    If( $FileCheckCombinedCsv -Eq $Null )
      { # Start If,  If( $FileCheckCombinedCsv -Eq $Null )
        Write-host $FileCheckCombinedCsv "Is Empty"
      } # End If,  If( $FileCheckCombinedCsv -Eq $Null ) 
    Else 
      { # Start Else,  If( $FileCheckCombinedCsv -Eq $Null )
        Write-host "Removing Previous $CombinedCsv" -ForegroundColor Magenta
        Get-ChildItem -Path $CombinedCsv -Force -Recurse | Remove-Item -Force
      } # End Else,  If( $FileCheckCombinedCsv -Eq $Null )

   Write-host  ""

 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section2" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch


# Section 3 : Query FIM, Save as CSV in $FromMim
$Section3 = "Section 3 : Query FIM, Save as CSV in $FromMim"
Try
{ # Start Try, $Section2
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "$Section2 ...100%" -ForegroundColor Green
 Write-Host ""

 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "$Section3 ...0%" -ForegroundColor Yellow
 Write-Host ""
 
 # Run Query
 Write-host "Querying MIM for active users"

   $XPath = "/Person[starts-with(EmployeeID,'%')]"   
   $Persons = Search-Resources -XPath $XPath -AttributesToGet (
   "FirstName","LastName",
   "AccountName","ManagerAccountName")
   
   #filter out generic accounts that are not people.
    $Personsdetails = $Persons | 
    Where-Object{ 
    # Start Where-Object
     $_.AccountName -ne "XXX" -and
     $_.AccountName -ne "ZZZ" -and
     $_.AccountName -ne "OOO"
    # End Where-Object 
    } |
    Select-Object @{N='FirstName';E={$_.FirstName}},
                  @{N='LastName';E={$_.LastName}},
                  @{N='Username';E={$_.AccountName}},               
                  @{N='MimManager';E={$_.ManagerAccountName}}, 
                  @{N='UserPrincipalName';E={}} |
    Export-csv -NoTypeInformation -Encoding UTF8 -Delimiter ";" -Path $FromMim

    Write-host ("{0} People added to export" -f $persons.Count)

 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section3" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch


# Section 4 : Export Active AD-Users with Manager,save as csv $FromAD
$Section4 = "Section 4 : Export Active AD-Users with Manager,save as csv $FromAD"
Try
{ # Start Try, $Section2
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "$Section3 ...100%" -ForegroundColor Green
 Write-Host ""

 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "$Section4 ...0%" -ForegroundColor Yellow
 Write-Host ""
 
 # Run Query
  Write-host "Querying AD for active users" 
    $GetAdusers = Get-ADUser -SearchBase "SELECT YOUR OU" -Properties * -Filter * | 
    Where-Object { 
     $_.Enabled -Eq $True -and
     $_.SamAccountName -ne "XXX" -and
     $_.SamAccountName -ne "ZZZ" -and
     $_.SamAccountName -ne "OOO" 
     } |
    Select-Object @{Name='ADManager';Expression={(Get-ADUser $_.Manager).SamAccountName}},
    @{Name='UserPrincipalName';Expression={(Get-ADUser $_.Manager).UserPrincipalName}} |
    Export-Csv -NoTypeInformation -Encoding UTF8 -Delimiter ";" -Path $FromAD
   
   $CountFromAD = Get-Content $FromAD | Measure-Object | % { $_.Count }
   Write-host "$CountFromAD People added to $FromAD"

 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section4" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch


# Section 5 : Combine $FromMim and $FromAD. Create $CombinedCsv csv
$Section5 = "Section 5 : Combine $FromMim and $FromAD. Create $CombinedCsv csv"
Try
{ # Start Try, $Section5
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "$Section4 ...100%" -ForegroundColor Green
 Write-Host ""

 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "$Section5 ...0%" -ForegroundColor Yellow
 Write-Host ""
 # Run Query
   Write-Host "Import CSV-File to $FromAD"
   $CsvFromAD = Import-Csv -Path $FromAD -Delimiter ";" -Encoding UTF8  
   
   Write-Host "Import CSV-File to $FromMim"
   $CsvFromMim = Import-Csv -Path $FromMim -Delimiter ";" -Encoding UTF8 -Verbose
   
   Write-Host "..Get UserPrincipalName From AD.. 0%" -ForegroundColor Yellow  
   ForEach ( $Object In $CsvFromMim )
    { # Start ForEach ( $Chefer In $CsvFromAD )
     $CombineCsv = "" | select "FirstName","LastName","Username","MimManager"       
     
     $FilterManagers = $CsvFromAD | Where-Object { $_.ADManager -Eq $Object.MimManager }
       If($FilterManagers)
        { # Start If($FilterManagers)             
            $CombineCsv.'FirstName' = $Object.'FirstName'
            $CombineCsv.'LastName' = $Object.'LastName'
            $CombineCsv.'Username' = $Object.'Username'
            $CombineCsv.'MimManager' = $Object.'MimManager'
            
            
            # Add Data From AD
            $AddManagerFromAD = ( ( Get-ADUser $CombineCsv.'MimManager' ).UserPrincipalName -split " " )[0]
            
            $CombineCsv.'UserPrincipalName' = $AddManagerFromAD

            # Create CombineCsv 
            $CombineCsv | Export-Csv -Path $CombinedCsv -Delimiter ";" -Encoding UTF8 -NoTypeInformation -Append -Verbose
        } # End If($FilterManagers)
       
       else
        { # Start Else

        } # End Else

    } # End ForEach ( $Chefer In $CsvFromAD )

 Write-Host ""
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "$Section5 ...100%" -ForegroundColor Green
 Write-Host ""

Write-host  "Ending script..."
Write-host  "===================================="

Stop-Transcript
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section5" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch














