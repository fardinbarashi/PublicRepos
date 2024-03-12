<#
This code searches with in several files. Wordobject need to be created to search within wordfiles.
Select-String if wordfile

#>

$FilePath = "C:\Temp\test"
$Keywords = "ABC"
$GetItems = Get-ChildItem -Path $FilePath -Recurse -Force
Foreach ( $Item in $GetItems ) 
{ # Start Foreach ( $Item in $GetItems ) 

# Start If PDF
if ($Item -Like "*.PDF")
{ # Start If PDF 
    $PDF = Get-ChildItem -Path $FilePath -Recurse -Force
    $PDF | Select-String -Pattern $Keywords
} # End If PDF  

# Start If docx
if ($Item -Like "*.docx")
{ # Start If docx 
    $WordFile = New-Object -ComObject Word.Application
    $WordFile = Get-ChildItem -Path $FilePath -Recurse -Force | Where-Object {$_.Name -match '.docx'}

    Write-Host $WordFile.FullName #contains $Keywords"
} # End If docx  

} # End Foreach ( $Item in $GetItems ) 


