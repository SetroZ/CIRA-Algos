#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define variables for CFITSIO
CFITSIO_VERSION="4.5.0"
CFITSIO_URL="https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-${CFITSIO_VERSION}.tar.gz"
INSTALL_DIR="/usr/local"

# Define variables for CCfits
CCFITS_VERSION="2.6"
CCFITS_URL="https://heasarc.gsfc.nasa.gov/fitsio/ccfits/CCfits-${CCFITS_VERSION}.tar.gz"

# Function to check if CFITSIO is installed
check_cfitsio() {
    if [ -f "/usr/local/lib/libcfitsio.so" ] || [ -f "/usr/local/lib/libcfitsio.a" ]; then
        echo "CFITSIO is already installed."
        return 0
    else
        return 1
    fi
}

# Function to check if CCfits is installed
check_ccfits() {
    if [ -f "/usr/local/lib/libCCfits.so" ] || [ -f "/usr/local/lib/libCCfits.a" ]; then
        echo "CCfits is already installed."
        return 0
    else
        return 1
    fi
}

# Check for CFITSIO
if ! check_cfitsio; then
    cfitsio_installed=0
else
    cfitsio_installed=1
fi

# Check for CCfits
if ! check_ccfits; then
    ccfits_installed=0
else
    ccfits_installed=1
fi

# If both are installed, exit the script
if [ $cfitsio_installed -eq 1 ] && [ $ccfits_installed -eq 1 ]; then
    echo "Both CFITSIO and CCfits are already installed. Exiting."
    exit 0
fi

# Update package list and install necessary dependencies
echo "Updating package list..."
sudo apt-get update

echo "Installing build dependencies..."
sudo apt-get install zlib1g-dev
sudo apt-get install -y build-essential

# Download CFITSIO if not installed
if [ $cfitsio_installed -eq 0 ]; then
    echo "Downloading CFITSIO version ${CFITSIO_VERSION}..."
    wget $CFITSIO_URL -O cfitsio.tar.gz

    # Extract and install CFITSIO
    echo "Extracting CFITSIO..."
    tar -xzf cfitsio.tar.gz
    cd cfitsio-${CFITSIO_VERSION}

    echo "Configuring CFITSIO..."
    ./configure --prefix=$INSTALL_DIR

    echo "Building CFITSIO..."
    make

    echo "Installing CFITSIO..."
    sudo make install

    # Clean up CFITSIO
    cd ..
    rm -rf cfitsio-${CFITSIO_VERSION} cfitsio.tar.gz
fi

# Download CCfits if not installed
if [ $ccfits_installed -eq 0 ]; then
    echo "Downloading CCfits version ${CCFITS_VERSION}..."
    wget $CCFITS_URL -O CCfits.tar.gz

    # Extract and install CCfits
    echo "Extracting CCfits..."
    tar -xzf CCfits.tar.gz
    cd CCfits-${CCFITS_VERSION}

    echo "Configuring CCfits with CFITSIO..."
    ./configure --with-cfitsio=$INSTALL_DIR

    echo "Building CCfits..."
    make

    echo "Installing CCfits..."
    sudo make install

    # Clean up CCfits
    cd ..
    rm -rf CCfits-${CCFITS_VERSION} CCfits.tar.gz
fi

# Update LD_LIBRARY_PATH
echo "Updating LD_LIBRARY_PATH..."
echo 'export LD_LIBRARY_PATH="$INSTALL_DIR/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
source ~/.bashrc

echo "CCfits installation completed successfully!"
