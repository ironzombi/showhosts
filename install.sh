#!/usr/bin/env bash


install_script() {
  TARGET_DIR=""

  # Check for preferred install location
  if [ -d "$HOME/.bin" ]; then
    TARGET_DIR="$HOME/.bin"
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
  sleep 1
  cp -v ./showhosts.rb "$TARGET_DIR/showhosts"
  chmod +x "$TARGET_DIR/showhosts"
  sleep 1
  echo "updating manpages - requires elevated privs"
  sudo cp -v ./showhosts.1 /usr/local/share/man/man1
  sleep 2
  sudo mandb
  echo "Done."
}

echo "This will install showhosts to $HOME/.bin"
read -p "Proceed ? [y/n]: " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  install_script
else
  echo "stopping install process"
fi
