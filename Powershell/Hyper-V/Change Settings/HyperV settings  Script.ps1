# Powershell code
# Strings Start
$VirtualInternalSwitch = "VirtualInternalSwitch"
$VirtualPrivateSwitch= "VirtualPrivateSwitch"
$VirtualExternalSwitch= "VirtualEthernetSwitch"
$PathVirtualHarddrive = "D:\HyperV\Harddrive"
$PathVirtualMachine = "D:\HyperV\Machines"
$ServerConfigProccessor = "4" 
$ServerVHDSize = "128000000000" 
# Strings End

New-VmSwitch -Name $VirtualInternalSwitch -Notes "Allows communication between the host and Vm" -SwitchType Internal
New-VmSwitch -Name $VirtualPrivateSwitch -Notes "Allows communication between the Vm's and not the host" -SwitchType Private
New-VmSwitch -NetAdapterName "Ethernet" -Notes "Allows External Communication" -Name $VirtualExternalSwitch -AllowManagementOS $true
Read-Host 'The Network is completed, Press Enter to Create the folders' | Out-Null
# Creating the path
New-Item $PathVirtualHarddrive -type directory
start-sleep -s 1
New-Item $PathVirtualMachine -type directory
start-sleep -s 1
# Creating the virtual machine DC01
$NameVirtualDC = read-host "The Folders are completed,Enter Name To The Domaincontroller ( eg SrvDc01 )" 
New-VM -Name $NameVirtualDC -Path $PathVirtualMachine -MemoryStartupBytes 8GB -NewVHDPath $PathVirtualHarddrive\$NameVirtualDC.vhdx -NewVHDSizeBytes $ServerVHDSize -SwitchName $VirtualExternalSwitch -Generation 2
# Changing the ProcessorCount
Set-VM –Name $NameVirtualDC -ProcessorCount 4
Add-VMDvdDrive -VMName $NameVirtualDC
Set-VMDvdDrive -VMName $NameVirtualDC -Path $PathInstallIsoWin2016
start-sleep -s 1

# Creating the Virtual Machine Sccm
$NameVirtualSccm = read-host "The DC is complete, Enter Name To The VM With SCCM ( eg SrvSccm01 )" 
New-VM -Name $NameVirtualSccm -Path $PathVirtualMachine -MemoryStartupBytes 8GB -NewVHDPath $PathVirtualHarddrive\$NameVirtualSccm.vhdx -NewVHDSizeBytes $ServerVHDSize -SwitchName $VirtualExternalSwitch -Generation 2
# Changing the ProcessorCount
Start-sleep -s 1
Set-VM –Name $NameVirtualSccm -ProcessorCount 4
Add-VMDvdDrive -VMName $NameVirtualSccm
Set-VMDvdDrive -VMName $NameVirtualSccm -Path $PathInstallIsoWin2016
# 

# Creating the Virtual Machine SQL
$NameVirtualSql = read-host "The Sccm is complete, Enter Name To The VM  With SQL ( eg SrvSql01 )" 
New-VM -Name $NameVirtualSql -Path $PathVirtualMachine -MemoryStartupBytes 8GB -NewVHDPath $PathVirtualHarddrive\$NameVirtualSql.vhdx -NewVHDSizeBytes $ServerVHDSize -SwitchName $VirtualExternalSwitch -Generation 2
# Changing the ProcessorCount
Start-sleep -s 1
Set-VM -Name $NameVirtualSql -ProcessorCount 4
Add-VMDvdDrive -VMName $NameVirtualSql
Set-VMDvdDrive -VMName $NameVirtualSql -Path $PathInstallIsoWin2016
# 
Get-VM
