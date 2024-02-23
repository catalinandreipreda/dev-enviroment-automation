#!/bin/bash

# Check if ssh-keygen is installed
if ! command -v ssh-keygen &> /dev/null
then
   echo "ssh-keygen could not be found. Please install it using your package manager."
   exit
fi

# Prompt for key name, email address, and whether to set up password
echo "Generating a new SSH key..."
read -p "Enter a name for the SSH key: " keyName
read -p "Enter your email address: " email
read -s -p "Enter a passphrase for the SSH key (optional): " passphrase
echo

# Generate the SSH key
ssh-keygen -t rsa -b  4096 -C "$email" -f "~/.ssh/$keyName" -N "$passphrase"

# Print the public key
echo "Your SSH public key:"
cat ~/.ssh/$keyName.pub
echo "Copy the above key and add it to your GitHub account."

# Ask if the user wants to use this key for signing commits
read -p "Do you want to use this SSH key to sign your commits by default? (y/n): " answer
if [[ $answer == [yY] || $answer == [yY][eE][sS] ]]
then
    echo "Configuring Git to use this SSH key for signing commits..."
    # Configure Git
    git config --global commit.gpgsign true
    git config --global user.signingkey "$(ssh-keygen -l -f ~/.ssh/$keyName.pub | awk '{print $2}')"
    echo "Git has been configured to use this SSH key for signing commits."
else
    echo "Skipping Git configuration."
fi

echo "SSH key setup complete."
