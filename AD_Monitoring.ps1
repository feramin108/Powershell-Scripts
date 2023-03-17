# Set variables
$DomainController = "DC01"
$LogPath = "C:\Logs\ADMonitoring.log"
$AlertThreshold = 10 # Number of failed login attempts before triggering an alert

# Set up event log monitoring
$FilterXML = @"
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and Task = 12544 and (EventID = 4625)]]</Select>
  </Query>
</QueryList>
"@
$EventLog = New-Object System.Diagnostics.Eventing.Reader.EventLogWatcher($FilterXML, $DomainController)

# Set up log file
$LogFile = New-Item $LogPath -ItemType File -Force

# Start monitoring
Write-Host "Starting Active Directory monitoring. Press Ctrl+C to stop."
$EventLog.Start()
while ($true) {
    $Event = $EventLog.EventWaitHandle.WaitOne()
    if ($Event) {
        $EventLog.Events | ForEach-Object {
            $Message = $_.ToXml()
            $Username = ($Message -split '<Data Name="TargetUserName">')[1] -split '</Data>')[0]
            $IPAddress = ($Message -split '<Data Name="IpAddress">')[1] -split '</Data>')[0]
            $EventTime = $_.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
            $EventType = $_.Id
            if ($EventType -eq 4625) {
                Write-Output "$EventTime: Failed login attempt for user $Username from IP address $IPAddress" | Tee-Object -FilePath $LogFile.FullName -Append
                # Send alert if threshold is reached
                $FailedLogins = (Select-String -Path $LogPath -Pattern "Failed login attempt for user $Username" | Measure-Object).Count
                if ($FailedLogins -ge $AlertThreshold) {
                    Write-Output "ALERT: $FailedLogins failed login attempts for user $Username" | Tee-Object -FilePath $LogFile.FullName -Append
                    Send-MailMessage -To "admin@example.com" -From "alerts@example.com" -Subject "Active Directory alert" -Body "ALERT: $FailedLogins failed login attempts for user $Username" -SmtpServer "smtp.example.com"
                }
            }
        }
    }
}
