function Invoke-ScriptBlockWithRetries {
  [CmdletBinding(DefaultParameterSetName = 'RetryNonTerminatingErrors')]
  param (
    [Parameter(Mandatory = $true, HelpMessage = "The script block to execute.")]
    [ValidateNotNull()]
    [scriptblock] $ScriptBlock,

    [Parameter(Mandatory = $false, HelpMessage = "The maximum number of times to attempt the script block when it returns an error.")]
    [ValidateRange(1, [int]::MaxValue)]
    [int] $MaxNumberOfAttempts = 5,

    [Parameter(Mandatory = $false, HelpMessage = "The number of milliseconds to wait between retry attempts.")]
    [ValidateRange(1, [int]::MaxValue)]
    [int] $MillisecondsToWaitBetweenAttempts = 3000,

    [Parameter(Mandatory = $false, HelpMessage = "If true, the number of milliseconds to wait between retry attempts will be multiplied by the number of attempts.")]
    [switch] $ExponentialBackoff = $false,

    [Parameter(Mandatory = $false, HelpMessage = "List of error messages that should not be retried. If the error message contains one of these strings, the script block will not be retried.")]
    [ValidateNotNull()]
    [string[]] $ErrorsToNotRetry = @(),

    [Parameter(Mandatory = $false, ParameterSetName = 'IgnoreNonTerminatingErrors', HelpMessage = "If true, only terminating errors (e.g. thrown exceptions) will cause the script block will be retried. By default, non-terminating errors will also trigger the script block to be retried.")]
    [switch] $DoNotRetryNonTerminatingErrors = $false,

    [Parameter(Mandatory = $false, ParameterSetName = 'RetryNonTerminatingErrors', HelpMessage = "If true, any non-terminating errors that occur on the final retry attempt will not be thrown as a terminating error.")]
    [switch] $DoNotThrowNonTerminatingErrors = $false
  )

  [int] $numberOfAttempts = 0
  while ($true) {
    try {
      Invoke-Command -ScriptBlock $ScriptBlock -ErrorVariable nonTerminatingErrors

      if ($nonTerminatingErrors -and (-not $DoNotRetryNonTerminatingErrors)) {
        throw $nonTerminatingErrors
      }

      break # Break out of the while-loop since the command succeeded.
    } catch {
      [bool] $shouldRetry = $true
      $numberOfAttempts++

      [string] $errorMessage = $_.Exception.ToString()
      [string] $errorDetails = $_.ErrorDetails
      Write-Verbose "Attempt number '$numberOfAttempts' of '$MaxNumberOfAttempts' failed.`nError: $errorMessage `nErrorDetails: $errorDetails"

      if ($numberOfAttempts -ge $MaxNumberOfAttempts) {
        $shouldRetry = $false
      }

      if ($shouldRetry) {
        # If the errorMessage contains one of the errors that should not be retried, then do not retry.
        foreach ($errorToNotRetry in $ErrorsToNotRetry) {
          if ($errorMessage -like "*$errorToNotRetry*" -or $errorDetails -like "*$errorToNotRetry*") {
            Write-Verbose "The string '$errorToNotRetry' was found in the error message, so not retrying."
            $shouldRetry = $false
            break # Break out of the foreach-loop since we found a match.
          }
        }
      }

      if (-not $shouldRetry) {
        [bool] $isNonTerminatingError = $_.TargetObject -is [System.Collections.ArrayList]
        if ($isNonTerminatingError -and $DoNotThrowNonTerminatingErrors) {
          break # Just break out of the while-loop since the error was already written to the error stream.
        } else {
          throw # Throw the error so it's obvious one occurred.
        }
      }

      [int] $millisecondsToWait = $MillisecondsToWaitBetweenAttempts
      if ($ExponentialBackoff) {
        $millisecondsToWait = $MillisecondsToWaitBetweenAttempts * $numberOfAttempts
      }
      Write-Verbose "Waiting '$millisecondsToWait' milliseconds before next attempt."
      Start-Sleep -Milliseconds $millisecondsToWait
    }
  }
}