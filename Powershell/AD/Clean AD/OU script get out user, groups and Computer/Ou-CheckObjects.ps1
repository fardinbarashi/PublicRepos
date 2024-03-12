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
Title : Take every object in the OU and export to csv folder, create html reports on the objects
Description : Take every object with a certain attributes to and save it to csv folder

Change the row 47 $SearchOu = "" to the OU distinguishedName that you want to look on. 

Create the folders if they are not created automaticlly
- Files\CsvFiles\
- Files\HtmlReportFiles\
- Logs

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

# Import Active Directory-module
Import-Module ActiveDirectory

$SearchOu = ""
# Export Csv files
$CsvfileAdUsers = "$PSScriptRoot\Files\CsvFiles\$SearchOu-AdUsers-$LogFileDate.csv"
$CsvfileAdGroups = "$PSScriptRoot\Files\CsvFiles\$SearchOu-AdGroups-$LogFileDate.csv"
$CsvfileAdComputer = "$PSScriptRoot\Files\CsvFiles\$SearchOu-AdComputer-$LogFileDate.csv"

# Export-Html Files
$HtmlReportFileAdUsers = "$PSScriptRoot\Files\HtmlReportFiles\$SearchOu-AdUsers-$LogFileDate.html"
$HtmlReportFileAdGroups = "$PSScriptRoot\Files\HtmlReportFiles\$SearchOu-AdGroups-$LogFileDate.html"
$HtmlReportFileAdComputer = "$PSScriptRoot\Files\HtmlReportFiles\$SearchOu-AdComputer-$LogFileDate.html"
 
# HTML Css Style
$CssStyle = @'
<style>
    body {
        background-color: Gainsboro;
        font-family:      "Calibri";
    }


    table {
        border-width:     1px;
        border-style:     solid;
        border-color:     black;
        border-collapse:  collapse;
        width:            75%;
        text-align: Center;
    }

    col {
        width: 20%;
    }

    th {
        border-width:     1px;
        padding:          5px;
        border-style:     solid;
        border-color:     black;
        background-color: #98C6F3;
    }

    td {
        border-width:     1px;
        padding:          5px;
        border-style:     solid;
        border-color:     black;
        background-color: White;
    }


    tr {
        
        background-color: #00ff00;
    }
    
    Tr:Hover {
 font-weight: bold;
}
   
</style>
'@


#----------------------------------- Start Script ------------------------------------------
# Section 1 : Get Every User, Ad-Group and coumputer in the $SearchOu and export it to $Csvfiles
Write-Host ""
Write-Host "----------------------------------- CSV ------------------------------------------."
$Section = "Section 1 : Get Every User, Ad-Group and coumputer in the $SearchOu and export it to $Csvfiles"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
      Write-Host "Get Adusers.."
      $CheckAduser = Get-ADUser -Filter "*" -Verbose -SearchBase $SearchOu
       If ($CheckAduser -Eq $Null )
        { # Start If ($CheckAduser -Eq $Null )
          Write-Host "- OU does NOT contains users" -ForegroundColor Yellow
        } # End If ($CheckAduser -Eq $Null )
       Else
        { # Start If, Else ($CheckAduser -Eq $Null )
          Write-Host "- OU contains users" -ForegroundColor Green
          $Adusers = Get-ADUser -Filter "*" -Verbose -SearchBase $SearchOu -Properties * |  
          # User Attributes 
          # Name, FirstName, LastName, Type, Description, LastLogon, lastLogonTimestamp, Account Status, Current OU
          Select-Object @{Name="AccountName";Expression={$_.SamAccountName}},
                     @{Name="FirstName";Expression={$_.givenname}},
                     @{Name="LastName";Expression={$_.surname}},
                     @{Name="Type"; Expression={if ($_.userAccountControl -band 0x200) {"Normal User Account"} else {"Other"}}}, 
                     @{Name="Description";Expression={$_.Description}},
                     @{Name="LastLogon"; Expression={[DateTime]::FromFileTime($_.lastLogon)}},
                     @{Name="lastLogonTimestamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}},
                     @{Name="AccountStatus";Expression={if ($_.userAccountControl -eq '514') {"Account Disabled"} else {"Account Enabled"}}},
                     @{Name="CurrentOu";Expression={$_.distinguishedName}} |
          # Export to a CSV-File
          Export-CSV -Path "$CsvfileAdUsers" -NoTypeInformation -Force -Verbose -Encoding UTF8 -Delimiter ";"
          Write-Host ""
        } # End If, Else ($CheckAduser -Eq $Null )


      Write-Host "Get AD-Groups.."
      $CheckAdGroup = Get-ADGroup -Filter "*" -Verbose -SearchBase $SearchOu
       If ($CheckAdGroup -Eq $Null )
        { # Start If ($CheckAdGroup -Eq $Null )
          Write-Host "- OU does NOT contains AD-Groups" -ForegroundColor Yellow
        } # End If ($CheckAdGroup -Eq $Null )
       Else
        { # Start if, Else ($CheckAdGroup -Eq $Null )
          Write-Host "- OU contains AD-Groups"  -ForegroundColor Green
          $AdGroups = Get-ADGroup -Filter "*" -Verbose -SearchBase $SearchOu -Properties * |  
          # Group Attributes
          # Name, Description, WhenChanged,WhenCreated, ManagedBy, Members, Members Of, Current Ou
          Select-Object @{Name="GroupName";Expression={$_.Name}},
                     @{Name="Description";Expression={$_.Description}},
                     @{Name="WhenChanged";Expression={$_.WhenChanged}},
                     @{Name="WhenCreated";Expression={$_.WhenCreated}},
                     @{Name="Members";Expression={$_.Members}},
                     @{Name="MemberOf";Expression={$_.MemberOf}},
                     @{Name="ManagedBy";Expression={$_.ManagedBy}},
                     @{Name="CurrentOu";Expression={$_.distinguishedName}} |
          # Export to a CSV-File
          Export-CSV -Path "$CsvfileAdGroups" -NoTypeInformation -Force -Verbose -Encoding UTF8 -Delimiter ";"
          Write-Host ""
        } # End if, Else ($CheckAdGroup -Eq $Null )
      
      Write-Host ""
      Write-Host "Get AD-Computers.."
      $CheckAdComputer = Get-ADComputer -Filter "*" -Verbose -SearchBase $SearchOu
       If ($CheckAdComputer -Eq $Null )
        { # Start If ($CheckAdComputer -Eq $Null )
          Write-Host "- OU does NOT contains AD-Computers" -ForegroundColor Yellow
        } # End If ($CheckAdComputer -Eq $Null )
       Else
        { # Start if, Else ($CheckAdComputer -Eq $Null )
          Write-Host "- OU contains AD-Computers"  -ForegroundColor Green
          $AdGroups = Get-ADComputer -Filter "*" -Verbose -SearchBase $SearchOu -Properties * |  
          # Computer Attributes
          # Name, Description, LastLogon, LastLogonTimeStamp, WhenChanged, WhenCreated, OperatingSystem, OperatingSystemVersion,IPv4Address, Current Ou
          Select-Object @{Name="Name";Expression={$_.Name}},
                     @{Name="Description";Expression={$_.Description}},
                     @{Name="LastLogon"; Expression={[DateTime]::FromFileTime($_.lastLogon)}},
                     @{Name="lastLogonTimestamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}},
                     @{Name="WhenChanged";Expression={$_.WhenChanged}},
                     @{Name="WhenCreated";Expression={$_.WhenCreated}},
                     @{Name="OperatingSystem";Expression={$_.OperatingSystem}},
                     @{Name="OperatingSystemVersion";Expression={$_.OperatingSystemVersion}},
                     @{Name="IPv4Address";Expression={$_.IPv4Address}},
                     @{Name="CurrentOu";Expression={$_.distinguishedName}} |
          # Export to a CSV-File
          Export-CSV -Path "$CsvfileAdComputer" -NoTypeInformation -Force -Verbose -Encoding UTF8 -Delimiter ";"
          Write-Host ""
        } # End if, Else ($CheckAdComputer -Eq $Null )
 

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


#----------------------------------- HTML ------------------------------------------
# Section 2 : Create Html Reports file for each $Csvfiles
Write-Host ""
Write-Host "----------------------------------- HTML ------------------------------------------."
$Section = "Section 2 : Create Html Reports file for each $Csvfiles"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow
 # Run Query
# Run Query
  # HTML for AD-Users
      Write-Host ""
      Write-Host "Check if $CsvfileAdUsers exsist.."
       if(Test-path $CsvfileAdUsers -PathType leaf)
        { # Start If, If (Test-path $CsvfileAdUsers -PathType leaf)
          Write-Host " Creating html file for AD-Users" -ForegroundColor Green
          $HTMLReportQueryADusers =  Get-ADUser -Filter "*" -Verbose -SearchBase $SearchOu -Properties * |  
          # User Attributes 
          # Name, FirstName, LastName, Type, Description, LastLogon, lastLogonTimestamp, Account Status, Current OU
            Select-Object @{Name="AccountName";Expression={$_.SamAccountName}},
            @{Name="FirstName";Expression={$_.givenname}},
            @{Name="LastName";Expression={$_.surname}},
            @{Name="Type"; Expression={if ($_.userAccountControl -band 0x200) {"Normal User Account"} else {"Other"}}}, 
            @{Name="Description";Expression={$_.Description}},
            @{Name="LastLogon"; Expression={[DateTime]::FromFileTime($_.lastLogon)}},
            @{Name="lastLogonTimestamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}},
            @{Name="AccountStatus";Expression={if ($_.userAccountControl -eq '514') {"Account Disabled"} else {"Account Enabled"}}},
            @{Name="CurrentOu";Expression={$_.distinguishedName}} | 
          # Export to a HTML-File
          ConvertTo-Html -Title "AD User Report" -Head $CssStyle -Body "<h1>Active User Groups Report</h1>" -PreContent "<p>Generated on $LogFileDate </p>" | 
          Out-File -FilePath $HtmlReportFileAdUsers -Encoding utf8 -Force -Verbose

        } # End If, If (Test-path $CsvfileAdUsers -PathType leaf)
       else
        { # Start If, Else If (Test-path $CsvfileAdUsers -PathType leaf)
            Write-Host " File $CsvfileAdUsers does not exsist, no html file for AD-users is created" -ForegroundColor Yellow
        } # End If, Else If (Test-path $CsvfileAdUsers -PathType leaf)


      # HTML for AD-Groups
      Write-Host ""
      Write-Host "Check if $CsvfileAdGroups exsist.."
       if(Test-path $CsvfileAdGroups -PathType leaf)
        { # Start If, If (Test-path $CsvfileAdGroups -PathType leaf)
          Write-Host "- Creating html file for AD-Groups" -ForegroundColor Green
          $HTMLReportQueryADgroups = Get-ADGroup -Filter "*" -Verbose -SearchBase $SearchOu -Properties * |  
          # Group Attributes
          # Name, Description, WhenChanged,WhenCreated, ManagedBy, Members, Members Of, Current Ou
          Select-Object @{Name="GroupName";Expression={$_.Name}},
                     @{Name="Description";Expression={$_.Description}},
                     @{Name="WhenChanged";Expression={$_.WhenChanged}},
                     @{Name="WhenCreated";Expression={$_.WhenCreated}},
                     @{Name="Members";Expression={$_.Members}},
                     @{Name="MemberOf";Expression={$_.MemberOf}},
                     @{Name="ManagedBy";Expression={$_.ManagedBy}},
                     @{Name="CurrentOu";Expression={$_.distinguishedName}} | 
          # Export to a HTML-File
          ConvertTo-Html -Title "AD Groups Report" -Head $CssStyle -Body "<h1>Active Directory Groups Report</h1>" -PreContent "<p>Generated on $LogFileDate </p>" | 
          Out-File -FilePath $HtmlReportFileAdUsers -Encoding utf8 -Force -Verbose
        } # End If, If (Test-path $CsvfileAdGroups -PathType leaf)
       else
        { # Start If, Else If (Test-path $CsvfileAdGroups -PathType leaf)
            Write-Host "- File $CsvfileAdGroups does not exsist, no html file for AD-Groups is created" -ForegroundColor Yellow
        } # End If, Else If (Test-path $CsvfileAdGroups -PathType leaf)


      # HTML for AD-Computers
      Write-Host ""
      Write-Host "Check if $CsvfileAdComputer exsist.."
       if(Test-path $CsvfileAdComputer -PathType leaf)
        { # Start If, If (Test-path $CsvfileAdComputer -PathType leaf)
          Write-Host " Creating html file for AD-Computers" -ForegroundColor Green
          $HTMLReportQueryADcomputer =  Get-ADComputer -Filter "*" -Verbose -SearchBase $SearchOu -Properties * |  
          # Computer Attributes
          # Name, Description, LastLogon, LastLogonTimeStamp, WhenChanged, WhenCreated, OperatingSystem, OperatingSystemVersion,IPv4Address, Current Ou
          Select-Object @{Name="Name";Expression={$_.Name}},
                     @{Name="Description";Expression={$_.Description}},
                     @{Name="LastLogon"; Expression={[DateTime]::FromFileTime($_.LastLogon)}},
                     @{Name="lastLogonTimestamp"; Expression={[DateTime]::FromFileTime($_.LastLogonTimestamp)}},
                     @{Name="WhenChanged";Expression={$_.WhenChanged}},
                     @{Name="WhenCreated";Expression={$_.WhenCreated}},
                     @{Name="OperatingSystem";Expression={$_.OperatingSystem}},
                     @{Name="OperatingSystemVersion";Expression={$_.OperatingSystemVersion}},
                     @{Name="IPv4Address";Expression={$_.IPv4Address}},
                     @{Name="CurrentOu";Expression={$_.distinguishedName}} |
          # Export to a HTML-File
          ConvertTo-Html -Title "AD Computer Report" -Head $CssStyle -Body "<h1>Active Directory Computer Report</h1>" -PreContent "<p>Generated on $LogFileDate </p>" | 
          Out-File -FilePath $HtmlReportFileAdComputer -Encoding utf8 -Force -Verbose
        } # End If, If (Test-path $CsvfileAdComputer -PathType leaf)
       else
        { # Start If, Else If (Test-path $CsvfileAdComputer -PathType leaf)
            Write-Host "- File $CsvfileAdComputer does not exsist, no html file for AD-Computers is created" -ForegroundColor Yellow
        } # End If, Else If (Test-path $CsvfileAdComputer -PathType leaf)

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


<#

 # If a user lastlogin or lastlogin timestamp i 2023 color Red, 2024 : red, 2022: Yellow: 2021 : Green



#>