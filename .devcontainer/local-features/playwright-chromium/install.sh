#!/bin/bash
set -e

echo "Installing Chromium via Playwright..."

# Install as _REMOTE_USER if set (typically 'vscode'), otherwise as current user
# This ensures browsers are installed in the user's home directory
if [ -n "${_REMOTE_USER}" ] && [ "${_REMOTE_USER}" != "root" ] && id -u "${_REMOTE_USER}" > /dev/null 2>&1; then
    INSTALL_USER="${_REMOTE_USER}"
    USER_HOME=$(eval echo "~${_REMOTE_USER}")
    su "${_REMOTE_USER}" -c "npx -y playwright install chromium --with-deps"
else
    INSTALL_USER="root"
    USER_HOME="/root"
    npx -y playwright install chromium --with-deps
fi

echo "Installed Chromium as user: ${INSTALL_USER}"

# Find the installed Chromium executable
PLAYWRIGHT_CACHE="${USER_HOME}/.cache/ms-playwright"
CHROMIUM_PATH=$(find "$PLAYWRIGHT_CACHE" -path "*/chrome-linux/chrome" -type f 2>/dev/null | head -1)

if [ -z "$CHROMIUM_PATH" ]; then
    # Fallback: look for any chrome executable
    CHROMIUM_PATH=$(find "$PLAYWRIGHT_CACHE" -name "chrome" -type f -executable 2>/dev/null | head -1)
fi

if [ -z "$CHROMIUM_PATH" ]; then
    echo "ERROR: Could not find Chromium executable in $PLAYWRIGHT_CACHE"
    exit 1
fi

echo "Found Chromium at: $CHROMIUM_PATH"

# Create symlinks if enabled (default: true)
if [ "${CREATESYMLINKS}" = "true" ]; then
    # Create symlink at expected Chrome location (used by many tools/MCPs)
    mkdir -p /opt/google/chrome
    ln -sf "$CHROMIUM_PATH" /opt/google/chrome/chrome
    echo "Created symlink: /opt/google/chrome/chrome -> $CHROMIUM_PATH"

    # Create chromium symlink in PATH for convenience
    ln -sf "$CHROMIUM_PATH" /usr/local/bin/chromium
    echo "Created symlink: /usr/local/bin/chromium -> $CHROMIUM_PATH"
fi

echo "Playwright Chromium installation complete"
