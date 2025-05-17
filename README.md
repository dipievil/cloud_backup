# Cloud Backup Scripts

This repository contains batch scripts to automate the backup and restoration of game save files between local folders and the cloud.

## Scripts

- **get_from_cloud.bat**  
  Restores `.sav` files from the cloud to the local folder, keeping a backup of overwritten files.

- **send_to_cloud.bat**  
  (Not included in this repository, but a complementary script is expected to upload local files to the cloud.)

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
- Generate a detailed log in `copy.log`.

### 3. Logs

The `copy.log` file will be created in the same folder as the script, containing details of all operations performed.

## Notes

- Make sure the `paths.ini` file is correctly filled before running the scripts.
- The script automatically backs up overwritten files.
- The script depends on the `ROBOCOPY` utility, which is included in modern versions of Windows.

---

**Warning:**  
Always review the paths set in `paths.ini` to avoid losing important data.