Get-WmiObject -Class Win32_UserProfile -Filter "SID = 'TYPE IN THE SID'" | 
Remove-WmiObject # Remove Profile