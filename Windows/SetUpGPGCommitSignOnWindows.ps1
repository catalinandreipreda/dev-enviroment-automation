# Check if GnuPG is installed
$gnupgPath = where.exe gpg
if ($gnupgPath -eq $null) {
   Write-Host "GnuPG is not installed. Please install it using Winget, Chocolatey, or manually from its website."
   exit
}

# Generate a GPG Key
$realName = Read-Host -Prompt 'Enter your GitHub username'
$email = Read-Host -Prompt 'Enter your GitHub email'
gpg --full-generate-key --batch --pinentry-mode loopback --passphrase '' --quick-generate-key "$realName" rsa4096 $email

# Configure Git for Windows
$signingKey = Read-Host -Prompt 'Enter the alias of the GPG key'
git config --global gpg.program $gnupgPath
git config --global commit.gpgsign true
git config --global user.signingkey $signingKey
git config --global tag.gpgsign true


# Export the GPG Key
$gpgKey = gpg --armor --export $signingKey
Write-Host "Please copy the following GPG key and paste it in GitHub:"
Write-Host $gpgKey
