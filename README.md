# Cloud Backup Scripts

This repository contains batch scripts to automate the backup and restoration of game save files between local folders and the cloud.

## Requirements

- Windows 11 or ROBOCOPY

## Scripts

- **get_from_cloud.bat**  
  Restores `.sav` files from the cloud to the local folder, keeping a backup of overwritten files.

- **send_to_cloud.bat**  
  This script is intended to upload `.sav` files from your local folder to the cloud folder, making a backup of any files that will be overwritten in the cloud.  

## How to use

### 1. Create the `paths.ini` file

The `paths.ini` file is **not included** in the repository. You must create it manually in the same folder as the scripts, using the following format:

```ini
[Paths]
SourceDir=C:\PATH\TO\YOUR\CLOUD\FOLDER
DestDir=C:\PATH\TO\YOUR\LOCAL\FOLDER
```

- **SourceDir**: Path to the source folder (e.g., your cloud folder).
- **DestDir**: Path to the destination folder (e.g., your local saves folder).

> **Important:** Use full paths and do not remove the `[Paths]` section.

### 2. Run the script

Double-click the desired `.bat` file or run it from the Windows terminal:

```cmd
get_from_cloud.bat
```

The script will:
- Read the paths from the `paths.ini` file.
- Check if the folders exist.
- Backup current `.sav` files from the destination folder to a `backup\got` subfolder.
- Copy all `.sav` files from the source to the destination, except for `Save_Settings.sav`.
- Generate a detailed log in `get_from_cloud.copy.log` or `send_to_cloud.copy.log`.

### 3. Logs
Each script generates its own log file:  
- `get_from_cloud.bat` creates `get_from_cloud.copy.log`
- `send_to_cloud.bat` creates `send_to_cloud.copy.log`

These log files are saved in the same folder as the script and contain details of all operations performed.


## Using to Steam
in case to use with a Steam Game to force or fix the cloud game function you can use following command in the games property:
 c:\scripts\path\get_from_cloud.bat; %command%; c:\scripts\path\send_to-cloud.bat;


## Notes

- Make sure the `paths.ini` file is correctly filled before running the scripts.
- The script automatically backs up overwritten files.
- The script depends on the `ROBOCOPY` utility, which is included in modern versions of Windows.

---

**Warning:**  
Always review the paths set in `paths.ini` to avoid losing important data.