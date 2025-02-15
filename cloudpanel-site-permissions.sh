#!/bin/bash
# ==============================================================================
# Script Name:       cloudpanel-site-permissions.sh
# Description:       Set correct file permissions for Cloudpanel website files
# Compatibility:     Linux (Debian/Ubuntu)
# Author:            WP Speed Expert
# Author URI:        https://wpspeedexpert.com
# Version:           1.0.0
# GitHub:            https://github.com/WPSpeedExpert/cloudpanel-site-permissions
# ==============================================================================

# Configuration
site_user="site-user"                      # User that should own the files
domain_name="www.domain.com"                 # Domain name
website_path="/home/${site_user}/htdocs/${domain_name}"  # Path to website files
LOG_FILE="/home/${site_user}/permissions.log"   # Log file location

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

# Function to check if directory exists
check_directory() {
    if [ ! -d "${website_path}" ]; then
        log_message "ERROR: Website directory not found: ${website_path}"
        exit 1
    fi
}

# Function to set permissions
set_permissions() {
    log_message "Starting permission updates..."
    
    # Set ownership
    log_message "Setting ownership to ${site_user}:${site_user}"
    chown -R ${site_user}:${site_user} ${website_path}
    
    # Set directory permissions
    log_message "Setting directory permissions to 755"
    find ${website_path} -type d -exec chmod 755 {} \;
    
    # Set file permissions
    log_message "Setting file permissions to 644"
    find ${website_path} -type f -exec chmod 644 {} \;
    
    # Make specific directories writable
    log_message "Setting writable permissions for specific directories"
    chmod -R 775 ${website_path}/application/cache
    chmod -R 775 ${website_path}/application/logs
    chmod -R 775 ${website_path}/application/sessions
    
    log_message "Permission update completed successfully"
}

# Main execution
main() {
    log_message "Starting permission fix process"
    
    # Check directory exists
    check_directory
    
    # Set permissions
    set_permissions
    
    log_message "Process completed successfully"
}

# Run main function
main
