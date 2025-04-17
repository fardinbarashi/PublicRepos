# VHDXChecker

<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## 🧾 Overview
**VHDX-Checker** is a PowerShell script designed to automatically monitor and manage the free space of `.vhdx` virtual disks. It mounts VHDX files, checks available disk space, and dynamically resizes disks that fall below a configured free space threshold. Ideal for Hyper-V or lab environments that use fixed-size virtual disks.

> ✅ Requires **Admin privileges**  
> ⚙️ Works only with **fixed-size** `.vhdx` disks  
> 📈 Auto-expands based on a configurable percentage

---

## ✅ Features

- 📦 Mounts all `.vhdx` files (excluding templates) in a specified folder
- 📊 Calculates free space in each virtual disk volume
- 📉 Compares available space against a configurable threshold (default: **20%**)
- ⬆️ Resizes disks dynamically (default: **+20%** increase)
- ⚙️ Generates `diskpart` config files to extend partitions
- 📧 Sends email notifications if any disks were resized
- 🧾 Uses `Start-Transcript` for full logging

---

## 🛠️ Configuration

### Script Settings
You can modify these values at the top of the script:

```powershell
$VhdxShare = "$PSScriptRoot\VhdxShare\"
$DiskPartConfig = "$PSScriptRoot\DiskPartConfig\*.txt"
$Threshold = 20          # % free space threshold
$sizeIncrease = $Size * 0.2  # Resize growth (20%)
```

> ✅ To resize by 10% instead:  
> Change `0.2` to `0.1`

---

## 📁 File & Folder Structure

| Path                                      | Purpose                                 |
|-------------------------------------------|-----------------------------------------|
| `VhdxShare\`                              | Contains the `.vhdx` images             |
| `DiskPartConfig\{timestamp}\*.txt`        | Auto-generated diskpart scripts         |
| `Logs\*.txt`                              | Transcript logs per execution           |

---

## 🧪 Example Flow

1. Script starts and logs execution with timestamp.
2. All `.vhdx` files (excluding templates) are scanned.
3. Each VHDX is mounted and inspected:
   - If free space < 20% → it's resized by +20%
   - `diskpart` config is generated to extend partition
4. Disk is resized and unmounted.
5. Email is sent if any disks were affected.

---

## 📧 Email Notification

If any VHDXs are resized, an alert is sent to:

- **To:** `To@Something.now`
- **From:** `From@Something.now`
- **SMTP Server:** `smtp1.Something.now`

> Email subject:  
> `VHDX-Checker Rapport YYYY/MM/DD/HH.mm.ss`

---

## 📝 Script Metadata

- **Name:** VHDX-Checker  
- **Author:** Fardin Barashi  
- **Version:** 1.0  
- **Release Date:** 2023-01-18  
- **GitHub:** [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## 🧠 Requirements

- PowerShell 5.1+
- Administrator privileges
- System with access to `.vhdx` files
- `diskpart` available in system path

---

## 🛑 Limitations

- Only supports **fixed-size VHDX**
- Only works on **Windows systems**
- Mounted VHDX must not be in use elsewhere (script skips busy files)

---

## 💬 Output Example

```plaintext
The D:\VHDX\MyDisk.vhdx is mounted.
Create CustomObject to D:\VHDX\MyDisk.vhdx
Free space: 15% (threshold 20%) - resizing...
diskpart-config-1234.txt created and executed
```

---

## 🔐 Permissions

> You **must run this script as Administrator**  
> It accesses disk APIs, mounts virtual drives, and runs `diskpart`.

---




