# !#/usr/bin/env pwsh

# Get the first available emulator name
$DeviceName = & "C:\Users\matt\AppData\Local\Android\Sdk\emulator\emulator.exe" -list-avds | Select-Object -First 1

# Show off that you're about to launch the emulator
Write-Host "Launching emulator for -$DeviceName-"

# Actually launch the emulator
& "C:\Users\matt\AppData\Local\Android\Sdk\emulator\emulator.exe" -avd $DeviceName

