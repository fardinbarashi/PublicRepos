<#
This code searches with in several files. Wordobject need to be created to search within wordfiles.
Select-String if wordfile

#>
$FilePath = "C:\Temp\test"
$Keywords = "ABC"
$GetItems = Get-ChildItem -Path $FilePath -Recurse -Force
Foreach ( $Item in $GetItems ) 
 { 
  # Start Foreach ( $Item in $GetItems )    
   # Start If docx
   if ($Item -Like "*.docx")
    { # Start If docx 
     $WordFile = New-Object -ComObject Word.Application
     $WordFile = Get-ChildItem -Path $FilePath -Recurse -Force | Where-Object {$_.Name -match '.docx'}
     Write-Host $WordFile.FullName #contains $Keywords"
    } # End If docx  
   Else 
    { # Start Else 
    $GetFiles = Get-ChildItem -Path $FilePath -Recurse -Force
    $GetFiles | Select-String -Pattern $Keywords 
    } # Start Else  
 } # End Foreach ( $Item in $GetItems ) 




