# Set variables for patch management
$WindowsUpdate = New-Object -ComObject Microsoft.Update.ServiceManager
$Session = $WindowsUpdate.CreateUpdateServiceManager().AddScanPackageService('Offline Sync Service', 'C:\wsusscn2.cab')
$Searcher = $Session.CreateUpdateSearcher()
$Updates = $Searcher.Search('IsInstalled=0 and Type="Software" and IsHidden=0').Updates

# Download and install updates
foreach ($Update in $Updates) {
    Write-Host "Downloading $($Update.Title)..."
    $Downloader = $WindowsUpdate.CreateUpdateDownloader()
    $Downloader.Updates = $Update
    $Downloader.Download()

    Write-Host "Installing $($Update.Title)..."
    $Installer = $WindowsUpdate.CreateUpdateInstaller()
    $Installer.Updates = $Update
    $InstallResult = $Installer.Install()

    if ($InstallResult.ResultCode -eq '2') {
        Write-Host "Requires reboot"
    } elseif ($InstallResult.ResultCode -ne '2' -and $InstallResult.ResultCode -ne '0') {
        Write-Host "Error $($InstallResult.ResultCode): $($InstallResult.ResultMessage)"
    }
}

# Restart the system if required
if ($Updates | Where-Object { $_.InstallationBehavior.CanRequestUserInput -eq $false -and $_.InstallationBehavior.RebootBehavior -ne 'NeverReboots' }) {
    Restart-Computer -Force
}
