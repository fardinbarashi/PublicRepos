<!-- ABOUT THE PROJECT -->
## About The Project
# AD-User Mobile Number

## System Requirements
- **PowerShell version**: 5.1.19041.2364
---

## About the Script

**Author**: Fardin Barashi  
**Title**: `AD-User Mobile Number`  
**Version**: 1.0  
**Release Date**: 2025-01-16  
**GitHub**: [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## Description
This script collects the `mobile` attribute from each Active Directory user and copies the value into `extensionAttribute2` with proper formatting.

### Features

- Extracts the original mobile number.
- Formats the number to the international Swedish format:
  - Adds country code: `+46`
  - Removes spaces and hyphens
  - Final format: `+467XXXXXXXX`
- Copies the formatted number into `extensionAttribute2`.
- Generates an HTML report after execution.
- Sends the report via email.

### Note

If an error occurs, make sure the `mobile` attribute is correctly populated.

---

<!-- GETTING STARTED -->
## Configuration

No external modules are required beyond standard Windows AD tools.  
Make sure the script is run with appropriate privileges to read and write to user attributes in Active Directory.

---

<!-- LICENSE -->
## License

Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.

---

<!-- CONTACT -->
## Contact

LinkedIn - [Fardin Barashi](https://www.linkedin.com/in/fardin-barashi-a56310a2/)
