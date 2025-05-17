@ECHO OFF
REM Lê variáveis do arquivo paths.ini
SET "IniFile=paths.ini"

REM Função para ler valor de chave em seção [Paths]
FOR /F "tokens=1,* delims==" %%A IN ('findstr /R /C:"^SourceDir=" "%IniFile%"') DO SET "DestDir=%%B"
FOR /F "tokens=1,* delims==" %%A IN ('findstr /R /C:"^DestDir=" "%IniFile%"') DO SET "SourceDir=%%B"

REM Define the log file name - it will be created in the current directory
SET LogFile="copy.log"

REM Define the backup directory path (inside the destination folder)
SET BackupDir=.\backup\got

ECHO SourceDir: "%SourceDir%"
ECHO DestDir: %DestDir%
ECHO BackupDir: %BackupDir%
ECHO.

ECHO Checking if Source directory exists...
IF NOT EXIST "%SourceDir%" (
    ECHO ERROR: Source directory not found!
    ECHO Path: %SourceDir%
    ECHO Please check the path and try again.
    ECHO.
    PAUSE
    GOTO :EOF
) ELSE (
    ECHO Source directory found: %SourceDir%
)
ECHO.

ECHO Checking if Destination directory exists...
IF NOT EXIST "%DestDir%" (
    ECHO ERROR: Destination directory not found!
    ECHO Path: %DestDir%
    ECHO Please check the path and try again.
    ECHO If the path is correct, please ensure the directory exists before running the script.
    PAUSE
    GOTO :EOF
) ELSE (
    ECHO Destination directory found: %DestDir%
)
ECHO.

ECHO Creating or overwriting log file in current directory: %LogFile%
ECHO Copy Log - Started at: %DATE% %TIME% > %LogFile%
ECHO ===================================================== >> %LogFile%
ECHO Copying from: %SourceDir% >> %LogFile%
ECHO To:           %DestDir% >> %LogFile%
ECHO File Pattern: "*.sav" >> %LogFile%
ECHO Excluding File: "Save_Settings.sav" >> %LogFile%
ECHO ===================================================== >> %LogFile%
ECHO Files copied: >> %LogFile%
ECHO. >> %LogFile%

ECHO Ensuring backup directory exists: %BackupDir%
IF NOT EXIST "%BackupDir%" (
    ECHO Creating backup directory: %BackupDir% >> %LogFile%
    ECHO Creating backup directory: %BackupDir%
    MKDIR "%BackupDir%"
    IF ERRORLEVEL 1 (
        ECHO ERROR: Could not create backup directory %BackupDir%. Check permissions. >> %LogFile%
        ECHO ERROR: Could not create backup directory %BackupDir%. Check permissions.
        PAUSE
        GOTO :EOF
    ) ELSE (
        ECHO Backup directory created successfully. >> %LogFile%
        ECHO Backup directory created successfully.
    )
) ELSE (
    ECHO Backup directory already exists. >> %LogFile%
    ECHO Backup directory already exists.
)
ECHO. >> %LogFile%
ECHO.

ECHO Starting PRE-BACKUP: Backing up current destination files to %BackupDir%...
ECHO PRE-BACKUP Phase - %DATE% %TIME% >> %LogFile%
REM Backup current destination files (*.sav excluding Save_Settings.sav) to the backup folder
REM /MIR ensures the backup folder is an exact mirror (older backup files might be deleted if not in DestDir anymore)
ROBOCOPY "%DestDir%" %BackupDir% *.sav /XF Save_Settings.sav /MIR /COPY:DATS /R:2 /W:5 /NP /NJH /NJS /LOG+:%LogFile% /TEE
IF %ERRORLEVEL% GEQ 8 (
    ECHO WARNING: Errors occurred during pre-backup to %BackupDir%. Check log. >> %LogFile%
    ECHO WARNING: Errors occurred during pre-backup to %BackupDir%. Check log.
    ECHO (This might be okay if the destination was empty or had no matching files to backup)
) ELSE (
    ECHO Pre-backup of destination files to %BackupDir% completed. >> %LogFile%
    ECHO Pre-backup of destination files to %BackupDir% completed.
)
ECHO ===================================================== >> %LogFile%
ECHO. >> %LogFile%
ECHO.

ECHO Starting MAIN COPY: Copying files from %SourceDir% to %DestDir%...
ECHO MAIN COPY Phase - %DATE% %TIME% >> %LogFile%
REM Main copy operation from Source to Destination
REM /IS ensures all source files overwrite destination files
ROBOCOPY "%SourceDir%" "%DestDir%" *.sav /XF Save_Settings.sav /E /IS /COPY:DATS /NP /NDL /NJH /NJS /LOG+:%LogFile% /TEE /R:3 /W:5

REM Note: /E copies all subdirectories, including empty ones.
REM Note: /IS includes "Same" files, forcing overwrite even if files seem identical.

ECHO Checking copy process results...
REM Check Robocopy's exit code (Exit Code < 8 usually means success)
IF %ERRORLEVEL% GEQ 8 (
    ECHO ===================================================== >> %LogFile%
    ECHO ERROR: Errors occurred during the copy process. Check log above. >> %LogFile%
    ECHO ===================================================== >> %LogFile%
    ECHO Copy process finished with ERRORS.
) ELSE (
    ECHO ===================================================== >> %LogFile%
    ECHO Copy process finished successfully at: %DATE% %TIME% >> %LogFile%
    ECHO ===================================================== >> %LogFile%
    ECHO Copy process finished successfully.
)

ECHO.
ECHO The operation log has been saved to %CD%\%LogFile%
PAUSE