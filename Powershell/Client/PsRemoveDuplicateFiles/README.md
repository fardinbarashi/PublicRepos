# PsRemoveDuplicateFiles

## Description
PsRemoveDuplicateFiles is a PowerShell script designed to help you remove duplicate files from a folder and save disk space. It prompts the user to enter the path to the folder they want to search in, retrieves a list of all files in the specified folder and its subfolders, and identifies files with more than one occurrence. For each file with multiple occurrences, the script displays the file's full path, size in megabytes (MB), and prompts the user to delete it. If the user chooses to delete the file, it is removed using the `Remove-Item` cmdlet with the `-Force` flag, which forces deletion without confirmation. The script skips the deletion if the user chooses not to delete the file or enters an invalid choice.

`Change line 56 - FolderPath `

![Screenshot](https://github.com/fardinbarashi/PsRemoveDuplicateFiles/blob/main/Screenshot.PNG)



## Features
- Interactive prompt for selecting duplicate files to delete
- Displays the full path and size of the duplicate files in MB
- Safe deletion using the `Remove-Item` cmdlet with the `-Force` flag
- Logs script execution details to a transcript file for review

## System Requirements
- PowerShell version 5
- Compatible with PowerShell versions 1.0 and above
- WS-Management stack version 3.0

## Usage
1. Download or clone the repository to your local machine.
2. Open PowerShell.
3. Navigate to the repository's directory.
4. Run the script using the command: `.\PsRemoveDuplicateFiles.ps1`.
5. Enter the path to the folder you want to search for duplicate files.
6. Review the list of duplicate files presented with their paths and sizes.
7. Respond to the prompts to delete or skip each duplicate file.
8. The script will execute the requested actions and provide relevant output.
9. Check the transcript log file for a detailed record of the script's execution.

## Script Details
- Author: Fardin Barashi
- Version: 1.0
- Release Date: 2023-07-12
- GitHub Repository: [Link](https://github.com/fardinbarashi/PsRemoveDuplicateFiles)

## License
This script is released under the [MIT License](LICENSE).
