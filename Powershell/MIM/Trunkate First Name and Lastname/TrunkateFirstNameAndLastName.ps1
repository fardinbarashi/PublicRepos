<#
This Script get all active users from MIM, it trunks firstname to max char of 20 and lastname to 30 char.
Later it validates and save entries to a textfile if its longer.
#>

#----------------------------------- Settings ------------------------------------------
# TranScript
$ScriptName = $MyInvocation.MyCommand.Name
$TranScriptLogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $TranScriptLogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# FilePath Settings
Write-Host ".. Loading FilePaths"
$FilenameDate = (Get-Date -Format yyyyMMdd)
$FromMim = "$PSScriptRoot\RootFileFromMim_$FilenameDate.Csv"
$FirstNameTruncateFileCreateUpdateUsers = "$PSScriptRoot\TruncateFirstName_$FilenameDate.txt"
$LastNameTruncateFileCreateUpdateUsers = "$PSScriptRoot\TruncateLastName_$FilenameDate.txt"    

# Other Settings
Write-Host ".. Adding TimeSettings"
$WhatTimetoSendFile = ( Get-Date ).AddMinutes(15)

Write-Host ""
#-----------------------------------------------------------------------------


# Section 1 : Connect to To MIM-Engine
Try
{ # Start Try
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
$WhatDoesThisSectionDo = "Section 1 : Connect to To MIM-Engine and get out all active users as CSV in FromMim"
Write-Host $WhatDoesThisSectionDo "0%" -ForegroundColor Yellow

# Run Query
# Import Module LithnetRMA
Write-Host ".. 1.1 - Import Module LithnetRMA"
Import-Module LithnetRMA

# Set host localhost:5725"
Write-Host ".. 1.2 - Set host localhost:5725"
Set-ResourceManagementClient -BaseAddress "http://localhost:5725"

Write-Host $WhatDoesThisSectionDo "100%" -ForegroundColor Green
Write-Host ""
} # End Try

Catch
{ # Start Catch
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host "ERROR on $WhatDoesThisSectionDo" -ForegroundColor Red
Write-Warning $Error[0]
Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
Stop-Transcript
Exit
} # End Catch
#-----------------------------------------------------------------------------


# Section 2 : Get all active users and save as CSV to $FromMim
Try
{ # Start Try
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
$WhatDoesThisSectionDo = "Section 2 : Get all active users and save as CSV to $FromMim"
Write-Host $WhatDoesThisSectionDo "0%" -ForegroundColor Yellow

# Run Query

# X-Path Attributes
Write-Host ".. 2.1 - Loading X-Path Attributes "
$XPath = "/Person[(starts-with(QualityAssuredFirstName, '%')) and (starts-with(QualityAssuredLastName, '%')) and (ends-with(Email, '@lab.local')) and (AccountStatus !='Terminated') and (starts-with(QualityAssuredGender,'%'))]"

# Query FIM for active users by using Xpath string
Write-Host ".. 2.2 - Query FIM for active users by using Xpath Attributes "
$Persons = Search-Resources -XPath $XPath -AttributesToGet ("AccountName", "Department","MobilePhone","EmployeeID","OfficePhone","Email","AccountStatus","","QualityAssuredGender","QualityAssuredMiddleName","QualityAssuredLastName","QualityAssuredFirstNames","QualityAssuredFirstName")

# Attributes = Company|LegalEntity|UniqueID|FirstName|LastName|EmailAdress|Title|PhoneMobile
Write-Host ".. 2.3 - Company|LegalEntity|UniqueID|FirstName|LastName|EmailAdress|Title|PhoneMobile"
$Attributes = "Company|LegalEntity|UniqueID|FirstName|LastName|EmailAdress|Title|PhoneMobile"

#Add header
$sw = New-Object System.IO.StreamWriter($FromMim,$false,[System.Text.Encoding]::UTF8)
$sw.WriteLine($Attributes)

# Loading active users Attributes saving to Headers on $FromMim
Write-Host ".. 2.4 - Loading active users Attributes saving to Headers on $FromMim" 

Write-host ""
#Add all persons to file
$CountPeopleInMimFile =  ("{0} Users added to " -f $Persons.Count)
Write-Host ".. Added users ( $CountPeopleInMimFile ) to file $FromMim"
Foreach($Person in $Persons) { # Start Foreach $Person in $Persons)
 $line = ""
  foreach($Attribute in $Attributes.Split('|')) { # Start foreach($Attribute in $Attributes
      switch ($Attribute) { # Start Switch    
       "Company" 
        { # Start Company
           $line += "CompanyName"
        } # End Company
       "LegalEntity" 
        { # Start LegalEntity
           $line += "LegalEntityName"
        } # End LegalEntity
       "UniqueID" 
        { # Start UniqueID
          $line += $Person.AccountName
        } # End UniqueID
       "FirstName" 
        { # Start FirstName
         $line += $Person.QualityAssuredFirstNames.Substring(0.20)
        } # End First Name
       "LastName" 
        { # Start LastName
         $line += $Person.QualityAssuredLastName.Substring(0.30)
        } # End Last Name
       "EmailAdress" 
        { # Start Email Adress 
           $line += $Person.Email
        } # End Email Adress
       "Title" 
        { # Start Title
         if($Person.QualityAssuredGender -eq 'K') { $line += "ms" }
         elseif($Person.QualityAssuredGender -eq 'M') { $line += "mr" }
        }  # End Title            
       "PhoneMobile" 
        { # Start Phone Mobile
         $line += $Person.MobilePhone | ForEach-Object { $_-replace '-', "" } 
        } # End Phone Mobile                                                                                  
    } # End Switch
   $line += "|"
  } # End foreach($Attribute in $Attributes
  $line = $line.Substring(0,$line.Length-1)
  $sw.WriteLine($line)
} # End  # Start Foreach $Person in $Persons)
$sw.Close() 

Write-Host $WhatDoesThisSectionDo "100%" -ForegroundColor Green
Write-Host ""
} # End Try

Catch
{ # Start Catch
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host "ERROR on $WhatDoesThisSectionDo" -ForegroundColor Red
Write-Warning $Error[0]
Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
Stop-Transcript
Exit
} # End Catch
#-----------------------------------------------------------------------------
#>

# Section 3 : Take Every Users that have Firstname longer then 20 char or Lastname longer than 30 char and add to file $TruncateFileCreateUpdateUSers 
Try
{ # Start Try
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
$WhatDoesThisSectionDo = "Step 3 : Take Every Users that have Firstname longer then 20 char or Lastname longer than 30 char and add to file TruncateFiles "
Write-Host $WhatDoesThisSectionDo "0%" -ForegroundColor Yellow

# Run Query
 # Filter out Rows with Firstname longer then 20 char and LastName Longer then 30 char
$GetNameInCsvFile = Import-Csv -Path $FromMim -Delimiter "|" -Encoding UTF8 | Foreach { # Start Foreach
New-Object PsObject -Prop @{ # Start New-Objects 
 # Company - LegalEntity -TravelerType - UniqueID - FirstName - LastName - EmailAdress - PhoneMobile 
 Company = $_.Company;
 LegalEntity = $_.LegalEntity;
 UniqueID = $_.UniqueID;
 FirstName = $_.FirstName;
 LastName = $_.LastName;
 EmailAdress = $_.EmailAdress;
 Title = $_.Title;
 PhoneMobile = $_.PhoneMobile;                 
 } # End-NewObject
} # End Foreach
# Loop csv 
$GetNameInCsvFile | ForEach-Object { # Start ForEach-Object
$Fname = $_.FirstName
$Lname = $_.LastName
Write-Host "Validating" $Fname $Lname
  if($Fname.Length -ge 20 -OR $Lname.Length -ge 30 ){ # Start IF($Fname.Length -ge 20 -OR $Lname.Length -ge 30 )
      if($Fname.Length -ge 20){ # Start IF ($Fname.Length -ge 20 )
          Write-Host "NOT OK, must truncate Fname!" $Fname "= " $Fname.Length
          Write-Host $Fname[0..19] -join "" 
          $Fname |  Out-File -FilePath $FirstNameTruncateFileCreateUpdateUsers -Encoding utf8 -Append
      } # End IF ($Fname.Length -ge 20 )
      if($Lname.Length -ge 30 ){ # Start IF ($Lname.Length -ge 30 )
           Write-Host "NOT OK, must truncate Lname!" $Lname "= " $Lname.Length
           $Lname[0..29] -join "" 
           $Lname |  Out-File -FilePath $LastNameTruncateFileCreateUpdateUsers -Encoding utf8 -Append
      } # End IF ($Lname.Length -ge 30 )  
    
  } # End IF($Fname.Length -ge 20 -OR $Lname.Length -ge 30 )
  else
  { # Start Else
      Write-Host "Validate OK!"

  } # End Else
 } # End Foreach-Object

Write-Host $WhatDoesThisSectionDo "100%" -ForegroundColor Green
Write-Host ""
} # End Try

Catch
{ # Start Catch
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host "ERROR on $WhatDoesThisSectionDo" -ForegroundColor Red
Write-Warning $Error[0]
Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
Stop-Transcript
Exit
} # End Catch

