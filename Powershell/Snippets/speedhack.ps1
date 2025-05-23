$Time = Measure-Command -Expression {
  $Files = Get-ChildItem -Path 'C:\Program Files' -Recurse -ErrorAction SilentlyContinue

  # Initialize an empty array
  $LastWriteTime = @()

  # Iterate through each file and add its LastWriteTime to the array
  foreach($File in $Files)
  {
    $LastWriteTime += $File.LastWriteTime  # Adding to the array using += is inefficient
  }
}

$Time.TotalSeconds  # Outputs the time taken for execution


$Time = Measure-Command -Expression {
  $Files = Get-ChildItem -Path 'C:\Program Files' -Recurse -ErrorAction SilentlyContinue

  # Initialize an empty array
  $LastWriteTime = @()

  # Use foreach to directly populate the array with values
  $LastWriteTime = foreach($File in $Files)
  {
    $File.LastWriteTime  # Directly output the LastWriteTime for each file
  }
}

$Time.TotalSeconds  # Outputs the time taken for execution