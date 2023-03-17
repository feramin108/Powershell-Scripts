
#Add a firewall rule to allow incoming traffic on a specific port:#
New-NetFirewallRule -DisplayName "Allow inbound traffic on port 80" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow

#Add a firewall rule to allow outgoing traffic on a specific port:#
New-NetFirewallRule -DisplayName "Allow outbound traffic on port 443" -Direction Outbound -LocalPort 443 -Protocol TCP -Action Allow

# Enable the Windows Firewall:#
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
# Block incoming traffic from a specific IP address:#
New-NetFirewallRule -DisplayName "Block incoming traffic from 192.168.1.100" -Direction Inbound -RemoteAddress 192.168.1.100 -Protocol Any -Action Block

# Allow incoming traffic from a specific IP address:# 

New-NetFirewallRule -DisplayName "Allow incoming traffic from 192.168.1.100" -Direction Inbound -RemoteAddress 192.168.1.100 -Protocol Any -Action Allow
