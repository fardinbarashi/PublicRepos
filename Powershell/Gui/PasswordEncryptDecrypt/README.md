# PasswordEncryptDecrypt

<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

# PasswordEncryptDecrypt (PowerShell GUI)

## 🔐 Overview
**PasswordEncryptDecrypt** 
is a simple, GUI-based PowerShell tool that allows you to securely encrypt and decrypt passwords. It uses the current user context, meaning only the user who encrypted the password can later decrypt it — ensuring local security without the need for third-party tools.
---

## ✅ Features
- 🔒 Encrypt any password and save it to a file
- 🔓 Decrypt passwords by selecting the encrypted file
- 🪟 Clean Windows Forms GUI for easy interaction
- 📁 Integrated file explorer for selecting output paths
- 🧾 Transcript logging for auditing and troubleshooting

---

## 💻 System Requirements

| Requirement              | Version                  |
|--------------------------|--------------------------|
| PowerShell Version       | 5.1.19041.2364 or later  |
> 🔐 **Note:** Encrypted passwords can only be decrypted by the same user and on the same system they were encrypted on.

---

## 🛠️ How to Use

### 🧾 Encrypt a Password

1. **Run the script** (double-click or via PowerShell).
2. Enter your password in the top textbox.
3. Specify a file path where you want to save the encrypted password, or use the built-in **"Open FileExplorer"** button.
4. Click **"Save Encrypt Password"**.
5. Done! Your password is now encrypted and saved to a file (e.g., `C:\Temp\Password.txt`).

### 🔍 Decrypt a Password

1. In the menu bar, go to **Decrypt File → Select-File to Decrypt**.
2. Browse and select the file containing your encrypted password.
3. The decrypted password will appear in the status bar at the bottom of the form.

---

## 📦 GUI Elements

- **Main Window Title:** `Password Encrypter 1.0`
- **Top Menu:**
  - `File → Close` — Closes the GUI
  - `Decrypt File → Select-File to Decrypt` — Opens file dialog to decrypt password
- **Status Bar:** Displays current action and decrypted password
- **Text Fields:**
  - Password input
  - File path for saving encrypted password
- **Buttons:**
  - Open File Explorer
  - Save Encrypted Password

---

## 📓 Script Metadata

- **Author:** Fardin Barashi  
- **Title:** PasswordEncryptDecrypt  
- **Version:** 1.0  
- **Release Date:** 2024-09-07  
- **GitHub:** [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## ⚠️ Security Notes

- This script uses PowerShell's built-in secure string methods.
- Encryption is user- and machine-specific.  
- It’s a good practice not to share encrypted password files between systems or users.

---

## 🧪 Example

```plaintext
Encrypting Password 0%...
Encrypting Password 100%...
Encrypting Password 100%... Saved Password to a file C:\Temp\Password.txt
```

```plaintext
The Password is : MySuperSecurePassword!
```

---

## 📝 Log File

All actions are logged via transcript to:
```
<ScriptDirectory>\Logs\PasswordEncryptDecrypt - yyyy/MM/dd/HH.mm.ss.txt
```

---


