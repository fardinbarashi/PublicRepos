<#
.SYNOPSIS

.DESCRIPTION
This script removes accounts that is has not been logged in over 180 days.
If you want to change the amount of days, you need to change $DaysFilterAccounts .AddDays(-180) 
The Accounts Reg-edit items at profilelist/Sid and homefolder ( localpath ) will be removed.


.NOTES
Author: Fardin.Barashi@gmail.com
Created: 2019 07 05
Version: 1.0 

Works on Windows 10 Enterprise Build 17763

#>


<# Change Value to remove account after a certain days #>
$DaysFilterAccounts = (get-date (Get-Date).AddDays(-180) -UFormat "%Y%m%d") 

<# $CheckLastUseTime
   Get all UserProfiles, Filter Service and Admin-accounts
   Select and convert LastUsetime to a date object
   Where only accounts lastusetime is Less Or Equal to $DaysFilterAccounts
#>
$CheckLastUseTime = Get-CimInstance -Filter "Special=False AND Loaded=False" -ClassName Win32_UserProfile | 
Select-Object @{Name="LastUseTime";Expression={Get-Date $_.Lastusetime -Format "yyyyMMdd" } } | 
Where-Object { $_.LastUseTime -Le $DaysFilterAccounts } 

<#  Create a String for Lastusetime #>
$AccountLastUseTime = $CheckLastUseTime.Lastusetime

<# 
   ForEach-Object In $GetProfiles If .LastUsetime is Less Or Equal to $DaysFilterAccounts
   Then Get the UserProfile Data And 
   Remove Profiledata 
#>
   If ( $AccountLastUseTime -Le $DaysFilterAccounts ) 
   { #  Start if  ( $AccountLastUseTime -Le $DaysFilterAccounts ) 
     # Remove Profiles
        $GetUserProfileData = Get-WmiObject -Class Win32_UserProfile -Filter "Special=False AND Loaded=False" | 
         Where { $_.LastUseTime -Le $DaysFilterAccounts }                 
         $GetUserProfileData  | Remove-WmiObject 
   } #  End if  ( $AccountLastUseTime -Le $DaysFilterAccounts )  
   
   Else 
   { #  Start Else if  ( $AccountLastUseTime -Le $DaysFilterAccounts )    
    Write-Output "No inactive accounts found"  
   } #  End Else, if  ( $AccountLastUseTime -Le $DaysFilterAccounts )  
 