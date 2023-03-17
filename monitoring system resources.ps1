# Set up the counter objects for monitoring CPU, memory, and disk usage
$cpuCounter = New-Object System.Diagnostics.PerformanceCounter("Processor", "% Processor Time", "_Total")
$memCounter = New-Object System.Diagnostics.PerformanceCounter("Memory", "Available MBytes")
$diskCounter = New-Object System.Diagnostics.PerformanceCounter("PhysicalDisk", "% Disk Time", "_Total")

# Loop through and monitor the system resources every 5 seconds
while ($true) {
    $cpuUsage = $cpuCounter.NextValue()
    $memUsage = $memCounter.NextValue()
    $diskUsage = $diskCounter.NextValue()
    
    Write-Host "CPU usage: $($cpuUsage)%"
    Write-Host "Memory usage: $($memUsage) MB"
    Write-Host "Disk usage: $($diskUsage)%"
    
    Start-Sleep -Seconds 5
}
