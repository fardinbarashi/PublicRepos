<#
System requirements
PSVersion                      5.1.19041.2364                                                                                                       
PSEdition                      Desktop                                                                                                              
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0}                                                                                              
BuildVersion                   10.0.19041.2364                                                                                                      
CLRVersion                     4.0.30319.42000                                                                                                      
WSManStackVersion              3.0                                                                                                                  
PSRemotingProtocolVersion      2.3                                                                                                                  
SerializationVersion           1.1.0.1      

About Script : 
Author : Fardin Barashi
Title : PasswordEncryptDecrypt
Description : A quick way to encrypt password and decrypt password
Version : 1.0
Release day : 2024-09-07
Github Link  : https://github.com/fardinbarashi

File can only be encrypt and decrypt with the user that you run this script with.

#>

#----------------------------------- Settings ------------------------------------------
# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

#----------------------------------- Start Script ------------------------------------------

# Region Sections Main Form Settings And Paths
# Contains Settings, Path To Xml File, Profile csv file, Transcripts logs 
 # Form Settings 
   $MainForm = New-Object System.Windows.Forms.Form  
   $MainForm.Text = "Password Encrypter 1.0" 
   $MainForm.StartPosition = "CenterScreen" 
   $MainForm.Topmost = $false 
   $MainForm.Size = "800,400" 
 # End Form Settings 

 
# Region Sections Top Bar Menu
#Contains Topmenustrip,Submenus,
 # Top Menu
   $TopMenuStrip = New-Object System.Windows.Forms.MenuStrip 
   $TopMenuStrip.Location = "0,0" 
   $TopMenuStrip.Name = "MainMenu" 
   $TopMenuStrip.Size = "780, 24" 
   $TopMenuStrip.Text = "Main" 
   $MainForm.Controls.Add($TopMenuStrip) 

 # Top Menu - Menu File
   $StripMenuFile = New-Object System.Windows.Forms.ToolStripMenuItem 
   $StripMenuFile.Name = "MenuFile"
   $StripMenuFile.Size = "40,20" 
   $StripMenuFile.Text = "File" 
   [void]$TopMenuStrip.Items.Add($StripMenuFile) 


 # Menu File - Sub Menu - Close
   $FileClose = New-Object System.Windows.Forms.ToolStripMenuItem
   $FileClose.Name = "MenuFileQuit"
   $FileClose.Size = '186, 22'
   $FileClose.Text = "Close"
   $FileClose.Add_Click({ Function-CloseForm })
   Function Function-CloseForm 
    { # Start Function Close-Form
              $MainForm.Close() 
    } # End Function Close-Form
   [void]$StripMenuFile.DropDownItems.Add($FileClose)
 # End Menu File - Sub Menu - Close




  # Top Menu - Menu Tools
   $StripMenuTools = New-Object System.Windows.Forms.ToolStripMenuItem 
   $StripMenuTools.Name = "MenuTools"
   $StripMenuTools.Size = "40,20" 
   $StripMenuTools.Text = "Decrypt File" 
   [void]$TopMenuStrip.Items.Add($StripMenuTools) 

   # Menu File - Sub Menu - ToolsDecryptFilePassword
   $ToolsDecryptFilePassword = New-Object System.Windows.Forms.ToolStripMenuItem
   $ToolsDecryptFilePassword.Name = "MenuFileQuit"
   $ToolsDecryptFilePassword.Size = '186, 22'
   $ToolsDecryptFilePassword.Text = "Select-File to Decrypt"
   $ToolsDecryptFilePassword.Add_Click({ Function-DecryptFilePassword })
    Function Function-DecryptFilePassword 
     { # Start Function-DecryptFilePassword 
      Try 
      { # Start Try
       # Open FileDialog
       $StatusBarPanel.Text = "Select File to decrypt..."
       $FileDialogFileBrowser = New-Object System.Windows.Forms.OpenFileDialog
       $FileDialogFileBrowser.ShowDialog()
       $FileToDecrypt = $FileDialogFileBrowser.FileName
        if ($FileToDecrypt) 
         { # Start if
          $GetPassword = Get-Content -Path $FileToDecrypt
          $GetSecurePassword = $GetPassword | ConvertTo-SecureString
          $GetSecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($GetSecurePassword))
          $StatusBarPanel.Text = "The Password is : $($GetSecurePassword) "
         } # End if
        else
        { # Start else
         $StatusBarPanel.Text = "No file selected."
        }# End else
      } # End Try

     Catch     
      { # Start Catch
      Get-Date -Format "yyyy/MM/dd HH:mm:ss"
      Write-Warning $Error[0]
      Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
      Stop-Transcript
      } # End Catch
     } # End Function-DecryptFilePassword  
   [void]$StripMenuTools.DropDownItems.Add($ToolsDecryptFilePassword)




 

# Region Sections Main Form - Context Menu Strip
    # Main Form - Context Menu Strip
    $ContextMenu = New-Object System.Windows.Forms.ContextMenuStrip
    $ContextMenu.Name = "ContextMenu"
    $ContextMenu.Size = "188, 114"
        
    # Main Form - StatusBar Settings
    $MainFormStatusBar = New-Object System.Windows.Forms.StatusBar
    $MainFormStatusBar.Anchor = "Bottom, Left, Right"
    $MainFormStatusBar.Dock = "None"
    $MainFormStatusBar.Location = "100,85"
    $MainFormStatusBar.Name = "StatusBar"
    $MainFormStatusBar.ShowPanels = $True
    $MainFormStatusBar.Size = "620, 20"
    $MainForm.Controls.Add($MainFormStatusBar)

    # StatusPanel
    $StatusBarPanel = New-Object System.Windows.Forms.StatusbarPanel
    $StatusBarPanel.AutoSize = "Spring"
    $StatusBarPanel.Name = "StatusBarPanel"
    $StatusBarPanel.Text = "Ready"
    $StatusBarPanel.Width = "620"
    [void]$MainFormStatusBar.Panels.Add($StatusBarPanel)

    # Main Form - PasswordField
    $MainFormTextBarPasswordField = New-Object System.Windows.Forms.Textbox
    $MainFormTextBarPasswordField.Location = "300,150"
    $MainFormTextBarPasswordField.Name = "MainFormTextBarPasswordField"
    $MainFormTextBarPasswordField.Size = "250, 20"
    $MainFormTextBarPasswordField.Text = "Type In Password that you want to encrypt"
    $MainForm.Controls.Add($MainFormTextBarPasswordField)
    
    # Main Form - SaveFileAs
    $MainFormTextbarSaveFileAs = New-Object System.Windows.Forms.Textbox
    $MainFormTextbarSaveFileAs.Location = "300,200"
    $MainFormTextbarSaveFileAs.Name = "MainFormTextbarSaveFileAs"
    $MainFormTextbarSaveFileAs.Size = "250, 20"
    $MainFormTextbarSaveFileAs.Text = "Type in FilePath ( C:\Temp\Password.txt )"
    $MainForm.Controls.Add($MainFormTextbarSaveFileAs)


    # Main Form - ExploreButton
    $MainFormButtonOpenExplorer = New-Object System.Windows.Forms.Button
    $MainFormButtonOpenExplorer.Location = "350,250"
    $MainFormButtonOpenExplorer.Name = "MainFormButtonOpenExplorer"
    $MainFormButtonOpenExplorer.Size = "120, 30"
    $MainFormButtonOpenExplorer.Text = "Open FileExplorer"
    $MainFormButtonOpenExplorer.Add_Click({ Function-OpenFileExplorer }) 
    $MainForm.Controls.Add($MainFormButtonOpenExplorer)
    Function Function-OpenFileExplorer 
     { # Start Function-OpenFileExplorer 
      Try 
      { # Start Try
       # Open FileDialog
       $FolderBrowserDialog = New-object System.Windows.Forms.FolderBrowserDialog
       $FolderBrowserDialog.ShowDialog() 
       $File = "\Password.txt"
       $MainFormTextbarSaveFileAs.Text = $FolderBrowserDialog.SelectedPath + $File
      } # End Try

     Catch     
      { # Start Catch
      Get-Date -Format "yyyy/MM/dd HH:mm:ss"
      Write-Warning $Error[0]
      Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
      Stop-Transcript
      } # End Catch
     } # End Function-OpenFileExplorer 


    # Main Form - SavePasswordButton
    $MainFormButtonSavePassWord = New-Object System.Windows.Forms.Button
    $MainFormButtonSavePassWord.Location = "335,300"
    $MainFormButtonSavePassWord.Name = "MainFormButtonSavePassWord"
    $MainFormButtonSavePassWord.Size = "150, 30"
    $MainFormButtonSavePassWord.Text = "Save Encrypt Password"
    $MainFormButtonSavePassWord.Add_Click({ Function-SavePassword }) 
    $MainForm.Controls.Add($MainFormButtonSavePassWord)
    Function Function-SavePassword 
     { # Start Function-SavePassword 
      Try 
      { # Start Try
       $StatusBarPanel.Text = "Encrypting Password 0%..."
       $SecurePassword = ConvertTo-SecureString -String $MainFormTextBarPasswordField.Text -AsPlainText -Force
       $EncryptedPassword = $SecurePassword | ConvertFrom-SecureString
       # Convert to a SecureString, crypt the string

       # Save in a textfile
       $EncryptedPassword | Out-File -FilePath $MainFormTextbarSaveFileAs.Text -Force
       Start-Sleep -Seconds 1
       $StatusBarPanel.Text = "Encrypting Password 100%..."
       Start-Sleep -Seconds 1
       $StatusBarPanel.Text = "Encrypting Password 100%... Saved Password to a file $($MainFormTextbarSaveFileAs.Text) "
      } # End Try

     Catch     
      { # Start Catch
      Get-Date -Format "yyyy/MM/dd HH:mm:ss"
      Write-Warning $Error[0]
      Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
      Stop-Transcript
      } # End Catch

     } # End Function-SavePassword 


# Region Section Mainform 
$MainForm.Add_Shown({$MainForm.Activate()})
[void] $MainForm.ShowDialog()
# End Region

 

 #----------------------------------- End Script ------------------------------------------