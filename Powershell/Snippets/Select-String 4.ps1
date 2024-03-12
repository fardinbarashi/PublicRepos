<#
This code searches with in several files. Wordobject need to be created to search within wordfiles.
Select-String if wordfile

#>
$FilePath = "C:\Temp\test"
$Keywords = "ABC"
$GetItems = Get-ChildItem -Path $FilePath -Recurse -Force
   if ($GetItems -Like "*.docx")
    { # Start if ($GetItems -Like "*.docx")
     $WordFile = New-Object -ComObject Word.Application
     $WordFile = Get-ChildItem -Path $FilePath -Recurse -Force | Where-Object {$_.Name -match '.docx'}
     Write-Host " - WordFiles -"
     Write-Host "File" $WordFile.FullName "contains $Keywords"
     Write-Host "----------------------------------------------"
    } # End if ($GetItems -Like "*.docx")
   if ($GetItems -NotLike "*.docx") 
    { # Start if ($GetItems -NotLike "*.docx") 
    $GetFiles = Get-ChildItem -Path $FilePath -Recurse -Force
    $GetFiles | Select-String -Pattern $Keywords
    Write-Host "----------------------------------------------"
    Write-Host " - Other Files -"
    Write-Host "File" $GetFiles.FullName "contains $Keywords"
    Write-Host ""

    } # Start    if ($GetItems -NotLike "*.docx")   





