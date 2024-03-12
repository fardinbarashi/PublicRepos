# ADFS export metadata to file on desktop
$mdbUrl = (Get-ADFSEndpoint | where-object {$_.Protocol -eq "Federation Metadata"}).FullUrl.ToString()
$httpHelper = new-object System.Net.WebClient
$metadataAsString = $httpHelper.DownloadString($mdbUrl)
$httpHelper.DownloadFile($mdbUrl , "C:\Users\$($env:username)\Desktop\metadata.xml")
