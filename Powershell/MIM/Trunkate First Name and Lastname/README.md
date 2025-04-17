# TrunkateFirstNameAndLastName
<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.



# 📝 MIM Name Truncator Script

## 🔍 Overview

This PowerShell script fetches **active users from Microsoft Identity Manager (MIM)** and validates the length of their **first names and last names**. If any names exceed the specified character limits (20 for first name, 30 for last name), they are logged into separate text files for review or manual correction.

---

## ✅ Features

- ✅ Connects to MIM and queries all active users
- ✂️ Truncates:
  - First names to **20 characters**
  - Last names to **30 characters**
- 💡 Validates name lengths
- 🧾 Logs problematic entries to separate `.txt` files
- 📁 Outputs full user list to a CSV file

---

## ⚙️ Requirements

| Requirement         | Value                          |
|---------------------|---------------------------------|
| PowerShell Version  | 5.1 or later                    |
| Module              | `LithnetRMA`                   |
| Access              | MIM Web Service (`http://localhost:5725`) |
| Run As              | Administrator (for full access) |

---

## 📂 Output Files

| File                                 | Description                            |
|--------------------------------------|----------------------------------------|
| `RootFileFromMim_YYYYMMDD.csv`       | Full user export from MIM              |
| `TruncateFirstName_YYYYMMDD.txt`     | Users with **too long first names**    |
| `TruncateLastName_YYYYMMDD.txt`      | Users with **too long last names**     |

---

## 🧾 Attributes Exported

| Column         | Description                        |
|----------------|------------------------------------|
| Company        | Placeholder value: `"CompanyName"` |
| LegalEntity    | Placeholder value: `"LegalEntityName"` |
| UniqueID       | `AccountName` from MIM             |
| FirstName      | Truncated to 20 characters         |
| LastName       | Truncated to 30 characters         |
| EmailAdress    | User email from MIM                |
| Title          | `"mr"` or `"ms"` based on gender   |
| PhoneMobile    | Mobile phone, dashes removed       |

---

## 🧪 Sample Output (CSV)

```
Company|LegalEntity|UniqueID|FirstName|LastName|EmailAdress|Title|PhoneMobile
CompanyName|EntityX|jdoe|JohnathanAlexander|DoeingtonTheSecond|jdoe@lab.local|mr|0701234567
```

---

## 🔄 Script Workflow

### Step 1: Connect to MIM

- Imports the `LithnetRMA` module
- Connects to `localhost:5725` to query FIM resources

### Step 2: Export Users from MIM

- Uses XPath to query active users with:
  - Non-terminated status
  - Valid email domain `@lab.local`
  - Set first and last names
- Extracts attributes, truncates names, and writes to CSV

### Step 3: Validate Name Lengths

- Reads the exported CSV
- Logs any first names longer than 20 characters into:
  - `TruncateFirstName_YYYYMMDD.txt`
- Logs any last names longer than 30 characters into:
  - `TruncateLastName_YYYYMMDD.txt`

---

## 🧠 Tips

- ✏️ Placeholder values like `"CompanyName"` and `"LegalEntityName"` can be adjusted as needed.
- 🔄 You can integrate this into a pipeline that flags issues before provisioning into another system (e.g. AD, HRM).
- 🧪 Add more validation rules if needed, like checking for invalid characters.

---

## 📓 Metadata

| Property         | Value                                         |
|------------------|-----------------------------------------------|
| **Author**       | Fardin Barashi                                |
| **Script Name**  | MIM Name Truncator                            |
| **Version**      | 1.0                                           |
| **Release Date** | *(Auto-generates dated logs and filenames)*   |
| **GitHub**       | [github.com/fardinbarashi](https://github.com/fardinbarashi) |

---

## ✨ Output Example (Validation Log)

```txt
NOT OK, must truncate Fname! JohnathanAlexander = 22
JohnathanAlexander
NOT OK, must truncate Lname! DoeingtonTheSecondExtraLong = 33
DoeingtonTheSecondExtraLon
```





