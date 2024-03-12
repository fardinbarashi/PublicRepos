# SQL Settings 
$SQLInstance = ".\SQLEXPRESS"
$SQLDatabase = "DATABASENAME"
$SQLTable = "SQLTABLE"

$ImportCsvToSqlCsvFile = "FILEPATH\ImportCsvFileToSql.Csv"


 Start-Transcript -Path "$PSScriptRoot\TranscriptSqlLog.txt" -Force

  Try
 { # Start Try,  
   # Import Csv to database
   $ImportCsvToSqlCsvFile = Import-Csv -path $ImportCsvToSqlCsvFile -Delimiter "," -Encoding UTF8
   ForEach ($CsvColumn in $ImportCsvToSqlCsvFile) 
    { # Start ForEach 
      # Create String for CSV Column in csv file
      $CsvColumnID = $CsvColumn.id
      $CsvColumn1 = $CsvColumn.Column1 # Column1 in the csv file
      $CsvColumn2 = $CsvColumn.Column2 # Column2 in the csv file
      $CsvColumn3 = $CsvColumn.Column3 # Column3 in the csv file
      $CsvColumn4 = $CsvColumn.Column4 # Column4 in the csv file
      $CsvColumn5 = $CsvColumn.Column5 # Column5 in the csv file


      # Insert in database
      $SQLInsert = "USE $SQLDatabase
      INSERT INTO $SQLTable (id, Column1, Column2, Column3, Column4, Column5 )
      VALUES('$CsvColumnID', $CsvColumn1', '$CsvColumn2', '$CsvColumn3', '$CsvColumn4', '$CsvColumn5' );"
      # Running the INSERT Query
      Invoke-SQLCmd -Query $SQLInsert -ServerInstance $SQLInstance

    } # End ForEach 
 
 } # End Try,

 Catch
 { # Start Catch
 Write-Warning -Message "Could not get import $ImportCsvToSqlCsvFile to SQL "
 Write-Warning $Error[0]
 } # End Catch




 Stop-Transcript
