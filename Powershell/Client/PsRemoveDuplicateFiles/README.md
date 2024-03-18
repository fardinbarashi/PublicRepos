# PsRemoveDuplicateFiles

<!-- ABOUT THE PROJECT -->
## About The Project
PsRemoveDuplicateFiles is a PowerShell script designed to help you remove duplicate files from a folder and save disk space. It prompts the user to enter the path to the folder they want to search in, retrieves a list of all files in the specified folder and its subfolders, and identifies files with more than one occurrence. For each file with multiple occurrences, the script displays the file's full path, size in megabytes (MB), and prompts the user to delete it. If the user chooses to delete the file, it is removed using the `Remove-Item` cmdlet with the `-Force` flag, which forces deletion without confirmation. The script skips the deletion if the user chooses not to delete the file or enters an invalid choice.
![Screenshot](https://github.com/fardinbarashi/PublicRepos/Powershell/Client/PsRemoveDuplicateFiles/blob/main/Screenshot.PNG)
- Interactive prompt for selecting duplicate files to delete
- Displays the full path and size of the duplicate files in MB
- Safe deletion using the `Remove-Item` cmdlet with the `-Force` flag
- Logs script execution details to a transcript file for review


<!-- GETTING STARTED -->
## Getting Started
Change line 56 - FolderPath


<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Linkedin - [Fardin Barashi]([https://twitter.com/your_username](https://www.linkedin.com/in/fardin-barashi-a56310a2/)) - email@example.com

<p align="right">(<a href="#readme-top">back to top</a>)</p>





