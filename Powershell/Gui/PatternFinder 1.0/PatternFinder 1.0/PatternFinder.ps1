<#
.Synopsis
.DESCRIPTION
 Patternfinder is a tool written in Powershell to be able to fastsearch for files with a certain word.
 Patternfinder use cmd Select-String to populate the listview.
.EXAMPLE
 1.Browse for a folder
 2.Optional Select filetype
 3.Enter word to search for and press search.
 
 The listview is going to be populated with the query.
 The listview is going to have a CMS menu

.NOTES
   Mail : Fardin.barashi@gmail.com
   Github : https://github.com/fardinbarashi/Patternfinder
   Github Profile : https://github.com/fardinbarashi/
#>

# Net Assembly
 [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing");
 [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");
 [void] [System.Reflection.Assembly]::LoadWithPartialName("presentationframework");
 [void] [System.Windows.Forms.Application]::EnableVisualStyles();

# Start Filepath
$CsvFileType = "$PSScriptRoot\Files\Csv\FileType.csv" # FileTypes
$Logfile = "$PSScriptRoot\Files\Logs\Logfile.txt" # Logfile To transcript
$XMLFile = "$PSScriptRoot\Files\ListviewColumn\Columns.xml" # XML Column File to Listview
[XML]$Script:XML = Get-Content $XMLFile
$FilesSearchCsv = "$PSScriptRoot\Files\ListviewData\ListViewData.csv" # FileSearch Query
$FaqFile = "$PSScriptRoot\Files\Help\Faq.txt"

# End FilePath
# Start FunctionList
# Add columns to the ListView
Function Add-Columns {

#$lvMain.Columns.Add($Filename)
$ColumnFileAttribute = New-Object System.Windows.Forms.ColumnHeader
$ColumnFileAttribute.name = "File-Attribute"
$ColumnFileAttribute.Text = "File-Attribute"
$LvMain.Columns.Add($ColumnFileAttribute)  | Out-Null

$ColumnFileValue = New-Object System.Windows.Forms.ColumnHeader
$ColumnFileValue.name = "Value"
$ColumnFileValue.Text = "Value"
$LvMain.Columns.Add($ColumnFileValue)  | Out-Null }
# Size Option Columns
Function Change-Size-Columns {

$LvMain.Columns | %{$_.Width = -1}}
# Import SearchQuerieCsv to Listview
Function Import-ExportFileSearchCsv {

$StartItem = New-Object System.Windows.Forms.ListViewItem(" Start - File Attribute " )
$StartItem.BackColor = "Black"
$StartItem.ForeColor = "White"
$LvMain.Items.Add($StartItem)                   
$Item = New-Object System.Windows.Forms.ListViewItem(" FileName :")
$Item.SubItems.Add($_.Filename) 
$LvMain.Items.Add($Item)                                             
$Item = New-Object System.Windows.Forms.ListViewItem(" Path :")
$Item.SubItems.Add($_.Path) 
$LvMain.Items.Add($Item)
$Item = New-Object System.Windows.Forms.ListViewItem(" LineNumber :")
$Item.SubItems.Add($_.LineNumber) 
$LvMain.Items.Add($Item)                            
$EndItem = New-Object System.Windows.Forms.ListViewItem(" End - File Attribute ")
$EndItem.BackColor = "Red"
$EndItem.ForeColor = "Black"
$LvMain.Items.Add($EndItem)

}

# Clear out Listview
Function Clear-Listview {
$LvMain.Items.Clear()
$LvMain.Columns.Clear()}
# Update-ContextMenu 
Function Update-ContextMenu{
Param($Vis)		
Get-Variable Cms* | %{Try{$_.Value.Visible = $False}Catch{}}
$Vis | %{Try{$_.Value.Visible = $True}Catch{}}} # End Update-ContextMenu

Function Remove-TemporyFiles{
Remove-Item -Path $CsvFileType
Remove-Item -Path $FilesSearchCsv
Clear-Listview
} # End Remove-TemporyFiles

# End Functionlist

 # Main Form - Context Menu Strip
$LvMainContextMenu = New-Object System.Windows.Forms.ContextMenuStrip
$LvMainContextMenu.Name = "LvMainContextMenu"
$LvMainContextMenu.Size = "188, 114"
# Sub Menu cmsOpenFilesFolders
$cmsOpenFileLocation = New-Object System.Windows.Forms.ToolStripMenuItem
$cmsOpenFileLocation.Name = "cmsOpenFileLocation"
$cmsOpenFileLocation.Size = "187, 22"
$cmsOpenFileLocation.Text = "Open File-Location"
$cmsOpenFileLocation.Visible = $False
$cmsOpenFileLocation.Add_Click({cmsOpenFileLocation})
function cmsOpenFileLocation  { # Start Function
 foreach ( $Item in $Lvmain.SelectedItems) { # Start Foreach			 
 $SelectedItemPath =  $item.subitems[1].text
 $SelectedItemPathRemoveLastPart =  Split-Path -Path $SelectedItemPath -Parent 
 Start-Process -FilePath $SelectedItemPathRemoveLastPart} # End Foreach
 } # Start Function
[void]$LvMainContextMenu.Items.Add($cmsOpenFileLocation)


# Sub Menu cmsOpenFile
$cmsOpenFile = New-Object System.Windows.Forms.ToolStripMenuItem
$cmsOpenFile.Name = "cmsOpenFile"
$cmsOpenFile.Size = "187, 22"
$cmsOpenFile.Text = "Open File"
$cmsOpenFile.Visible = $False
$cmsOpenFile.Add_Click({cmsOpenFile})
function cmsOpenFile  { # Start Function 
 foreach ( $Item in $Lvmain.SelectedItems) { # Start Foreach
 $SelectedItemPath =  $item.subitems[1].text
 Start-Process -FilePath $SelectedItemPath 
 } # End Foreach
} # End Function
[void]$LvMainContextMenu.Items.Add($cmsOpenFile)

# Sub Menu cmsDeleteFile
$cmsDeleteFile = New-Object System.Windows.Forms.ToolStripMenuItem
$cmsDeleteFile.Name = "cmsDeleteFile"
$cmsDeleteFile.Size = "187, 22"
$cmsDeleteFile.Text = "Delete File"
$cmsDeleteFile.Visible = $False
$cmsDeleteFile.Add_Click({cmsDeleteFile})
function cmsDeleteFile{ # Start cmsDeleteFile
$statusPanel.Text = "Confirm delete file" 
 # ConfirmationForm Start
 $ConfirmationFormDelete = New-Object System.Windows.Forms.Form  
 $ConfirmationFormDelete.Text = "Confirmation Box" 
 $ConfirmationFormDelete.StartPosition = "CenterScreen"
 $ConfirmationFormDelete.Topmost = $false
 $ConfirmationFormDelete.Size = "350,150" 
 $ConfirmationFormDeleteIcon = "$PSScriptRoot\Files\logo\Logo.ico"
 $ConfirmationFormDelete.Icon = New-Object system.drawing.icon ("$ConfirmationFormDeleteIcon ") 

 # Label Confirmation Text 
 $ConfirmationFormDeleteLabel = New-Object System.Windows.Forms.Label
 $ConfirmationFormDeleteLabel.Location = "65,20"
 $ConfirmationFormDeleteLabel.Size = "300,20"
 $ConfirmationFormDeleteLabel.Text  = "Are you sure that you want to remove file"
 $ConfirmationFormDelete.Controls.Add($ConfirmationFormDeleteLabel)

 # ConfirmationForm - Button No
 $ConfirmationFormDeleteButtonNo = New-object System.Windows.Forms.Button
 $ConfirmationFormDeleteButtonNo.Text= "No"
 $ConfirmationFormDeleteButtonNo.Location = "65,60"
 $ConfirmationFormDeleteButtonNo.Size = "70,20"
 $ConfirmationFormDeleteButtonNo.Add_Click({ ConfirmationFormDeleteButtonNo })
 Function ConfirmationFormDeleteButtonNo { # Start Function
 $ConfirmationFormDelete.Close() 
 $statusPanel.Text = "https://github.com/fardinbarashi"
 } # End Function   
 $ConfirmationFormDelete.Controls.Add($ConfirmationFormDeleteButtonNo)

 # ConfirmationForm - Button Yes
 $ConfirmationFormDeleteButtonYes = New-object System.Windows.Forms.Button
 $ConfirmationFormDeleteButtonYes.Text= "Yes"
 $ConfirmationFormDeleteButtonYes.Location = "200,60"
 $ConfirmationFormDeleteButtonYes.Size = "70,20"
 $ConfirmationFormDeleteButtonYes.Add_Click({ ConfirmationFormDeleteButtonYes })
 Function ConfirmationFormDeleteButtonYes { # Start ConfirmationFormDeleteButtonYes
  $statusPanel.Text = "File deleted"
  $ConfirmationFormDelete.Close()   
  foreach ( $Item in $Lvmain.SelectedItems) { # Start Foreach
  $SelectedItemPath =  $item.subitems[1].text
  Remove-Item -Path $SelectedItemPath -Force
  FunctionSearch 
 } # End Foreach
  $statusPanel.Text = "https://github.com/fardinbarashi"
 } # End ConfirmationFormDeleteButtonYes
 $ConfirmationFormDelete.Controls.Add($ConfirmationFormDeleteButtonYes)
 $ConfirmationFormDelete.Add_Shown({$ConfirmationFormDelete.Activate()})
 [void] $ConfirmationFormDelete.ShowDialog() # ConfirmationForm End
 } # End cmsDeleteFile    
[void]$LvMainContextMenu.Items.Add($cmsDeleteFile)

# Sub Menu cmsClearListview
$cmsClearListview = New-Object System.Windows.Forms.ToolStripMenuItem
$cmsClearListview.Name = "cmsClearListview"
$cmsClearListview.Size = "187, 22"
$cmsClearListview.Text = "Clear Listview"
$cmsClearListview.Visible = $False
$cmsClearListview.Add_Click({cmsClearListview})
function cmsClearListview  { # Start Function 
Clear-Listview 
} # End Function
[void]$LvMainContextMenu.Items.Add($cmsClearListview)


# End FilePath
Start-Transcript -Path $Logfile -Force -Append
# Start Application Settings
 $ApplicationForm = New-Object System.Windows.Forms.Form
 $ApplicationVersion = "V 1.0"
 $ApplicationTitle = "Pattern Finder - "
 $ApplicationForm.Text = "$ApplicationTitle $ApplicationVersion"
 $ApplicationForm.StartPosition = "CenterScreen"
 $ApplicationForm.Topmost = $false
 $ApplicationForm.Size = "1050,800"
 $ApplicationIconPath = "$PSScriptRoot\Files\logo\Logo.ico"
 $ApplicationForm.Icon = New-Object system.drawing.icon ("$ApplicationIconPath ")
 # End Application Settings

# Start Application Top Menu
 $ApplicationFormMenuStrip = New-Object System.Windows.Forms.MenuStrip
 $ApplicationFormMenuStrip.Location = "0, 0"
 $ApplicationFormMenuStrip.Name = "MainMenu"
 $ApplicationFormMenuStrip.Size = "780, 24"
 $ApplicationFormMenuStrip.Text = "Main"
 $ApplicationForm.Controls.Add($ApplicationFormMenuStrip)
# Start Menu File
 $ApplicationFormMenuStripFile = New-Object System.Windows.Forms.ToolStripMenuItem
 $ApplicationFormMenuStripFile.Name = "MenuFile"
 $ApplicationFormMenuStripFile.Size = "37, 20"
 $ApplicationFormMenuStripFile.Text = "File"
 [void]$ApplicationFormMenuStrip.Items.Add($ApplicationFormMenuStripFile)

 $ApplicationFormMenuStripFileExit = New-Object System.Windows.Forms.ToolStripMenuItem
 $ApplicationFormMenuStripFileExit.Name = "MenuFileExit"
 $ApplicationFormMenuStripFileExit.Size = "186, 22"
 $ApplicationFormMenuStripFileExit.Text = "Exit"
 $ApplicationFormMenuStripFileExit.Add_Click({$ApplicationForm.Close()})
[void]$ApplicationFormMenuStripFile.DropDownItems.Add($ApplicationFormMenuStripFileExit)
# End Menu File

# Start Menu Edit
 $ApplicationFormMenuStripEdit = New-Object System.Windows.Forms.ToolStripMenuItem
 $ApplicationFormMenuStripEdit.Name = "MenuEdit"
 $ApplicationFormMenuStripEdit.Size = "37, 20"
 $ApplicationFormMenuStripEdit.Text = "Edit"
 [void]$ApplicationFormMenuStrip.Items.Add($ApplicationFormMenuStripEdit)

 $ApplicationFormMenuStripEditRemovetemporyfiles = New-Object System.Windows.Forms.ToolStripMenuItem
 $ApplicationFormMenuStripEditRemovetemporyfiles.Name = "ApplicationFormMenuStripEditRemovetemporyfiles"
 $ApplicationFormMenuStripEditRemovetemporyfiles.Size = "186, 22"
 $ApplicationFormMenuStripEditRemovetemporyfiles.Text = "Remove tempory files"
 $ApplicationFormMenuStripEditRemovetemporyfiles.Add_Click({ # Start Function
 $statusPanel.Text = "Removing tempory files"
 Remove-TemporyFiles
 $statusPanel.Text = "https://github.com/fardinbarashi"
 }) #  End Function
 [void]$ApplicationFormMenuStripEdit.DropDownItems.Add($ApplicationFormMenuStripEditRemovetemporyfiles)
# End Menu Edit

# Start Menu Help
 $ApplicationFormMenuStripHelp = New-Object System.Windows.Forms.ToolStripMenuItem
 $ApplicationFormMenuStripHelp.Name = "MenuHelp"
 $ApplicationFormMenuStripHelp.Size = "37, 20"
 $ApplicationFormMenuStripHelp.Text = "Help"
 [void]$ApplicationFormMenuStrip.Items.Add($ApplicationFormMenuStripHelp)

 $ApplicationFormMenuStripHelpFaq = New-Object System.Windows.Forms.ToolStripMenuItem
 $ApplicationFormMenuStripHelpFaq.Name = "MenuHelpFaq"
 $ApplicationFormMenuStripHelpFaq.Size = "186, 22"
 $ApplicationFormMenuStripHelpFaq.Text = "About"
 $ApplicationFormMenuStripHelpFaq.Add_Click({ # Start Function
 $statusPanel.Text = "Open FAQ"
 Start-Process -FilePath $FaqFile 
 $statusPanel.Text = "https://github.com/fardinbarashi"
 }) # End Funtion
 [void]$ApplicationFormMenuStripHelp.DropDownItems.Add($ApplicationFormMenuStripHelpFaq)
# End Menu Help
# End Application Top Menu

# ComboBox
$ComboBox = New-Object system.Windows.Forms.ComboBox
$ComboBox.size = "100,20"
$ComboBox.location = "453, 52"
$ComboBox.SelectedItem = $FileTypes
$ApplicationForm.Controls.Add($ComboBox)
 
 # ButtonBrowse Path To Folder
 $ApplicationFormButtonBrowse = New-Object System.Windows.Forms.Button
 $ApplicationFormButtonBrowse.Location = "173, 50"
 $ApplicationFormButtonBrowse.Name = "ButtonBrowse"
 $ApplicationFormButtonBrowse.Size = "80, 24"
 $ApplicationFormButtonBrowse.Text = "Browse"
 $ApplicationFormButtonBrowse.Add_Click( { FunctionBrowse })
 $ApplicationForm.Controls.Add($ApplicationFormButtonBrowse)
  Function FunctionBrowse 
  { # Start FunctionBrowse
  $statusPanel.Text = "Select a folder"
   If ( ( Test-Path $CsvFileType -PathType Leaf ) ) 
   {  # Start If Test-Path
    # $CsvFileType is true, File does exist, Remove-Csv File, Clean combobox items, generate FolderBrowserDialog and ComboBox 
    Remove-Item -Path $CsvFileType -Force
    $ComboBox.Items.Clear()
    $FileDialogFileBrowser = New-object System.Windows.Forms.FolderBrowserDialog
    $FileDialogFileBrowser.SelectedPath = $ApplicationFormTextboxUncPath # Path To the Fileserver
    $FileDialogFileBrowser.ShowDialog()
    $ApplicationFormTextboxFilePath.Text = $FileDialogFileBrowser.SelectedPath;
    $statusPanel.Text = "Loading filetypes to Combobox"
    # Create Combobox Csv file
    $GenerateFileTypes = Get-ChildItem -Recurse -Force -Path $FileDialogFileBrowser.SelectedPath | Select-Object Extension -Unique | Export-csv -Path $CsvFileType -Force -Encoding UTF8 -NoTypeInformation
    $ImportCsv = Import-Csv $CsvFileType -Delimiter "," -Encoding UTF8 | ForEach-Object { # Start Creating New-Objects,New-Object,ForEach-Object
    New-Object PsObject -Prop @{ Extension = $_.Extension } } # # End Creating New-Objects,New-Object,ForEach-Object
    # load the csv file
    @($ImportCsv.Extension) | ForEach-Object { [void] $ComboBox.Items.Add($_) } # End ForEach-Object  
    $statusPanel.Text = "Type a word in textbox and press Search"       
   } # End If Test-Path

  Else 
   { # Start ELSE Test-Path
    #$CsvFileType is False, File does not exist, generate FolderBrowserDialog and ComboBox 
    $FileDialogFileBrowser = New-object System.Windows.Forms.FolderBrowserDialog
    $FileDialogFileBrowser.SelectedPath = $ApplicationFormTextboxUncPath # Path To the Fileserver
    $FileDialogFileBrowser.ShowDialog()
    $ApplicationFormTextboxFilePath.Text = $FileDialogFileBrowser.SelectedPath;
    $statusPanel.Text = "Loading filetypes to Combobox"
    # Create Combobox Csv file
    $GenerateFileTypes = Get-ChildItem -Recurse -Force -Path $FileDialogFileBrowser.SelectedPath | Select-Object Extension -Unique | Export-csv -Path $CsvFileType -Force -Encoding UTF8 -NoTypeInformation
    $ImportCsv = Import-Csv $CsvFileType -Delimiter "," -Encoding UTF8 | ForEach-Object { # Start Creating New-Objects,New-Object,ForEach-Object
    New-Object PsObject -Prop @{ Extension = $_.Extension } } # # End Creating New-Objects,New-Object,ForEach-Object
    # load the csv file
    @($ImportCsv.Extension) | ForEach-Object { [void] $ComboBox.Items.Add($_) } # End ForEach-Object
    $statusPanel.Text = "Type a word in textbox and press Search"    
   }  # End ELSE Test-Path
  } # End FunctionBrowse


# Textbox FilePath To Folder
 $ApplicationFormTextboxFilePath = New-Object System.Windows.Forms.Textbox
 $ApplicationFormTextboxFilePath.Location = "263, 52"
 $ApplicationFormTextboxFilePath.Name = "TextboxPath"
 $ApplicationFormTextboxFilePath.Size = "180, 20"
 $ApplicationFormTextboxFilePath.Text =  ""
 $ApplicationForm.Controls.Add($ApplicationFormTextboxFilePath)


# Textbox Pattern textbox
 $ApplicationFormPatternTextbox = New-Object System.Windows.Forms.Textbox
 $ApplicationFormPatternTextbox.Location = "563, 52"
 $ApplicationFormPatternTextbox.Name = "TextboxPattern"
 $ApplicationFormPatternTextbox.Size = "180, 20"
 $ApplicationFormPatternTextbox.Text = ""
 $Pattern = $ApplicationFormPatternTextbox.Text
 $ApplicationForm.Controls.Add($ApplicationFormPatternTextbox)

# Button Search
 $ApplicationFormButtonSearch = New-Object System.Windows.Forms.Button
 $ApplicationFormButtonSearch.Location = "753, 50"
 $ApplicationFormButtonSearch.Name = "ButtonSearch"
 $ApplicationFormButtonSearch.Size = "80, 24"
 $ApplicationFormButtonSearch.Text = "Search"
 $ApplicationFormButtonSearch.Add_Click( { FunctionSearch })
 $ApplicationFormButtonSearchFileTypes = $ComboBox.SelectedItem
 $ApplicationForm.Controls.Add($ApplicationFormButtonSearch)
  Function FunctionSearch { # Start FunctionSearch 
  # Call Functions
  $statusPanel.Text = "Clearing Listview"
  Clear-Listview # Clear Listview
  $statusPanel.Text = "Adding Columns"
  Update-ContextMenu (Get-Variable Cms*) # Get CMS Menu
  Add-Columns # Add Columns
     If ( ( Test-Path $FilesSearchCsv -PathType Leaf ) ) 
     { # Start If FunctionSearch,
 
       Remove-Item -Path $FilesSearchCsv -Force #Remove $FilesSearchCsv 
       # Create Strings for Objects
       $FilePathSearch =  $ApplicationFormTextboxFilePath.Text
       $Pattern = $ApplicationFormPatternTextbox.Text
       $FileTypes = $ComboBox.SelectedItem
       $statusPanel.Text = "Starting Query"
       # Export Search As Csv
       $ExportFileSearch = Get-ChildItem -Path $FilePathSearch -Force -Recurse -Include $FileTypes | Select-String -Pattern $Pattern | Select-Object Filename, Path, LineNumber | Export-Csv $FilesSearchCsv -Force -NoTypeInformation -Encoding UTF8
       $ImportExportFileSearchCsv = Import-Csv $FilesSearchCsv -Encoding UTF8 -Delimiter ","   
       $ImportExportFileSearchCsv | Foreach-Object { # Start If $ImportExportFileSearchCsv
       Import-ExportFileSearchCsv
       Change-Size-Columns
       $statusPanel.Text = "https://github.com/fardinbarashi"
      } # End  If $ImportExportFileSearchCsv
     } # Start If FunctionSearch 
     Else
     { # Start Else FunctionSearch     
       # Create Strings for Objects
       $FilePathSearch =  $ApplicationFormTextboxFilePath.Text
       $Pattern = $ApplicationFormPatternTextbox.Text
       $FileTypes = $ComboBox.SelectedItem
       # Export Search As Csv
       $statusPanel.Text = "Starting Query"
       $ExportFileSearch = Get-ChildItem -Path $FilePathSearch -Force -Recurse -Include $FileTypes | Select-String -Pattern $Pattern | Select-Object Filename, Path, LineNumber | Export-Csv $FilesSearchCsv -Force -NoTypeInformation -Encoding UTF8
       $ImportExportFileSearchCsv = Import-Csv $FilesSearchCsv -Encoding UTF8 -Delimiter ","   
       $ImportExportFileSearchCsv | Foreach-Object { # Start Else $ImportExportFileSearchCsv
       Import-ExportFileSearchCsv
       Change-Size-Columns
       $statusPanel.Text = "https://github.com/fardinbarashi"
     } # End  Else $ImportExportFileSearchCsv           
    } # End Else FunctionSearch 
  } # End FunctionSearch




# ListView 
$LvMain = New-Object System.Windows.Forms.Listview
$LvMain.Location = "175, 90"
$LvMain.Name = "lvMain"
$LvMain.Size = "656, 635"
$LvMain.Text = "Pattern text"
$LvMain.Scrollable = $True
$LvMain.ContextMenuStrip = $LvMainContextMenu
$LvMain.FullRowSelect = $True
$LvMain.GridLines = "Details"
$LvMain.UseCompatibleStateImageBehavior = $False
$LvMain.View = "Details"
$LvMain.Font ="lucida console"
$LvMain.Checkboxes = $False
$LvMain.MultiSelect = $True
$ApplicationForm.Controls.Add($LvMain)


# Statusbar
$StatusBar = New-Object System.Windows.Forms.Statusbar
$StatusBar.Anchor = "Bottom, Left, Right"
$StatusBar.Dock = "Bottom"
$StatusBar.Location = "170,90"
$StatusBar.Name = "StatusBar"
$StatusBar.ShowPanels = $True
$StatusBar.Size = "850, 20"
$StatusBar.Text = "Ready"
$ApplicationForm.Controls.Add($StatusBar)


# StatusbarPanel
$statusPanel = New-Object System.Windows.Forms.StatusBarPanel
$statusPanel.Name = "statusPanel"
$statusPanel.Text = "https://github.com/fardinbarashi"
$statusPanel.AutoSize = "Spring"
[void]$StatusBar.Panels.Add($statusPanel)

# Initlize the form
$ApplicationForm.Add_Shown({$ApplicationForm.Activate()})
[void] $ApplicationForm.ShowDialog()


Stop-Transcript

