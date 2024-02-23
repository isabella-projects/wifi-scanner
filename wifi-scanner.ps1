<#
.SYNOPSIS
    Wi-Fi network scanner.
.DESCRIPTION
    Showing list of all your saved Wi-Fi networks and the corresponding passwords.
.EXAMPLE
    PowerShell > ./wifi-scanner.ps1
.LINK
    https://github.com/isabella-projects/wifi-scanner
.NOTES
    Author: D. Minkov | isabella-projects
    Version: 1.0
#>

try {
    Write-Output @"

██     ██ ██       ███████ ██     ███████  ██████  █████  ███    ██ 
██     ██ ██       ██      ██     ██      ██      ██   ██ ████   ██ 
██  █  ██ ██ █████ █████   ██     ███████ ██      ███████ ██ ██  ██ 
██ ███ ██ ██       ██      ██          ██ ██      ██   ██ ██  ██ ██ 
 ███ ███  ██       ██      ██     ███████  ██████ ██   ██ ██   ████ 
                                                                                                                                                                                
"@
    Write-Output "Press Enter to view Wi-Fi names and passwords..."
    $null = Read-Host

    $wifiProfiles = & netsh wlan show profile | Select-String "All User Profile" | ForEach-Object { $_ -replace "All User Profile\s+:\s+" }

    foreach ($profile in $wifiProfiles) {
        $profile = $profile.Trim()

        $wifiInfo = & netsh wlan show profile name="$profile" key=clear

        $securityKey = ($wifiInfo | Select-String "Key Content\s+:\s+").Line -replace "Key Content\s+:\s+"

        Write-Output "| Wi-Fi Name: $profile"
        Write-Output "| Password: $securityKey"
        Write-Output "----------------------------------------"
    }

    exit 0
} catch {
    Write-Output "Ops! An error occurred on line: $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
