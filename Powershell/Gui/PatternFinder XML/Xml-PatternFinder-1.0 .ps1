# Fixa ContextMeny funktioner.
# Net Assembly
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing"); 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms");
[void] [System.Reflection.Assembly]::LoadWithPartialName('presentationframework');
[void] [System.Windows.Forms.Application]::EnableVisualStyles();

# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"


# Application Form Settings
$ApplicationForm = New-Object System.Windows.Forms.Form

$ApplicationVersion = "V 1.0"
$ApplicationTitle = "XML - Pattern Lookup - " 
$ApplicationForm.Text = "$ApplicationTitle $ApplicationVersion" 
$ApplicationForm.StartPosition = "CenterScreen"
$ApplicationForm.Topmost = $false 
$ApplicationForm.Size = "1200,800"


# Path 
$ApplicationIconPath = " ENTER PATH TO THE FOLDER \Xml-Pattern\Files\Img\logo\logo.ico"
$ApplicationForm.Icon = New-Object system.drawing.icon ("$ApplicationIconPath ")
# Xml Columns File
$XMLFile = "ENTER PATH TO THE FOLDER \Xml-Pattern\Files\XmlColumns\GenerateColumns.xml"
[XML]$Script:XML = Get-Content $XMLFile
# Select String Options
$DeleteReportFile = "ENTER PATH TO THE FOLDER \Xml-Pattern\Files\Reports\Report.csv"
$ReportFile = "ENTER PATH TO THE FOLDER l\Xml-Pattern\Files\Reports\Report.csv"
# Textbox Stand Unc Path
$ApplicationFormTextboxUncPath = ""


# Application Form Menu
$ApplicationFormMenuStrip = New-Object System.Windows.Forms.MenuStrip
$ApplicationFormMenuStrip.Location = '0, 0'
$ApplicationFormMenuStrip.Name = "MainMenu"
$ApplicationFormMenuStrip.Size = '780, 24'
$ApplicationFormMenuStrip.Text = "Main"
$ApplicationForm.Controls.Add($ApplicationFormMenuStrip)

$ApplicationFormMenuStripFile = New-Object System.Windows.Forms.ToolStripMenuItem
$ApplicationFormMenuStripFile.Name = "MenuFile"
$ApplicationFormMenuStripFile.Size = '37, 20'
$ApplicationFormMenuStripFile.Text = "File"
[void]$ApplicationFormMenuStrip.Items.Add($ApplicationFormMenuStripFile)

$ApplicationFormMenuStripFileExit = New-Object System.Windows.Forms.ToolStripMenuItem
$ApplicationFormMenuStripFileExit.Name = "MenuFileExit"
$ApplicationFormMenuStripFileExit.Size = '186, 22'
$ApplicationFormMenuStripFileExit.Text = "Exit"
$ApplicationFormMenuStripFileExit.Add_Click({$ApplicationForm.Close()}) 
[void]$ApplicationFormMenuStripFile.DropDownItems.Add($ApplicationFormMenuStripFileExit)

# ContextMenu
    $ContextMenu = New-Object System.Windows.Forms.ContextMenuStrip
    $ContextMenu.Name = "ContextMenu"
    $ContextMenu.Size = '188, 114'
        
        # ContextMenu-SubMenu-Folder
            $cmsOpenFilesFolders = New-Object System.Windows.Forms.ToolStripMenuItem
            $cmsOpenFilesFolders.Name = "cmsOpenFilesFolders"
            $cmsOpenFilesFolders.Size = '187, 22'
            $cmsOpenFilesFolders.Text = "Open Files Folders"
            $cmsOpenFilesFolders.Visible = $False
            $cmsOpenFilesFolders.Add_Click({ Function-cms-Open-Files-Folders })
            [void]$ContextMenu.Items.Add($cmsOpenFilesFolders)
            function Function-cms-Open-Files-Folders  { 
            
             foreach ( $Item in $Lvmain.SelectedItems) {
			 
             $SelectedItemPath =  $item.subitems[1].text
             $SelectedItemPathRemoveLastPart =  Split-Path -Path $SelectedItemPath -Parent 
             Start-Process -FilePath $SelectedItemPathRemoveLastPart 
             
             
                }
                    } 
                             

        # ContextMenu-SubMenu-Open Files in Explorer
            $cmsOpenFilesExplorer = New-Object System.Windows.Forms.ToolStripMenuItem
            $cmsOpenFilesExplorer.Name = "cmsOpenFilesExplorer"
            $cmsOpenFilesExplorer.Size = '187, 22'
            $cmsOpenFilesExplorer.Text = "Open Files in Explorer"
            $cmsOpenFilesExplorer.Visible = $False
            $cmsOpenFilesExplorer.Add_Click({ Function-cms-Open-Files-Explorer })
            [void]$ContextMenu.Items.Add($cmsOpenFilesExplorer)
            function Function-cms-Open-Files-Explorer {
            
            foreach ( $Item in $Lvmain.SelectedItems) {
            $SelectedItemPath =  $item.subitems[1].text
            Start-Process -FilePath $SelectedItemPath 
                }
                    } 


       

        # ContextMenu-SubMenu-Edit-All-File-Notepad
            $cmsEditFilesNotepad = New-Object System.Windows.Forms.ToolStripMenuItem
            $cmsEditFilesNotepad.Name = "cmsEditFilesNotepad"
            $cmsEditFilesNotepad.Size = '187, 22'
            $cmsEditFilesNotepad.Text = "Edit Files In Notepad "
            $cmsEditFilesNotepad.Visible = $False
            $cmsEditFilesNotepad.Add_Click({ Function-Cms-Edit-Files-Notepad })
            [void]$ContextMenu.Items.Add($cmsEditFilesNotepad)
            function Function-Cms-Edit-Files-Notepad  {
            
            foreach ( $Item in $Lvmain.SelectedItems) {
            $SelectedItemPath =  $item.subitems[1].text
            Notepad.exe $SelectedItemPath
            }
                } 

                    


        # ContextMenu-SubMenu-Save List As Csv
            $cmsOpenListviewCsvFolder = New-Object System.Windows.Forms.ToolStripMenuItem
            $cmsOpenListviewCsvFolder.Name = "cmsOpenListviewCsvFolder"
            $cmsOpenListviewCsvFolder.Size = '187, 22'
            $cmsOpenListviewCsvFolder.Text = "Open Csv Folder"
            $cmsOpenListviewCsvFolder.Visible = $False
            $cmsOpenListviewCsvFolder.Add_Click({ Function-cms-Open-Listview-Csv-Folder }) 
            [void]$ContextMenu.Items.Add($cmsOpenListviewCsvFolder)
            function Function-cms-Open-Listview-Csv-Folder   {
            
            explorer.exe "ENTER PATH TO THE FOLDER \Xml-Pattern\Files\Reports\"
            }


        


    # Label Path To Folder
    $ApplicationFormLabelPath = New-Object System.Windows.Forms.Label
    $ApplicationFormLabelPath.Location = '15, 33'
    $ApplicationFormLabelPath.Name = "LabelPath"
    $ApplicationFormLabelPath.Size = "65, 20"
    $ApplicationFormLabelPath.Text = "Unc-Path"
    $ApplicationForm.Controls.Add($ApplicationFormLabelPath)

    # Textbox Path To Folder
    $ApplicationFormTextboxPath = New-Object System.Windows.Forms.Textbox
    $ApplicationFormTextboxPath.Location = '100, 53'
    $ApplicationFormTextboxPath.Name = "TextboxPath"
    $ApplicationFormTextboxPath.Size = "180, 20"
    $ApplicationFormTextboxPath.Text = $ApplicationFormTextboxUncPath
    $ApplicationForm.Controls.Add($ApplicationFormTextboxPath)

    # Button Browse 
    $ApplicationFormButtonBrowse = New-Object System.Windows.Forms.Button
    $ApplicationFormButtonBrowse.Location = '15, 53'
    $ApplicationFormButtonBrowse.Name = "ButtonBrowse"
    $ApplicationFormButtonBrowse.Size = "80, 20"
    $ApplicationFormButtonBrowse.Text = "Browse"
    $ApplicationFormButtonBrowse.Add_Click({ FunctionBrowse }) 
    $ApplicationForm.Controls.Add($ApplicationFormButtonBrowse)
    function FunctionBrowse {

        $FileDialogFileBrowser = New-object System.Windows.Forms.FolderBrowserDialog
        # Path To the Fileserver
        $FileDialogFileBrowser.SelectedPath = $ApplicationFormTextboxUncPath
        $FileDialogFileBrowser.ShowDialog() 
        $ApplicationFormTextboxPath.Text = $FileDialogFileBrowser.SelectedPath;
    
        }



    # Label Pattern
    $ApplicationFormLabelPattern = New-Object System.Windows.Forms.Label
    $ApplicationFormLabelPattern.Location = '60, 130'
    $ApplicationFormLabelPattern.Name = "LabelPattern"
    $ApplicationFormLabelPattern.Size = "150, 20"
    $ApplicationFormLabelPattern.Text = " Search Keyword"
    $ApplicationForm.Controls.Add($ApplicationFormLabelPattern)

    # Textbox Pattern
    $ApplicationFormTextboxPattern = New-Object System.Windows.Forms.Textbox
    $ApplicationFormTextboxPattern.Location = '15, 150'
    $ApplicationFormTextboxPattern.Name = "TextboxPattern"
    $ApplicationFormTextboxPattern.Size = "180, 20"
    $ApplicationFormTextboxPattern.Text = ""
    $ApplicationForm.Controls.Add($ApplicationFormTextboxPattern)


    # Button Search 
    $ApplicationFormButtonSearch = New-Object System.Windows.Forms.Button
    $ApplicationFormButtonSearch.Location = '65, 180'
    $ApplicationFormButtonSearch.Name = "ButtonSearch"
    $ApplicationFormButtonSearch.Size = "80, 20"
    $ApplicationFormButtonSearch.Text = "Search"
    $ApplicationFormButtonSearchFileTypes = "*.Xml"
    $ApplicationFormButtonSearch.Add_Click({ Function-Start-Search }) 
    $ApplicationForm.Controls.Add($ApplicationFormButtonSearch)
    
    function Function-Start-Search {
        

        $RemovePreviousCsvReportFile = Remove-Item -Path $DeleteReportFile 
        start-sleep -m  250
        $ProgressBar.Maximum = $total*4 + 4
        $ProgressBar.Value ++
        $StatusBarStatusPanel.Text =  "Generate Query, Wait"
        start-sleep -m  250
        Function-Update-ContextMenu (Get-Variable Cms*)
        Function-Add-Column
        

        $Pattern = $ApplicationFormTextboxPattern.Text    
       
        
        $StatusBarStatusPanel.Text =  "Creating Db - Report.csv"
        start-sleep -m  250
        
         # Du körde på detta  dvs filename innan du bytte till Path --> Sort-Object -Property Filename -Unique                                                                                                                                                        
         $GetXmlFileData =  Get-ChildItem -Path $ApplicationFormTextboxUncPath -Recurse -force -Include $ApplicationFormButtonSearchFileTypes  | Select-String -Pattern $Pattern | Sort-Object -Property Path -Unique | Select-Object Filename, Path | Export-Csv $ReportFile -Encoding UTF8 -Delimiter ";"
            $StatusBarStatusPanel.Text =  "Loading data to the Listview, Wait"
                 
                     start-sleep -m  250

                        $ImportCsvReportFile = Import-Csv -Path $ReportFile -Encoding UTF8 -Delimiter ";" | Foreach-Object {   
                             
                             # Populate Listview with $ImportCsvReportFile.Filename och $ImportCsvReportFile.Path
                             $SItem = New-Object System.Windows.Forms.ListViewItem(" Start - File Attribute " )
                             $SItem.BackColor = "Black"
                             $SItem.ForeColor = "White"
                             $LvMain.Items.Add($SItem)
                        
                             $Item = New-Object System.Windows.Forms.ListViewItem(" Xml - FileName :")
                             $Item.SubItems.Add($_.Filename) 
                             $LvMain.Items.Add($Item)  
             
                                
                             $Item = New-Object System.Windows.Forms.ListViewItem(" Xml - Path :")
                             $Item.SubItems.Add($_.Path) 
                             $LvMain.Items.Add($Item)
                            
                             $EItem = New-Object System.Windows.Forms.ListViewItem(" End - File Attribute ")
                             $EItem.BackColor = "Red"
                             $EItem.ForeColor = "Black"
                             $LvMain.Items.Add($EItem)    
                             } 
                                     $ProgressBar.Value ++
                                     $StatusBarStatusPanel.text = "Query Completed"
                                     start-sleep -m  250
                                     
                                     $ProgressBar.Value ++
                                     $StatusBarStatusPanel.text = "Rezisiing the columns"
                                     Function-Change-Size-Columns
                                     
                                     $ProgressBar.Value ++
                                     $StatusBarStatusPanel.text = "Query Completed"
                                     start-sleep -m  250
                                     
                                     $ProgressBar.Value = 0;
                                     $StatusBarStatusPanel.text = "Ready" 
                             
                             } 

                            



                                                            


# ListView Information 
$LvMain = New-Object System.Windows.Forms.Listview
$LvMain.Location = '300, 55'
$LvMain.Name = "lvMain"
$LvMain.Size = "850, 600"
$LvMain.Text = "Pattern text"
$LvMain.Scrollable = $True 
$LvMain.ContextMenuStrip = $ContextMenu
$LvMain.FullRowSelect = $True
$LvMain.GridLines = "Details"
$LvMain.UseCompatibleStateImageBehavior = $False
$LvMain.View = "Details"
$LvMain.Font ="lucida console"
$LvMain.Checkboxes = $False
$LvMain.MultiSelect = $True
$ApplicationForm.Controls.Add($LvMain)

# Progressbar
$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Location = "300,680"
$ProgressBar.Size = "850,20"
$ProgressBar.Name = "StatusBar"
$ApplicationForm.Controls.Add($ProgressBar)

# Statusbar
$StatusBar = New-Object System.Windows.Forms.StatusBar
$StatusBar.Anchor = 'Bottom, Left, Right'
$StatusBar.Dock = 'None'
$StatusBar.Location = "300,27"
$StatusBar.Name = "StatusBar"
$StatusBar.ShowPanels = $True
$StatusBar.Size = '850, 20'
$StatusBar.Text = "Ready"
$ApplicationForm.Controls.Add($StatusBar)


# StatusbarPanel
$StatusBarStatusPanel = New-Object System.Windows.Forms.StatusbarPanel
$StatusBarStatusPanel.AutoSize = 'Spring'
$StatusBarStatusPanel.Name = "StatusBarStatusPanel"
$StatusBarStatusPanel.Text = "Ready"
$StatusBarStatusPanel.Width = 620
[void]$StatusBar.Panels.Add($StatusBarStatusPanel)




# Add columns to the ListView
    # Column Value  
        #$lvMain.Columns.Add($Filename)  
        $ColumnFileAttribute = New-Object System.Windows.Forms.ColumnHeader
        $ColumnFileAttribute.name = "File-Attribute"
        $ColumnFileAttribute.Text = "File-Attribute"
        $LvMain.Columns.Add($ColumnFileAttribute)  | Out-Null
            
        $ColumnFileValue = New-Object System.Windows.Forms.ColumnHeader
        $ColumnFileValue.name = "Value"
        $ColumnFileValue.Text = "Value"
        $LvMain.Columns.Add($ColumnFileValue)  | Out-Null 
    # Size Option Columns
    Function Function-Change-Size-Columns {
        $LvMain.Columns | %{$_.Width = -1;}
        }


# Functions
    # Updates CMS at Function-Start-Search
        function Function-Update-ContextMenu 
            {
                Param($Vis)		
                Get-Variable Cms* | %{Try{$_.Value.Visible = $False}catch{}}
                $Vis | %{try{$_.Value.Visible = $True}catch{}} 
                                                               }

    # Add Rows From Xml File To Listview 
        function Function-Add-Column 
            {
                Param([String]$Column)
                Write-Verbose "Adding $Column from XML file"
                $lvMain.Columns.Add($Column) 
                                            }	
   


# Initlize the form
    $ApplicationForm.Add_Shown({$ApplicationForm.Activate()})
    [void] $ApplicationForm.ShowDialog()


Stop-Transcript


