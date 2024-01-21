#!/bin/bash

# Check if GnuPG is installed
if ! command -v gpg &> /dev/null
then
   echo "GnuPG could not be found. Please install it using your package manager."
   exit
fi

# Prompt for user's GitHub username and email
read -p "Enter your GitHub username: " realName
read -p "Enter your GitHub email: " email

# Prompt for password
read -sp "Enter a password for the GPG key: " password
echo

# Generate a GPG Key
cat > tempfile <<EOF
%echo Generating a basic OpenPGP key
Key-Type: RSA
Key-Length: 4096
Name-Real: $realName
Name-Email: $email
Passphrase: $password
Expire-Date: 0
%commit
%echo done
EOF

gpg --batch --gen-key tempfile
rm tempfile

# Get the GPG key ID
keyID=$(gpg --list-secret-keys --keyid-format LONG | grep "^sec" | cut -d "/" -f 2 | cut -d " " -f 1)

# Configure Git
read -p "Enter the alias of the GPG key: " signingKey
git config --global gpg.program $(which gpg)
git config --global commit.gpgsign true
git config --global user.signingkey $keyID
git config --global tag.gpgsign true

# Export the GPG Key
gpgKey=$(gpg --armor --export $keyID)
echo "Please copy the following GPG key and paste it in GitHub:"
echo "$gpgKey"

