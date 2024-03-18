# VHDXChecker

<!-- ABOUT THE PROJECT -->
## About The Project
VHDX-Checker: Automate VHDX Disk Size Management
VHDXChecker 1.0
VHDXChecker 1.1

VHDX-Checker is a PowerShell script that monitors the freespace in each VHDX in the designated $VhdxShare directory. 
If the freespace falls below a user-defined threshold, 
VHDX-Checker will automatically create a new size for the VHDX disk based on the $sizeIncrease string, 
which is set to a default of 20%. However, users have the flexibility to adjust this value to their preference by simply modifying the $sizeIncrease string.
Diskpart config files is used by Diskpart to select vdisk and extend the partition

To ensure seamless execution, VHDX-Checker utilizes Diskpart config files to select the vdisk and extend the partition. 
Please note that VHDX-Checker runs exclusively with fixed size VHDX disks, and requires hyper-V cmdlets to be installed. Fortunately, installing hyper-v with gui management is a quick and easy process.

Take the hassle out of VHDX disk size management and let VHDX-Checker automate the process for you. 
For further information, please refer to the script description.



<!-- GETTING STARTED -->
## Getting Started
Run script


<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Linkedin - [Fardin Barashi]([https://twitter.com/your_username](https://www.linkedin.com/in/fardin-barashi-a56310a2/)) - email@example.com

<p align="right">(<a href="#readme-top">back to top</a>)</p>





