# Set variables
$compromised_system = "CompromisedSystem01"
$isolation_network = "IsolationNetwork"
$forensics_folder = "\\ForensicsServer\Case01"
$threats = @( "TrojanA", "VirusB", "MalwareC" )

# Isolate the compromised system
Write-Host "Isolating $compromised_system on $isolation_network"
Invoke-Command -ComputerName $compromised_system -ScriptBlock {
    Set-NetConnectionProfile -NetworkCategory Private
    New-NetFirewallRule -DisplayName "Block All Inbound Traffic" -Direction Inbound -Action Block
    New-NetFirewallRule -DisplayName "Block All Outbound Traffic" -Direction Outbound -Action Block
}

# Gather forensics data
Write-Host "Collecting forensics data from $compromised_system to $forensics_folder"
New-Item -ItemType Directory -Path $forensics_folder -Name $compromised_system
Copy-Item "\\$compromised_system\C$\Windows\System32\config" "$forensics_folder\$compromised_system\config" -Recurse
Copy-Item "\\$compromised_system\C$\Windows\System32\winevt\Logs" "$forensics_folder\$compromised_system\logs" -Recurse
Copy-Item "\\$compromised_system\C$\Program Files" "$forensics_folder\$compromised_system\programs" -Recurse

# Remove threats
foreach ($threat in $threats) {
    Write-Host "Removing $threat from $compromised_system"
    Invoke-Command -ComputerName $compromised_system -ScriptBlock {
        Get-MpThreat -ThreatName $using:threat | Remove-MpThreat -Force
    }
}

# Restore the compromised system
Write-Host "Restoring $compromised_system from isolation"
Invoke-Command -ComputerName $compromised_system -ScriptBlock {
    Set-NetConnectionProfile -NetworkCategory Private
    Get-NetFirewallRule -DisplayName "Block All Inbound Traffic" | Remove-NetFirewallRule
    Get-NetFirewallRule -DisplayName "Block All Outbound Traffic" | Remove-NetFirewallRule
}
