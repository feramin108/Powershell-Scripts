# Set the scan parameters
$ScanType = 1 # 0 = Quick scan, 1 = Full scan, 2 = Custom scan
$ScanPath = "C:\"
$RemediationOption = 2 # 0 = No action, 1 = Quarantine, 2 = Remove, 3 = Allow

# Initiate the scan
$Scan = New-Object -ComObject Microsoft.SMS.Client

# Configure the scan settings
$ScanSettings = $Scan.Configuration
$ScanSettings.ScanType = $ScanType
$ScanSettings.ScanPath = $ScanPath
$ScanSettings.RemediationOption = $RemediationOption

# Start the scan
$ScanResult = $Scan.Scan()

# Check the scan results
if ($ScanResult.ResultCode -eq 0) {
    Write-Output "Scan completed successfully."
    if ($ScanResult.ThreatCount -gt 0) {
        Write-Output "Removing detected threats..."
        $RemediationResult = $Scan.RemoveThreats()
        if ($RemediationResult.ResultCode -eq 0) {
            Write-Output "Threats removed successfully."
        } else {
            Write-Output "Error removing threats: $($RemediationResult.ResultDescription)"
        }
    } else {
        Write-Output "No threats detected."
    }
} else {
    Write-Output "Error running scan: $($ScanResult.ResultDescription)"
}
