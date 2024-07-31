
  $ScriptName = $MyInvocation.MyCommand.Name
  $TranScriptLogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
  $TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $TranScriptLogFileDate.Txt" 
  $StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
