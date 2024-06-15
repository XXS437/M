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
