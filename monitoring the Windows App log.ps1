# This script monitors the Windows Application Event Log for specific Event IDs and sends an email alert when they are detected.

$serverName = "localhost" # Replace with the name of the server you want to monitor
$emailFrom = "sender@example.com" # Replace with your email address
$emailTo = "recipient@example.com" # Replace with the email address to send alerts to
$smtpServer = "smtp.example.com" # Replace with your SMTP server address
$eventIds = @(100, 200, 300) # Replace with an array of Event IDs to monitor

while($true) {
    $events = Get-WinEvent -LogName Application -ComputerName $serverName -FilterXPath "*[System[(EventID=$($eventIds -join ' or '))] and TimeCreated[timediff(@SystemTime) <= 60000]]" # Change the TimeCreated filter as needed
    if($events.Count -gt 0) {
        $message = "The following events were detected on $serverName:`n`n"
        foreach($event in $events) {
            $message += "Event ID $($event.Id)`n"
            $message += "Message: $($event.Message)`n"
            $message += "Logged: $($event.TimeCreated)`n`n"
        }
        Send-MailMessage -From $emailFrom -To $emailTo -Subject "Event log alert on $serverName" -Body $message -SmtpServer $smtpServer
    }
    Start-Sleep -Seconds 60 # Change the sleep time as needed
}
