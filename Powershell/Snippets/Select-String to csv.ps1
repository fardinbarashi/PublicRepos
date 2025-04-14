$FilePath = ""
$Keywords = "Koroma"


$GetItems = Get-ChildItem -Path $FilePath -Recurse -Force


$Results = $GetItems | Select-String -Pattern $Keywords | ForEach-Object {
    [PSCustomObject]@{
        Filename   = $_.Path
        LineNumber = $_.LineNumber
        LineText   = $_.Line
    }
}


$Results | Export-Csv "$PSScriptRoot\SearchAfter_$($Keywords).csv" -Force -Encoding UTF8 -NoTypeInformation
