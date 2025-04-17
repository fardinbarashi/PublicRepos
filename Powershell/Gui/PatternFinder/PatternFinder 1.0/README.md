# PatternFinder

## 🔍 Overview
**PatternFinder** is a Windows Forms-based PowerShell application that allows you to search for specific text patterns inside files across a chosen directory. It's built with productivity in mind, giving you an easy-to-use interface, context menu functionality, and advanced filtering options to quickly pinpoint files containing specific strings.

---

## ✅ Features

- 📂 Browse and select any folder to search in
- 🔠 Filter files by extension (auto-detected from selected folder)
- 📝 Enter a keyword or pattern to search
- 📋 Displays results in a ListView with filename, path, and line number
- 🖱️ Right-click context menu for:
  - Opening files or their location
  - Deleting selected files
  - Clearing the result list
- 🧼 Option to remove temporary files created during search
- 🆘 FAQ/help integration
- 🧾 Logs actions using `Start-Transcript`

---

## 💻 System Requirements

| Requirement              | Version                  |
|--------------------------|--------------------------|
| PowerShell Version       | 5.1.19041.2364 or later  |
| PSEdition                | Desktop                  |
| .NET CLR Version         | 4.0.30319.42000          |
| OS Compatibility         | Windows 10 or later      |

---

## 🛠️ How It Works

1. **Browse for a folder**  
   Click the `Browse` button to choose the root folder where your search will take place.

2. **Select file type (optional)**  
   A dropdown (combo box) will be populated with unique file extensions from the selected folder.

3. **Enter a keyword or pattern**  
   Type the word or expression you want to search for in the textbox.

4. **Click “Search”**  
   Results are displayed in a ListView showing:
   - FileName
   - FilePath
   - LineNumber

5. **Use right-click (CMS)**  
   Interact with results through the context menu:
   - Open file
   - Open file location
   - Delete file
   - Clear results

---

## 🖱️ Context Menu Features

| Option               | Description                                |
|----------------------|--------------------------------------------|
| **Open File**        | Opens the selected file                    |
| **Open File-Location** | Opens the folder where the file resides |
| **Delete File**      | Prompts for confirmation before deleting   |
| **Clear ListView**   | Clears all search results from the view    |

---

## 📂 File Structure

| Path                                 | Description                                 |
|--------------------------------------|---------------------------------------------|
| `Files\Csv\FileType.csv`             | Stores available file types from folder     |
| `Files\ListviewData\ListViewData.csv`| Stores search results                       |
| `Files\ListviewColumn\Columns.xml`   | Defines column structure for ListView       |
| `Files\Help\Faq.txt`                 | Help/About info shown from GUI              |
| `Files\Logs\Logfile.txt`             | Logs activity using `Start-Transcript`      |
| `Files\logo\Logo.ico`                | Application icon                            |

---

## 📓 Script Metadata

- **Author:** [Fardin Barashi](mailto:Fardin.barashi@gmail.com)  
- **Title:** PatternFinder  
- **Version:** 1.0  
- **GitHub Repo:** [https://github.com/fardinbarashi/Patternfinder](https://github.com/fardinbarashi/Patternfinder)  
- **GitHub Profile:** [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## 🧪 Example Use Case

**Example Search Scenario:**

- 📁 Selected Folder: `C:\Projects`
- 🔎 File Type: `.ps1`
- 🔤 Pattern: `Invoke-WebRequest`

**Result:**

| FileName        | Path                            | LineNumber |
|-----------------|----------------------------------|------------|
| `script1.ps1`   | `C:\Projects\module\script1.ps1` | 42         |
| `script2.ps1`   | `C:\Projects\main\script2.ps1`   | 17         |

---

## 🔐 Permissions

This script **does not require elevated (admin) privileges**, but write access is required for:
- Temporary files (`CSV`, `logs`, etc.)
- Deleting files via context menu

---

## 📝 Logging

All activity is saved to:
```
Files\Logs\Logfile.txt
```

---

## 🆘 Help

Access help by clicking `Help → About` in the top menu.  
The help file (`Faq.txt`) will be opened with your default text editor.

---

**Powerful pattern searching at your fingertips – with zero scripting knowledge required.** 🕵️‍♂️💻
