<# 
System requirements
PSVersion                      5.1.19041.2364
PSEdition                      Desktop
PSCompatibleVersions           1.0, 2.0, 3.0, 4.0
BuildVersion                   10.0.19041.2364
CLRVersion                     4.0.30319.42000
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1

About Script : 
Author : Fardin Barashi
Title : Compress with 7Zip
Description : Compress all TXT files in a folder to zip file by using 7zip. 
Version : 1.0
Release day : 2024-07-31
Github Link  : https://github.com/fardinbarashi
News :
#>




$ZipPassword = Get-Content $PSScriptRoot\PasswordZip.txt 
$ZipSecurePassword = $ZipPassword | ConvertTo-SecureString
$ZipPlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ZipSecurePassword))

# Create a Alias to 7-Zip
 $TestPath7zip = Test-Path -Path $GetFilepath7zip -PathType Leaf
  If ( $TestPath7zip -Eq $True ) 
   { # Start   If ( $TestPath7zip -Eq $True ) 
     Write-Host ""
     Write-Host "7Zip is installed" -ForegroundColor Green
     Write-Host ""
      
     # Create a cmdlet for 7zip
     Write-Host "Create a cmdlet for 7zip"
     Set-Alias Seven-Zip "$env:ProgramFiles\7-Zip\7z.exe" -Verbose

     # End of section
     Write-Host ""
     Write-Host $Section... "100%" -ForegroundColor Green
     Write-Host "Script will continue to Section 2" -ForegroundColor Green  
   } # End   If ( $TestPath7zip -Eq $True ) 

 Else
  { # Start Else,  If ( $TestPath7zip -Eq $True ) 
    Write-Host " -------------------------------------------------------------------------" -ForegroundColor Green 
    Write-Host " $Section failed" -ForegroundColor Yellow
    Write-Host " Script will Stop and Not continue to Section 2.."-ForegroundColor Red
    Write-host "" 
    Write-Host " To solve this problem,install 7Zip" -ForegroundColor Yellow         
    Write-Host " -------------------------------------------------------------------------" -ForegroundColor Green
    
    # Mail Error, Stop logging and stop script
    Send-MailMessage -To $MailtoError -From $MailFrom -Subject $MailSubject -SmtpServer $MailSmtpServer -Body $EmailMessageError -Encoding ([System.Text.Encoding]::UTF8)
    CleanUpProcess
  } # Start Else,  If ( $TestPath7zip -Eq $True ) 

############################################################################################################################################


# Extract File that have Password protectection
  $Get7zipItems = Get-ChildItem -Path $PathToFiles -File -Force -Verbose -Filter *.7z
  foreach ($Item in $Get7zipItems) 
  { 
    # Extract zipfile
    Write-Host "Extract Zipfile $ZipGzFile..."
    $7ZipFile = $Item.FullName
    # Extract to Targetlocation
    Seven-Zip e "$7ZipFile" -aoa -p"$ZipPlainPassword" -o"$Targetlocation" 
  } 

############################################################################################################################################
 
 # Compress all txtfiles to archive zip
 $Get7zipItems = Get-ChildItem -Path $PathToFiles -Filter *.txt -Force -Verbose  
 ForEach ($Item in $Get7zipItems) 
 {  
    Write-host "Compress $($Item.Name) to $($PathToFiles)\$ZipfilenameTodaysDate.zip..."
    Seven-Zip a "$PathToFiles\$ZipfilenameTodaysDate.zip" "$PathToFiles\$($Item.Name)"
 } 


############################################################################################################################################

  $Get7zipItems = Get-ChildItem -Path $PathToFiles -Filter *.csv -Force -Verbose -Recurse  
  ForEach ($Item in $Get7zipItems) 
  { 
    Write-host "Compress $($Item.Name) to $($PathToFiles)\$ZipfilenameTodaysDate.zip..."
    Seven-Zip a -tzip "$PathToFiles\$ZipfilenameTodaysDate.zip" "$PathToFiles\$($Item.Name)"
  }
  
############################################################################################################################################ 


<#
<Commands>
  a : Add files to archive
  b : Benchmark
  d : Delete files from archive
  e : Extract files from archive (without using directory names)
  h : Calculate hash values for files
  i : Show information about supported formats
  l : List contents of archive
  rn : Rename files in archive
  t : Test integrity of archive
  u : Update files to archive
  x : eXtract files with full paths

<Switches>
  -- : Stop switches and @listfile parsing
  -ai[r[-|0]]{@listfile|!wildcard} : Include archives
  -ax[r[-|0]]{@listfile|!wildcard} : eXclude archives
  -ao{a|s|t|u} : set Overwrite mode
  -an : disable archive_name field
  -bb[0-3] : set output log level
  -bd : disable progress indicator
  -bs{o|e|p}{0|1|2} : set output stream for output/error/progress line
  -bt : show execution time statistics
  -i[r[-|0]]{@listfile|!wildcard} : Include filenames
  -m{Parameters} : set compression Method
    -mmt[N] : set number of CPU threads
    -mx[N] : set compression level: -mx1 (fastest) ... -mx9 (ultra)
  -o{Directory} : set Output directory
  -p{Password} : set Password
  -r[-|0] : Recurse subdirectories
  -sa{a|e|s} : set Archive name mode
  -scc{UTF-8|WIN|DOS} : set charset for console input/output
  -scs{UTF-8|UTF-16LE|UTF-16BE|WIN|DOS|{id}} : set charset for list files
  -scrc[CRC32|CRC64|SHA1|SHA256|*] : set hash function for x, e, h commands
  -sdel : delete files after compression
  -seml[.] : send archive by email
  -sfx[{name}] : Create SFX archive
  -si[{name}] : read data from stdin
  -slp : set Large Pages mode
  -slt : show technical information for l (List) command
  -snh : store hard links as links
  -snl : store symbolic links as links
  -sni : store NT security information
  -sns[-] : store NTFS alternate streams
  -so : write data to stdout
  -spd : disable wildcard matching for file names
  -spe : eliminate duplication of root folder for extract command
  -spf : use fully qualified file paths
  -ssc[-] : set sensitive case mode
  -sse : stop archive creating, if it can't open some input file
  -ssw : compress shared files
  -stl : set archive timestamp from the most recently modified file
  -stm{HexMask} : set CPU thread affinity mask (hexadecimal number)
  -stx{Type} : exclude archive type
  -t{Type} : Set type of archive
  -u[-][p#][q#][r#][x#][y#][z#][!newArchiveName] : Update options
  -v{Size}[b|k|m|g] : Create volumes
  -w[{path}] : assign Work directory. Empty path means a temporary directory
  -x[r[-|0]]{@listfile|!wildcard} : eXclude filenames
  -y : assume Yes on all queries

#>
