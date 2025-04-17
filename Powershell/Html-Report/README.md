# HTML-Report

<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.



# File Distribution Report Generator (PowerShell)

## 🧾 Overview

This PowerShell script generates a detailed **HTML report** comparing file distributions across three servers. It checks for specific patterns in filenames, aggregates data, validates expected file counts, and presents results in a visually structured format. The report is ideal for monitoring automated processes or validating replicated data between environments.

---

## ✅ Features

- 📂 Scans file systems from three configured servers
- 🔎 Extracts and groups files by **FundID** using a defined naming pattern
- 🧠 Validates against expected values from a `config.json`
- 📊 Generates a full HTML report with:
  - Total funds and file counts per server (Table 1)
  - Files per fund ID across servers (Table 2)
  - Individual file existence status per server (Table 3)
- 🎨 Color-coded output:
  - ✅ Green = Valid
  - ❌ Red = Missing
  - ⚠️ Yellow = Exceeds expected count

---

## 🖥️ System Requirements

| Component         | Minimum Version |
|------------------|------------------|
| PowerShell        | 5.1+             |
| Windows OS        | Windows 10+      |
| Permissions       | Read access to all server paths |

---

## 🔧 Configuration

### `config.json` format:
Located at:  
```
.\Settings\config.json
```

```json
{
  "Fundings": [
    {
      "FundID": "123",
      "FundName": "ExampleFundA"
    },
    {
      "FundID": "456",
      "FundName": "ExampleFundB"
    }
  ],
  "Max": {
    "Funds": 24,
    "Files": 16,
    "TotalMaxFiles": 384
  }
}
```

### Script Variables:
Adjust paths and file pattern as needed:
```powershell
$RegExPattern = "findthisfile"
$SourceFiles = "C:\Path\To\Server1"
$Server2DestinationFiles = "C:\Path\To\Server2"
$Server3DestinationFiles = "C:\Path\To\Server3"
```

---

## 📊 Report Sections

### 🟩 Table 1: Summary of Total Funds and Files per Server
Compares actual vs expected values (from config). Flags overages and shortages.

### 🟦 Table 2: Files per Fund ID per Server
Breaks down how many files each fund has per server. Expects 16 files/fund by default.

### 🟨 Table 3: File Existence per Server
Lists every matching file and checks its existence across all 3 servers.

---

## 📄 Output

The report is saved to:
```
.\files\HTML\ReportYYYYMMDD.html
```

Example:  
`Report20250417.html`

---

## ✉️ Example Output Snippet (HTML)

```html
<tr>
  <td>Fundings 123 - ExampleFundA</td>
  <td style="color: green;">16</td>
  <td style="color: red; font-weight: bold;">12</td>
  <td style="background-color: yellow; font-weight: bold;">20</td>
</tr>
```

---

## 🚨 Notes

- The script uses `Select-String` to match files like `findthisfile.123_filename.txt`
- You **must** ensure that the file structure and naming conventions are consistent
- Run the script with sufficient permissions to access all defined paths
- You can schedule this script using Task Scheduler to automate daily reporting

---

## 📓 Author

- **Author:** Fardin Barashi  
- **Version:** 1.0  
- **Release Date:** _Custom per report date_  
- **GitHub:** [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## 🧠 Summary

This script is perfect for environments where:
- Files are regularly generated per fund/project/user
- Data needs to be copied across environments
- You want a human-readable status overview daily

---

