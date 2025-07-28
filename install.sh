#!/bin/bash

TARGET_DIR=""

# Check for preferred install location
if [ -d "$HOME/bin" ]; then
  TARGET_DIR="$HOME/bin"
elif [ -d "/usr/local/bin" ]; then
  TARGET_DIR="/usr/local/bin"
elif [ -d "/opt/bin" ]; then
  TARGET_DIR="/opt/bin"
else
  echo "No suitable install directory found!"
  exit 1
fi

# Now copy the script
echo "Installing to $TARGET_DIR..."
cp ./showhosts.rb "$TARGET_DIR/showhosts"
chmod +x "$TARGET_DIR/showhosts"
cp ./showhosts.1 /usr/local/share/man/man1
echo "updating manpages - requires elevated privs" 
sudo mandb
echo "Done."

