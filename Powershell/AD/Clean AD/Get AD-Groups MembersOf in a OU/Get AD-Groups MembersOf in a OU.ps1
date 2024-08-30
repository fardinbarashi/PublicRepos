
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

# Import Active Directory-module
Import-Module ActiveDirectory

$SourceOU = ""



Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 $GroupMembers = @()

  $Groups = Get-ADGroup -Filter * -properties * -SearchBase $SourceOU  -Verbose
   foreach ($group in $Groups) 
    {
     $members = $group | Get-ADGroupMember 
      foreach ($member in $members) 
      {
       $Info = New-Object psObject 
       $Info | add-member -MemberType NoteProperty -Name "GroupName" -Value $group.Name
      # $Info | add-member -MemberType NoteProperty -Name "Description" -Value $group.description
      # $Info | add-member -MemberType NoteProperty -Name "Member of" -Value $group.MemberOf
       $Info | Add-Member -MemberType NoteProperty -Name "Member" -Value $member.name
       $GroupMembers+= $Info
      }
    }
  $GroupMembers | Sort-Object GroupName | Export-CSV $PSScriptRoot\MoveAdGroups.csv -NoTypeInformation -Encoding UTF8 -Force -Verbose -Delimiter ";"
  
  
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
