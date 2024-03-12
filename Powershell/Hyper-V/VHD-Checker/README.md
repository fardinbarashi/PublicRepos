# PsVhdxChecker
Introducing VHDX-Checker: Automate VHDX Disk Size Management

Are you tired as a admin of manually checking the freespace in your VHDX disks and resizing them accordingly? Look no further than VHDX-Checker, the automated solution to managing VHDX disk sizes!

VHDX-Checker is a PowerShell script that monitors the freespace in each VHDX in the designated $VhdxShare directory. If the freespace falls below a user-defined threshold, VHDX-Checker will automatically create a new size for the VHDX disk based on the $sizeIncrease string, which is set to a default of 20%. However, users have the flexibility to adjust this value to their preference by simply modifying the $sizeIncrease string.
Diskpart config files is used by Diskpart to select vdisk and extend the partition

To ensure seamless execution, VHDX-Checker utilizes Diskpart config files to select the vdisk and extend the partition. Please note that VHDX-Checker runs exclusively with fixed size VHDX disks, and requires hyper-V cmdlets to be installed. Fortunately, installing hyper-v with gui management is a quick and easy process.

Take the hassle out of VHDX disk size management and let VHDX-Checker automate the process for you. For further information, please refer to the script description.
