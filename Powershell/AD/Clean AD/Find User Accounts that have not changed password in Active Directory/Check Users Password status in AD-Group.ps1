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

About Script : 
Author : Fardin Barashi
Title : Template Powershell version 5.x
Description : Get Users with PasswordExpired
Version : 1.0
Release day : 2023-01-31
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

# Error-Settings
$ErrorActionPreference = 'Continue'

# AD-Group
$AdGroup =""
#----------------------------------- Start Script ------------------------------------------
# Section 1 : Get Users with PasswordExpired
$Section1 = "Section 1 : Get Users with PasswordExpired"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section1... "0%" -ForegroundColor Yellow

 # Run Query
 $GetUsersPasswordExpired =    Get-ADGroupMember -Identity "$AdGroup" -Recursive `
                            | Get-ADUser -Property samAccountName, Name, givenName, sn, Enabled, PasswordExpired, MemberOf, msDS-UserPasswordExpiryTimeComputed `
                            | Where-Object { $_.Enabled -eq $true -and $_.PasswordExpired -eq $true }
 Write-Host ""
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


# Section 2 : Get Users with Account has expired 
$Section2 = "Section 2 : Get Users with Account has expired "
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section1... "100%" -ForegroundColor Green
 Write-Host ""
 
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section2... "0%" -ForegroundColor Yellow

 # Run Query
$GetUsersAccountExpired =    Get-ADGroupMember -Identity "$AddToAdGroupNotify" -Recursive `
                            | Get-ADUser -Property samAccountName, Name, givenName, sn, Enabled, MemberOf, AccountExpires, PasswordNeverExpires `
                            | Select-Object samAccountName, Name, givenName, sn, Enabled, MemberOf, AccountExpires, PasswordNeverExpires,
                                @{Name="WillExpire";Expression={if ([datetime]::FromFileTime($_."AccountExpires") -lt (Get-Date) -and $_.AccountExpires -ne '9223372036854775807' ) { $true } else { $false }}} `
                            | Where-Object { $_.Enabled -eq $false -or $_.WillExpire -eq $True }
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


# Section 3 : Get Users with Password about to be expired 
$Section3 = "Section 3 : Get Users with Password about to be expired "
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section2... "100%" -ForegroundColor Green
 Write-Host ""

 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section3... "0%" -ForegroundColor Yellow

 # Run Query
$GetUsersPasswordWillExpire = Get-ADGroupMember -Identity $AddToAdGroupNotify -Recursive | ? { $_.ObjectClass -eq 'User' } `
                            | Get-ADUser -Properties givenName, sn, msDS-UserPasswordExpiryTimeComputed, PasswordLastSet, CannotChangePassword, LastLogonTimestamp, PasswordNeverExpires, PasswordExpired, MemberOf `
                            | Where-Object { $_.Enabled -eq $true -and $_.CannotChangePassword -eq $false -and $_.PasswordNeverExpires -eq $false -and $_.PasswordExpired -eq $false } `
                            | Select-Object givenName, sn, samAccountName, PasswordLastSet, MemberOf,
                                @{Name="LastLogonDate";Expression={[datetime]::FromFileTime($_."LastLogonTimestamp")}},
                                @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}, 
                                @{Name="WillExpire";Expression={if ([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") -lt (Get-Date).AddDays($PasswordValueDays) ) { $true }}} `
                            | Sort-Object -Property ExpiryDate `
                            | Where-Object { $_.WillExpire -eq $true }

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

#----------------------------------- End Script ------------------------------------------
Stop-Transcript
