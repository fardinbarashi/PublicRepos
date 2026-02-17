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

About Script : Template for Ps-5 Scripts
Author : Fardin Barashi
Title : WinUI-GUI-Template 2026-02-17.ps1
Description : A quick startup-template
Version : 1.0
Release day : 2026-02-17
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

# Modules to import
Write-Host "Checking required modules..." -ForegroundColor Yellow

$requiredModules = @(
    "",
    ""
)

foreach ($module in $requiredModules) {
    Write-Host "`nChecking module: $module" -ForegroundColor Cyan
    
    if (Get-Module -ListAvailable -Name $module) {
        Write-Host "- Module found - Importing..." -ForegroundColor Green
        Import-Module $module -ErrorAction SilentlyContinue
    }
    else {
        Write-Host "- Module not found! - Installing..." -ForegroundColor Yellow
        Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
        Import-Module $module -Verbose
    }
}

Write-Host "`nAll modules are ready!" -ForegroundColor Green

# Assembly
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase


#  XAML
$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]::new($xaml))
$window = [Windows.Markup.XamlReader]::Load($reader)

# FunctionList
function Skriv-Logg {
    param($Meddelande)
    $timestamp = Get-Date -Format "HH:mm:ss"
    $loggTextBox.AppendText("[$timestamp] $Meddelande`n")
    $loggTextBox.ScrollToEnd()
}


#----------------------------------- Start Script ------------------------------------------
# Section 1 : xx
$Section = "Section 1 : XX"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 # Region Sections Main Form Settings And Paths
 # Contains Settings, Path To Xml File, Profile csv file, Transcripts logs 
 # Form Settings 
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Avancerad PowerShell WPF GUI" Height="500" Width="600"
        WindowStartupLocation="CenterScreen" ResizeMode="CanResizeWithGrip">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Padding" Value="10,5"/>
            <Setter Property="Background" Value="#FF0078D7"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="FontSize" Value="12"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#FF005A9E"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style TargetType="TextBox">
            <Setter Property="Margin" Value="5"/>
            <Setter Property="Padding" Value="5"/>
        </Style>
    </Window.Resources>
    
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        
        <!-- Formulärsektion -->
        <GroupBox Grid.Row="0" Header="Användarinformation" Padding="10" Margin="0,0,0,10">
            <StackPanel>
                <Label Content="Namn:"/>
                <TextBox Name="NamnTextBox" Height="25"/>
                
                <Label Content="E-post:"/>
                <TextBox Name="EmailTextBox" Height="25"/>
                
                <Label Content="Välj alternativ:"/>
                <ComboBox Name="AlternativComboBox" Height="25" Margin="5">
                    <ComboBoxItem Content="Alternativ 1" IsSelected="True"/>
                    <ComboBoxItem Content="Alternativ 2"/>
                    <ComboBoxItem Content="Alternativ 3"/>
                </ComboBox>
                
                <CheckBox Name="GodkannCheckBox" Content="Jag godkänner villkoren" Margin="5,10,5,5"/>
            </StackPanel>
        </GroupBox>
        
        <!-- Knappar -->
        <StackPanel Grid.Row="1" Orientation="Horizontal" HorizontalAlignment="Center">
            <Button Name="SkickaButton" Content="Skicka" Width="100"/>
            <Button Name="RensaButton" Content="Rensa" Width="100"/>
            <Button Name="LaggTillButton" Content="Lägg till i lista" Width="120"/>
        </StackPanel>
        
        <!-- Lista -->
        <GroupBox Grid.Row="2" Header="Sparade poster" Padding="5" Margin="0,10,0,10">
            <ListBox Name="PersonListBox" Height="100">
                <ListBox.ItemTemplate>
                    <DataTemplate>
                        <StackPanel Orientation="Horizontal">
                            <TextBlock Text="{Binding Namn}" FontWeight="Bold" Margin="0,0,10,0"/>
                            <TextBlock Text="{Binding Email}" Foreground="Gray"/>
                        </StackPanel>
                    </DataTemplate>
                </ListBox.ItemTemplate>
            </ListBox>
        </GroupBox>
        
        <!-- Logg/Output -->
        <GroupBox Grid.Row="3" Header="Logg" Padding="5">
            <TextBox Name="LoggTextBox" TextWrapping="Wrap" 
                     VerticalScrollBarVisibility="Auto" IsReadOnly="True"
                     Background="#FFF5F5F5" FontFamily="Consolas"/>
        </GroupBox>
        
        <!-- Statusrad -->
        <StatusBar Grid.Row="4" Height="25">
            <StatusBarItem>
                <TextBlock Name="StatusTextBlock" Text="Redo"/>
            </StatusBarItem>
        </StatusBar>
    </Grid>
</Window>
"@
 # End Form Settings 

# Get all controllers 
$namnTextBox = $window.FindName("NamnTextBox")
$emailTextBox = $window.FindName("EmailTextBox")
$alternativComboBox = $window.FindName("AlternativComboBox")
$godkannCheckBox = $window.FindName("GodkannCheckBox")
$skickaButton = $window.FindName("SkickaButton")
$rensaButton = $window.FindName("RensaButton")
$laggTillButton = $window.FindName("LaggTillButton")
$personListBox = $window.FindName("PersonListBox")
$loggTextBox = $window.FindName("LoggTextBox")
$statusTextBlock = $window.FindName("StatusTextBlock")

# Skicka-knapp
$skickaButton.Add_Click({
    if (-not $godkannCheckBox.IsChecked) {
        [System.Windows.MessageBox]::Show(
            "Du måste godkänna villkoren!", 
            "Varning", 
            [System.Windows.MessageBoxButton]::OK, 
            [System.Windows.MessageBoxImage]::Warning
        )
        return
    }
    
    $namn = $namnTextBox.Text
    $email = $emailTextBox.Text
    $alternativ = $alternativComboBox.SelectedItem.Content
    
    if ([string]::IsNullOrWhiteSpace($namn) -or [string]::IsNullOrWhiteSpace($email)) {
        [System.Windows.MessageBox]::Show(
            "Namn och e-post måste fyllas i!", 
            "Varning", 
            [System.Windows.MessageBoxButton]::OK, 
            [System.Windows.MessageBoxImage]::Warning
        )
        return
    }
    
    Skriv-Logg "Skickade data för: $namn ($email) - $alternativ"
    $statusTextBlock.Text = "Data skickad!"
    
    [System.Windows.MessageBox]::Show(
        "Data har skickats för $namn!`nE-post: $email`nAlternativ: $alternativ", 
        "Bekräftelse", 
        [System.Windows.MessageBoxButton]::OK, 
        [System.Windows.MessageBoxImage]::Information
    )
})

# Rensa-knapp
$rensaButton.Add_Click({
    $namnTextBox.Clear()
    $emailTextBox.Clear()
    $alternativComboBox.SelectedIndex = 0
    $godkannCheckBox.IsChecked = $false
    Skriv-Logg "Formuläret rensades"
    $statusTextBlock.Text = "Redo"
})

# Lägg till i lista-knapp
$laggTillButton.Add_Click({
    $namn = $namnTextBox.Text
    $email = $emailTextBox.Text
    
    if ([string]::IsNullOrWhiteSpace($namn)) {
        [System.Windows.MessageBox]::Show(
            "Namn måste fyllas i!", 
            "Varning", 
            [System.Windows.MessageBoxButton]::OK, 
            [System.Windows.MessageBoxImage]::Warning
        )
        return
    }
    
    $person = [PSCustomObject]@{
        Namn = $namn
        Email = $email
    }
    
    $personListBox.Items.Add($person)
    Skriv-Logg "Lade till: $namn i listan"
    $statusTextBlock.Text = "Person tillagd i lista"
})

# Välkomstmeddelande
Skriv-Logg "Applikationen startad"
Skriv-Logg "Välkommen till PowerShell WPF GUI!"

# Visa fönstret
$window.ShowDialog() | Out-Null

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


#----------------------------------- End Script ------------------------------------------
Stop-Transcript