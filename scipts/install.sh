#!/bin/bash 
set -x

GITLEAKS_VERSION="8.18.1"
GITLEAKS_RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}"

# Step 1: Create pre-commit hook file
HOOK_FILE=".git/hooks/pre-commit"

# Check if pre-commit hook file already exists
if [ -e "$HOOK_FILE" ]; then
  echo "Error: pre-commit hook file already exists."
  exit 1
fi

# Create pre-commit hook file
echo "#!/bin/bash" > "$HOOK_FILE"
chmod +x "$HOOK_FILE"

# Step 2: Add the script to the pre-commit hook file
cat <<EOL >> "$HOOK_FILE"
#!/bin/bash

ENABLE_GITLEAKS=\$(git config --get hooks.gitleaks.enable)

if [ "\$ENABLE_GITLEAKS" != "true" ]; then
  exit 0
fi

if ! command -v gitleaks &> /dev/null; then
  echo "Gitleaks is not installed. Please install it and run this script again."
  exit 1
fi

gitleaks protect --staged
gitleaks detect --redact  -v

if [ \$? -ne 0 ]; then
  echo "Error: Secrets found in the code. Commit rejected."
  exit 1
fi

exit 0
EOL

# Step 3: Prompt user to install Gitleaks
if ! command -v gitleaks &> /dev/null; then
  echo "Gitleaks is not installed. Please install it and run this script again."
  exit 1
fi

read -p "Gitleaks is not installed. Do you want to install it now? (y/n): " INSTALL_GITLEAKS

if [ "$INSTALL_GITLEAKS" == "y" ]; then
  if [ "$(uname)" == "Darwin" ]; then
    # Install Gitleaks on macOS
    curl -sSL "${GITLEAKS_RELEASE_URL}/gitleaks_${GITLEAKS_VERSION}_darwin_arm64.tar.gz" | tar -xz -C /tmp
    sudo mv /tmp/gitleaks /usr/local/bin/gitleaks
  elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Install Gitleaks on Linux
    curl -sSL "${GITLEAKS_RELEASE_URL}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz" | tar -xz -C /tmp
    sudo mv /tmp/gitleaks /usr/local/bin/gitleaks
  else
    echo "Unsupported operating system"
    exit 1
  fi

  echo "Gitleaks ${GITLEAKS_VERSION} installed successfully."
else
  echo "Gitleaks not installed. Committing without Gitleaks checks."
fi

echo "Installation complete. pre-commit hook is configured to use gitleaks."
