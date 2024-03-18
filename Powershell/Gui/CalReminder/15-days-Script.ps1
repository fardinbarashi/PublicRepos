<#
The script looks in Enddate column in the csv file.
If there is a date that will get expired in $DaysTrigger, we will receive an email and attachment that contains the object.

Information about Calenderdates.csv
The CSV file has several columns that need to be populated.
This file is located at "*\csvfile\Calenderdates.csv"

Explanation of columns
     Enddate: End date, after this date the object becomes invalid (The formatting must be Month-Date-Year eg 12-30-2020)
     ObjectName: Name of the object, eg the name of the certificate
     Template, Category type, is it a web server cert etc
     Server, Which server is this
     Enviroment: Test / Development / Live
     Description: A short description

Information about ExpiredObject.txt
The file is a list of outgoing items that need to be fixed.
This file is located at "*\ExpiredObject\ExpiredObject.txt"
#>

########################################################################################

# Start Script
# Settings Start
$SmtpServer = "SmtpRelay.lab.local" # Smtp Server
$MailFrom = "CalenderReminder@lab.local" # Mail From
$MailTo = "ServiceMailbox <ServiceMailbox@lab.local>" # Mail To

# File Path
$PathToExpiredObjectsFile = "C:\Temp\CalReminder\ExpiredObject\ExpiredObject.txt"
$CsvFilePath = "C:\temp\CalReminder\csvfile\Calenderdates.csv"

# Date Trigger
$DaysTrigger = "15"

If ( ( Test-Path $PathToExpiredObjectsFile -PathType Leaf ) ) 
 { # Start If 
  # Remove-Item
  Remove-Item -Path $PathToExpiredObjectsFile -Force
  # SMTP
  $MailSubject = " Cal-Reminder notification - Error ExpiredObject.txt "  #  MailSubject
  $MailBody = "An error has occurred in the script, the file ExpiredObject.txt has existed since a previous run. The file is now deleted, check if the file remains an rerun the script" #  MailBody 
  Send-MailMessage -To $MailTo -From $MailFrom -Subject $MailSubject -Body $MailBody -SmtpServer $SmtpServer -Encoding ([System.Text.Encoding]::UTF8)
 } # End If

Else 
 { # Start Else 
 Try
   { # Start Try
    # Import-Csv File
     $ImportCsv = Import-Csv $CsvFilePath -Delimiter "," -Encoding UTF8 | ForEach-Object { # Start ForEach-Object 
      New-Object PsObject -Prop @{ 
      # Start New-Object
       # Start Creating New-Objects
        ObjectName = $_.ObjectName
        Expires = [DateTime]::Parse($_.Enddate)
        Template = $_.Template
        Server = $_.Server
        Enviroment = $_.Enviroment
        Description = $_.Description
       # End Creating New-Objects
     } # End New-Object
    } # End ForEach-Object
   
   $GetExpiredObjects = $ImportCsv | Where-Object { $_.Expires -Le (Get-Date).AddDays($DaysTrigger) }
    If ( $GetExpiredObjects -Eq $Null ) 
    { # Start If 
     # String contains no expiring objects
    } # End If

    Else 
    { # Start Else
      # String contains expiring objects
      $GenerateGetExpiredObjectsFile = $ImportCsv | Where-Object { $_.Expires -Le (Get-Date).AddDays($DaysTrigger) } | Out-File $PathToExpiredObjectsFile
      # SMTP
      $MailSubject = " Cal-Reminder notification "  #  MailSubject
      $MailBody = "Objects is approaching $DaysTrigger days before it becomes invalid, See ExpiredObject.txt for more information, Do not forget to modify the file $CsvFilePath"  #  MailBody
      $MailAttachments = (Get-ChildItem "$PathToExpiredObjectsFile").FullName
      Send-MailMessage -To $MailTo -From $MailFrom -Subject $MailSubject -Body $MailBody -Attachments $MailAttachments -SmtpServer $SmtpServer -Encoding ([System.Text.Encoding]::UTF8)
    } # End Else
   } # End Try
 Catch
   { # Start Catch
     $MailSubject = " Cal-Reminder notification - Import-Csv Calenderdates.csv "  #  MailSubject
     $MailBody = "An error has occurred in the script, the file $CsvFilePath could not get imported" #  MailBody 
     Send-MailMessage -To $MailTo -From $MailFrom -Subject $MailSubject -Body $MailBody -SmtpServer $SmtpServer -Encoding ([System.Text.Encoding]::UTF8) 
   } # End Catch

 } # End Else
# End Script

