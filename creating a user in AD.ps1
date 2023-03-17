# Prompt for user information
$firstName = Read-Host "Enter the first name of the new user"
$lastName = Read-Host "Enter the last name of the new user"
$username = Read-Host "Enter the username for the new user"
$password = Read-Host "Enter the password for the new user" -AsSecureString
$email = Read-Host "Enter the email address for the new user"
$ou = "OU=Users,OU=Test,DC=example,DC=com"

# Create new user object
$newUser = New-Object -TypeName System.DirectoryServices.AccountManagement.UserPrincipal -ArgumentList ([System.DirectoryServices.AccountManagement.PrincipalContext]::Current)

# Set user properties
$newUser.GivenName = $firstName
$newUser.Surname = $lastName
$newUser.Name = "$firstName $lastName"
$newUser.UserPrincipalName = $username
$newUser.EmailAddress = $email
$newUser.SetPassword([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)))
$newUser.Save()

# Move user to designated OU
Move-ADObject -Identity $newUser.DistinguishedName -TargetPath $ou

# Display confirmation message
Write-Host "New user $firstName $lastName has been created and moved to $ou"
