# DNS-Checker (PowerShell)

## 🌐 Overview
**DNS-Checker** is a PowerShell script designed to simplify the management of DNS entries. Instead of navigating through the DNS Manager GUI, you can quickly find and remove DNS records directly from the command line. It’s especially useful for sysadmins looking to streamline DNS cleanup tasks.

---

## ✅ Features
- 🔍 Lists all available DNS zones on your server
- 💬 Prompts user for zone name and record to search
- 🧹 Removes DNS records based on input
- ⚰️ Automatically suggests a tombstone command for WINS cleanup
- 🧾 Logs script actions via transcript

---

## 💻 System Requirements

- **PowerShell Version:** 5.1.19041.2364  


<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🛠️ Usage

1. **Run PowerShell as Administrator.**
2. **Launch the script.**
3. Follow the prompts:
   - The script lists all DNS zones.
   - You enter the zone name to search within.
   - You then enter the hostname or record to look up.
   - If found, the script deletes the record and optionally triggers a WINS "tombstone" command via CMD.

---

## 🧪 Example Walkthrough

```plaintext
Zonenames in the DNS:
ZoneName
--------
corp.local
example.com

Select Your Zonename: corp.local
Which server do you want to search after in the dns: oldserver01

Searching dns record for oldserver01 in corp.local
[Record found...]

Removing DNS entry...
Open CMD and do a tombstone in wins
```

---

## 📓 Script Metadata

- **Author:** [Fardin Barashi](mailto:Fardin.Barashi@gmail.com)  
- **Title:** DNS-Checker  
- **Version:** 1.1  
- **Release Date:** 2023-02-22  
- **GitHub:** [https://github.com/fardinbarashi](https://github.com/fardinbarashi)  
- **Changelog:**
  - *2023-03-01:* Added WINS tombstone integration

---

## ⚠️ Important Notes

- The script only works if the DNS Server module is available (e.g., on DNS servers or systems with RSAT tools).
- DNS record deletion is permanent. Use with caution.
- The WINS command is echoed in a new CMD window for manual confirmation.

---

## 🔐 Permissions

To successfully run this script, PowerShell must be launched with **Administrator** privileges, especially for DNS and WINS operations.

---






