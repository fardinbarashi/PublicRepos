# ServerNames
$Server1 = " Server 1"
$Server2 = " Server 2"
$Server3 = " Server 3"

# File And Folder Paths
$SourceFiles = ""
$Server2DestinationFiles = ""
$Server3DestinationFiles = ""

$TodaysDate = (Get-Date -Format yyyyMMdd)
$RegExPattern = "findthisfile"

# Import JSON-File for Reports 
$JsonFilePath = "$PSScriptRoot\Settings\config.json"
$jsonContent = Get-Content -Path $JsonFilePath -Raw -Encoding UTF8
$config = $jsonContent | ConvertFrom-Json
$fundsFromJson = $config.Fundings
$maxFunds = $config.Max.Funds
$maxFilesPerFund = $config.Max.Files
$maxTotalFiles = $config.Max.TotalMaxFiles

# HTML Path report
$HtmlReportFile = "$PSScriptRoot\files\HTML\Report$TodaysDate.html"

# --------------------------------------------- HTML START ------------------------------------------------
$HtmlReport = @"
<html>
<head>
    <meta charset='UTF-8'>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            font-family: Arial, sans-serif;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .green {
            color: green;
        }
        .red {
            color: red;
            font-weight: bold;
        }
        .summary {
            font-weight: bold;
        }
        .paragraph { 
                font-family: Arial, sans-serif; font-size: smaller;
            }
    </style>
</head>
<body>
    <h1>Compiled Report  $TodaysDate</h1>
    <p>This Report contains three tables with data about files from $Server1, $Server2, $Server3, .</p>
"@

# --------------------------------------------- TABLE 1 ---------------------------------------------
function Get-Table1($path) {
    $files = Get-ChildItem -Path $path -File
    $fundIDs = @()
    foreach ($file in $files) {
        if ($file.Name -match "^$RegExPattern\.(\d+)_") {
            $fundIDs += $matches[1]
        }
    }
    return ($fundIDs | Sort-Object -Unique).Count
}

$Server1FundCount = Get-Table1 -path $SourceFiles
$Server2FundCount = Get-Table1 -path $Server2DestinationFiles
$Server3FundCount = Get-Table1 -path $Server3DestinationFiles

$Server1FileCount = (Get-ChildItem -Path $SourceFiles -File).Count
$Server3FileCount = (Get-ChildItem -Path $Server2DestinationFiles -File).Count
$Server2FileCount = (Get-ChildItem -Path $Server3DestinationFiles -File).Count

function Format-Table1Cell {
    param (
        [int]$value,
        [int]$maxValue
    )
    if ($value -gt $maxValue) {
        return "<td style='background-color: yellow; font-weight: bold;'>$value</td>"
    } elseif ($value -lt $maxValue) {
        return "<td style='color: red; font-weight: bold;'>$value</td>"
    } else {
        return "<td style='color: green;'>$value</td>"
    }
}

# Format each cell for fund counts and file counts
$Server1FundCell = Format-Table1Cell -value $Server1FundCount -maxValue $maxFunds
$Server2FundCell = Format-Table1Cell -value $Server2FundCount -maxValue $maxFunds
$Server3FundCell = Format-Table1Cell -value $Server3FundCount -maxValue $maxFunds

$Server1FileCell = Format-Table1Cell -value $Server1FileCount -maxValue $maxTotalFiles
$Server2FileCell = Format-Table1Cell -value $Server2FileCount -maxValue $maxTotalFiles
$Server3FileCell = Format-Table1Cell -value $Server3FileCount -maxValue $maxTotalFiles

# Add Table 1 to the HTML
$HtmlReport += @"
<h2>Table 1: Summary of total number of funds per server and total number of files per server</h2>
<p class="paragraph">Green text: Approved value, correct number of files per fund per server | Red text: Not approved value, files are missing | Yellow background: There are more than 24 or 384 files</p>
<p class="paragraph">Total number of funds should be: $maxFunds | Number of files per server should be: $maxTotalFiles</p>

    <table>
        <tr>
            <th>Server</th>
            <th>Total Funds </th>
            <th>Total Files</th>
        </tr>
        <tr>
            <td>$Server1</td>
            $Server1FundCell
            $Server1FileCell
        </tr>
        <tr>
            <td>$Server2</td>
            $Server2FundCell
            $Server2FileCell
        </tr>
        <tr>
        <td>$Server3</td>
            $Server3FundCell
            $Server3FileCell
        </tr>		
    </table>
"@

# --------------------------------------------- TABLE 2: ---------------------------------------------
function Get-Table2($path) {
    $files = Get-ChildItem -Path $path -File
    $fundIDs = @()
    $fundIDCounts = @{}
    foreach ($file in $files) {
        if ($file.Name -match "$RegExPattern\.(\d+)_") {
            $fundID = $matches[1]
            $fundIDs += $fundID
            if ($fundIDCounts.ContainsKey($fundID)) {
                $fundIDCounts[$fundID] += 1
            } else {
                $fundIDCounts[$fundID] = 1
            }
        }
    }
    $HtmlTable2Output = @()
    foreach ($fundID in $fundIDCounts.Keys) {
        $HtmlTable2Output += [PSCustomObject]@{ 
            Fundings = $fundID
            Files = $fundIDCounts[$fundID]
        }
    }
    return $HtmlTable2Output
}

$SourceFilesStats = Get-Table2 -path $SourceFiles | Sort-Object {[int]$_.Fundings}
$Server2DestinationFilesStats = Get-Table2 -path $Server2DestinationFiles | Sort-Object {[int]$_.Fundings}
$Server3DestinationFilesStats = Get-Table2 -path $Server3DestinationFiles | Sort-Object {[int]$_.Fundings}

function Format-Table2Cell {
    param (
        [int]$value
    )
    if ($value -gt 16) {
        return "<td style='background-color: yellow; font-weight: bold;'>$value</td>"
    } elseif ($value -lt 16) {
        return "<td style='color: red; font-weight: bold;'>$value</td>"
    } else {
        return "<td style='color: green;'>$value</td>"
    }
}

$HtmlReport += @"
    <h2>Tabell 2: Files per Fundings and per Server</h2>
    <p class="paragraph">Green text: Approved value, correct number of files in the fund | Red text: Not approved value, files are missing in the fund | Yellow background: There are more than 16 files in this fund</p>
    <table>
        <tr>
            <th>Fundings ID</th>
            <th>$Server1</th>
            <th>$Server3</th>
            <th>$Server2</th>
        </tr>
"@

foreach ($SourceFile in $SourceFilesStats) {
    $fundID = $SourceFile.Fundings
    $Server3File = $Server3serverStats | Where-Object { $_.Fundings -eq $fundID }
    $targetFile = $TargetLocationStats | Where-Object { $_.Fundings -eq $fundID }
    $fundName = ($fundsFromJson | Where-Object { $_.FundID -eq $fundID }).FundName
    $Server1Cell = Format-Table2Cell -value $SourceFile.Files
    $Server2Cell = Format-Table2Cell -value $Server2File.Files
    $Server3Cell = Format-Table2Cell -value $Server3File.Files	

    $HtmlReport += @"
        <tr>
            <td>Fundings $fundID - $fundName</td>
            $Server1Cell
            $Server3Cell
            $Server2Cell
        </tr>
"@
}

$HtmlReport += "</table>"

# --------------------------------------------- TABLE 3:  ---------------------------------------------
function Get-Table3 {
    param (
        [string]$SourceFiles,
        [string]$Server2DestinationFiles,
        [string]$Server3DestinationFiles,
        [string]$JsonFilePath
    )
    $config = Get-Content -Path $JsonFilePath -Raw -Encoding UTF8 | ConvertFrom-Json
    $fundsFromJson = $config.Fundings
    $Server1SourceFilesList = Get-ChildItem -Path $SourceFiles -File | Select-Object -ExpandProperty Name
    $HtmlTable3Output = @()
    foreach ($file in $Server1SourceFilesList) {
        if ($file -match "^$RegExPattern\.(\d+)_") {
            $fundID = $matches[1]
            $fundName = ($fundsFromJson | Where-Object { $_.FundID -eq $fundID }).FundName
            $Server1Exists = Test-Path "$SourceFiles\$file"
            $Server2Exists = Test-Path "$Server2DestinationFiles\$file"
            $Server3Exists = Test-Path "$Server3DestinationFiles\$file"			
            $HtmlTable3Output += [PSCustomObject]@{
                FileName = $file
                Fundings = $fundName
                Server1 = if ($Server1Exists) { "Yes" } else { "No" }
                Server2 = if ($Server2Exists) { "Yes" } else { "No" }
                Server3 = if ($Server3Exists) { "Yes" } else { "No" }				
            }
        }
    }
    return $HtmlTable3Output
}

$Table3Data = Get-Table3 -SourceFiles $SourceFiles -Server2DestinationFiles $Server2DestinationFiles -Server3DestinationFiles $Server3DestinationFiles -JsonFilePath $JsonFilePath

$HtmlReport += @"
    <h2>Tabell 3: Filestatus per Server</h2>
    <p class="paragraph">Green text: Approved value, the file exists on the server | Red text: Not approved value, the file is missing on the server</p>´
    <table>
        <tr>
            <th>FileName</th>
            <th>Fundings</th>
            <th>Server1</th>
            <th>Server2</th>
            <th>Server3</th>
        </tr>
"@

foreach ($row in $Table3Data) {
    $Server1Cell = if ($row.Server1 -eq "Yes") { "<td class='green'>Yes</td>" } else { "<td class='red'>No</td>" }
    $Server2Cell = if ($row.Server2 -eq "Yes") { "<td class='green'>Yes</td>" } else { "<td class='red'>No</td>" }
    $Server3Cell = if ($row.Server3 -eq "Yes") { "<td class='green'>Yes</td>" } else { "<td class='red'>No</td>" }	

    $HtmlReport += @"
        <tr>
            <td>$($row.FileName)</td>
            <td>$($row.Fundings)</td>
            $Server1Cell
            $Server3Cell
            $Server2Cell
        </tr>
"@
}

$HtmlReport += "</table>"

# --------------------------------------------- SAVE THE FINAL REPORT ---------------------------------------------
$HtmlReport += "</body></html>"

# Save HTML report
$HtmlReport | Out-File -FilePath $HtmlReportFile -Encoding utf8 -Verbose

