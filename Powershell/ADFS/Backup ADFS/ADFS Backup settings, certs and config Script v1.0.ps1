<#
System requirements
PSVersion                      5.1.19041.2364                                                                                                       
PSEdition                      Desktop                                                                                                              
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}                                                                                              
BuildVersion                   10.0.19041.2364                                                                                                      
CLRVersion                     4.0.30319.42000                                                                                                      
WSManStackVersion              3.0                                                                                                                  
PSRemotingProtocolVersion      2.3                                                                                                                  
SerializationVersion           1.1.0.1      

About Script : T
Author : Fardin Barashi
Title : Backup ADFS config and settings
Description : A script that saves config and settings files. IF private keys are not exporatble, it will fail on the last step.
the steps are proccessed from 
https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/deployment/prepare-to-migrate-a-stand-alone-ad-fs-federation-server#step-1-export-service-settings

Version : 1.0
Release day : 2023-10-31
Github Link  : https://github.com/fardinbarashi
News : 
#>



#----------------------------------- Settings ------------------------------------------
# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# Error-Settings
$ErrorActionPreference = 'Continue'
#----------------------------------- Start Script ------------------------------------------

# Section 1 : Create Folders
$Section = "Section 1 : Create Folders"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
  # Check if folders exist else create
  $Folders = @("$PSScriptRoot\Files\SystemInfo", 
  "$PSScriptRoot\Files\AdfsConfigurations",
  "$PSScriptRoot\Files\AdfsCertificateType",
  "$PSScriptRoot\Files\AdfsIisWeb",
  "$PSScriptRoot\Files\AdfsRelyingPartyTrusts"
  )

 # Loop
 foreach ($Folder in $Folders) {
   if (-not (Test-Path $Folder -PathType Container)) 
    {
       New-Item -ItemType Directory -Path $Folder
        Write-Host "Created $Folder"
    }
    else 
    {
        Write-Host "$Folder already exist"
    }
} 


 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

# Section 2 : Save Systeminfo files
$Section = "Section 2 : Save Systeminfo files"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

   # Run Query
    # Export Computer and System info
   Get-ComputerInfo -Property WindowsBuildLabEx,WindowsEditionID | 
   Out-File -FilePath “$PSScriptRoot\Files\SystemInfo\ComputerInfo.txt” -Verbose -Force
   
   systeminfo.exe | 
   Out-File -FilePath “$PSScriptRoot\Files\SystemInfo\systeminfo.txt” -Verbose -Force

   ipconfig /all | 
   Out-File -FilePath “$PSScriptRoot\Files\SystemInfo\ipconfig.txt” -Verbose -Force
  
 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

# Section 3 : Export ADFS configurations files
$Section = "Section 3 : Export ADFS configurations files"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

   # Run Query 
    # Export ADFS Configurations
     Get-ADFSProperties -Verbose | 
     Out-File “$PSScriptRoot\Files\AdfsConfigurations\AdfsProperties.txt” -Verbose 

     Get-ADFSClaimsProviderTrust -Verbose |
     Out-File “$PSScriptRoot\Files\AdfsConfigurations\AdfsClaimsProviderTrust.txt” -Verbose

     Get-ADFSRelyingPartyTrust -Verbose |
     Out-File “$PSScriptRoot\Files\AdfsConfigurations\AdfsRelyingPartyTrust.txt” -Verbose

     Get-ADFSAttributeStore -Verbose |
     Out-File “$PSScriptRoot\Files\AdfsConfigurations\AdfsAttributeStore.txt” -Verbose

     Get-ChildItem -Path "C:\Windows\ADFS\Microsoft.IdentityServer.Servicehost.exe.config" -Force |
     Copy-Item -Destination "$PSScriptRoot\Files\AdfsConfigurations\" -Force

     Get-ADFSCertificate -Verbose | 
     Out-File “$PSScriptRoot\Files\AdfsConfigurations\AdfsCertificate.txt” -Verbose

     Get-ADFSRelyingPartyTrust -Verbose | 
     Export-Clixml -Path "$PSScriptRoot\Files\ÁdfsRelyingPartyTrusts\AdfsRelyingPartyTrusts.xml"


     #  Export metadata
     $MetaDataUrl = (Get-ADFSEndpoint | where-object {$_.Protocol -eq "Federation Metadata"}).FullUrl.ToString()
     $HttpHelper = new-object System.Net.WebClient
     $MetadataAsString = $HttpHelper.DownloadString($MetaDataUrl)
     $HttpHelper.DownloadFile($MetaDataUrl , "$PSScriptRoot\Files\AdfsConfigurations\metadata.xml")  
  
 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

#  Section 4 : Check if IIS-role is installed to export the ADFS IIS Site
$Section = "Section 4 : Check if IIS-role is installed, copy  ADFS IIS Site files"
Try
{
    # Start Try, $Section
    Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    Write-Host $Section... "0%" -ForegroundColor Yellow


   # Run Query 
   $CheckIISInstalled = Get-WindowsFeature | Where-Object { $_.Name -eq "Web-Server" -and $_.InstallState -eq "Installed" }

   if ($CheckIISInstalled) 
    {
     Write-Host "IIS is installed. Copying files..."
     Get-Childitem -Path "%systemdrive%\inetpub\adfs\ls" -Recurse -Force -Verbose | 
     Copy-Item -Destination "$PSScriptRoot\Files\IisWeb" -Recurse -Force -Verbose
    } 
   else 
    {
     Write-Host "IIS is not installed."
    }

    Write-Host ""
} # End Try


Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

# Section End : Export ADFS CertificateType
$Section = "Section End : Export ADFS CertificateType"
Try
{
    # Start Try, $Section
    Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    Write-Host $Section... "0%" -ForegroundColor Yellow

    # Export ADFS-CertificateType Password
    $SecurePassword = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force

   # Run Query 
    # Export ADFS-CertificateType
    $GetAdfsCertificateServiceCommunicationspfx = Get-AdfsCertificate -CertificateType Service-Communications -Verbose 
    $CertPathServiceCommunications = "cert:\LocalMachine\My\{0}" -f $GetAdfsCertificateServiceCommunicationspfx.Thumbprint
    Write-Host "Service-Communications Thumbprint: $($GetAdfsCertificateServiceCommunicationspfx.Thumbprint)"
    if (-not (Test-Path $CertPathServiceCommunications)) 
     {
      Write-Host "Certificate $CertPathServiceCommunications does not exist!"
     } 
    else 
     {
      Export-PfxCertificate -cert $CertPathServiceCommunications -FilePath “$PSScriptRoot\Files\AdfsCertificateType\Service-Communications.pfx" -Password $SecurePassword -Verbose
     }

    $GetAdfsCertificateTokenSign = Get-AdfsCertificate -CertificateType Token-Signing -Verbose
    $CertPathTokenSigning = "cert:\LocalMachine\My\{0}" -f $GetAdfsCertificateTokenSign.Thumbprint
    Write-Host "Token-Signing Thumbprint: $($GetAdfsCertificateTokenSign.Thumbprint)"
    if (-not (Test-Path $CertPathTokenSigning)) 
    {
      Write-Host "Certificate $CertPathTokenSigning does not exist!"
    } 
   else 
    {
      Export-PfxCertificate -cert $CertPathTokenSigning -FilePath “$PSScriptRoot\Files\AdfsCertificateType\Token-Signing.pfx" -Password $SecurePassword -Verbose
    }

    $GetAdfsCertificateTokenDecrypt = Get-AdfsCertificate -CertificateType Token-Decrypting -Verbose
    $CertPathTokenDecrypting = "cert:\LocalMachine\My\{0}" -f $GetAdfsCertificateTokenDecrypt.Thumbprint
    Write-Host "Token-Decrypting Thumbprint: $($GetAdfsCertificateTokenDecrypt.Thumbprint)"
    if (-not (Test-Path $CertPathTokenDecrypting))
    {
      Write-Host "Certificate $CertPathTokenDecrypting does not exist!"
    } 
   else 
    {
      Export-PfxCertificate -cert $CertPathTokenDecrypting -FilePath “$PSScriptRoot\Files\AdfsCertificateType\Token-Decrypting.pfx" -Password $SecurePassword -Verbose
    }

    Write-Host ""
} # End Try


Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch



# Get-Childitem -path "%systemdrive%\inetpub\adfs\ls" -Recurse -Force -Verbose | Copy-Item -Path "SourcePath" -Destination "DestinationPath" -Recurse -Verbose


#----------------------------------- End Script ------------------------------------------
Stop-Transcript
