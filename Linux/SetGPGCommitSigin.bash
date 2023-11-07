#!/bin/bash

# Check if GnuPG is installed
if ! command -v gpg &> /dev/null
then
   echo "GnuPG could not be found. Please install it using your package manager."
   exit
fi

# Generate a GPG Key
read -p "Enter your GitHub username: " realName
read -p "Enter your GitHub email: " email
gpg --full-generate-key --batch --pinentry-mode loopback --passphrase '' --quick-generate-key "$realName" rsa4096 $email

# Configure Git
read -p "Enter the alias of the GPG key: " signingKey
git config --global gpg.program $(which gpg)
git config --global commit.gpgsign true
git config --global user.signingkey $signingKey
git config --global tag.gpgsign true

# Export the GPG Key
gpgKey=$(gpg --armor --export $signingKey)
echo "Please copy the following GPG key and paste it in GitHub:"
echo "$gpgKey"
