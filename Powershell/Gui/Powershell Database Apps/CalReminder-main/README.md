# CalReminder

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
The file is a list of objects that need to be fixed.
This file is located at "*\ExpiredObject\ExpiredObject.txt"

To get this script to work you need to change some variabels at the beginning

$SmtpServer = "AddYourSMTPServer" 
$MailFrom = "CalenderReminder@AddYourDomain" # Mail From
$MailTo = "ADD YOUR ServiceMailbox <YOURServiceMailbox@AddYourDomain>" # Mail To

# File Path
$PathToExpiredObjectsFile = "AddFullPathToTheFile\CalReminder\ExpiredObject\ExpiredObject.txt"
$CsvFilePath = "AddFullPathToTheFile\CalReminder\csvfile\Calenderdates.csv"

# Date Trigger
$DaysTrigger = "ADD DAYS"

