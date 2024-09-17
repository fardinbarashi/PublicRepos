# Check if string is null

$StringToCheck = ""
  
  If([string]::IsNullOrEmpty($StringToCheck))
      { 
       String is empty!
      }
Else 
 { 
  String is Not empty
 }