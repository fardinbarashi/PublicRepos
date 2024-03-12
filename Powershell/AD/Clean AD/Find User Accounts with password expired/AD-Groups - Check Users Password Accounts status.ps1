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
Title : 
Description : Get Users that have password expired
Version : 1.0
Release day : 2023-01-31
Github Link  : https://github.com/fardinbarashi
News : 
#>

#----------------------------------- Settings ------------------------------------------


# AD-Group
$AdGroup =""

# Get Users with Password Expired
 Get-ADGroupMember -Identity "$AdGroup" -Recursive `
                            | Get-ADUser -Property samAccountName, Name, givenName, sn, Enabled, PasswordExpired, MemberOf, msDS-UserPasswordExpiryTimeComputed `
                            | Where-Object { $_.Enabled -eq $true -and $_.PasswordExpired -eq $true }


# Get Users with Account has expired

$GetUsersAccountExpired =    Get-ADGroupMember -Identity "$AdGroup" -Recursive `
                            | Get-ADUser -Property samAccountName, Name, givenName, sn, Enabled, MemberOf, AccountExpires, PasswordNeverExpires `
                            | Select-Object samAccountName, Name, givenName, sn, Enabled, MemberOf, AccountExpires, PasswordNeverExpires,
                                @{Name="WillExpire";Expression={if ([datetime]::FromFileTime($_."AccountExpires") -lt (Get-Date) -and $_.AccountExpires -ne '9223372036854775807' ) { $true } else { $false }}} `
                            | Where-Object { $_.Enabled -eq $false -or $_.WillExpire -eq $True }


# Get Users with Password about to be expired "
$GetUsersPasswordWillExpire = Get-ADGroupMember -Identity "$AdGroup" -Recursive | ? { $_.ObjectClass -eq 'User' } `
                            | Get-ADUser -Properties givenName, sn, msDS-UserPasswordExpiryTimeComputed, PasswordLastSet, CannotChangePassword, LastLogonTimestamp, PasswordNeverExpires, PasswordExpired, MemberOf `
                            | Where-Object { $_.Enabled -eq $true -and $_.CannotChangePassword -eq $false -and $_.PasswordNeverExpires -eq $false -and $_.PasswordExpired -eq $false } `
                            | Select-Object givenName, sn, samAccountName, PasswordLastSet, MemberOf,
                                @{Name="LastLogonDate";Expression={[datetime]::FromFileTime($_."LastLogonTimestamp")}},
                                @{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}, 
                                @{Name="WillExpire";Expression={if ([datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") -lt (Get-Date).AddDays($PasswordValueDays) ) { $true }}} `
                            | Sort-Object -Property ExpiryDate `
                            | Where-Object { $_.WillExpire -eq $true }

