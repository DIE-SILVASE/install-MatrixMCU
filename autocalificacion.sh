#!/bin/bash

# Create a directory for the project
mkdir ./project
mv * ./project/

# Update package list
sudo apt update

# Install build-essential
sudo apt install build-essential

# Install cmake
# sudo apt install cmake
sudo snap install cmake --classic

# Install openocd
sudo apt install openocd

# Install gdb multiarch
sudo apt install gdb-multiarch

# Create directories for the tools used in MatrixMCU course
sudo mkdir /opt/MatrixMCU
sudo mkdir /opt/MatrixMCU/bin

# Download arm toolchain zip file
wget https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz -O /tmp/arm-toolchain.tar.xz
# Uncompress arm toolchain zip file in /usr/share directory
sudo tar -xf /tmp/arm-toolchain.tar.xz -C /opt/MatrixMCU

# Create symbolic links to arm toolchain in /opt/MatrixMCU/bin
sudo ln -s /opt/MatrixMCU/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-gcc /opt/MatrixMCU/bin/arm-none-eabi-gcc
sudo ln -s /opt/MatrixMCU/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-g++ /opt/MatrixMCU/bin/arm-none-eabi-g++
sudo ln -s /opt/MatrixMCU/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-objcopy /opt/MatrixMCU/bin/arm-none-eabi-objcopy
sudo ln -s /opt/MatrixMCU/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-objdump /opt/MatrixMCU/bin/arm-none-eabi-objdump

# Get the path to gdb-multiarch...
GDB_MULTIARCH_PATH=$(which gdb-multiarch)
# ... and create a symbolic link to gdb-multiarch in /opt/MatrixMCU/bin with the name arm-none-eabi-gdb
sudo ln -s $GDB_MULTIARCH_PATH /opt/MatrixMCU/bin/arm-none-eabi-gdb

# Add /opt/MatrixMCU/bin to PATH
echo 'export PATH=/opt/MatrixMCU/bin:$PATH # Required for MatrixMCU toolkit' >> ~/.bashrc

# Clones the matrixmcu repository
git clone --recursive -b dev-multiplatform https://github.com/DIE-SILVASE/MatrixMCU/tree/dev-multiplatform

# Moves the project to the projects directory
mv -a project/ ./projects/

# downloads our version of qemu-system-arm (and all required dependencies)
sudo apt install sunxi-tools

curl -L -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/greenlsi/qemu_new/releases/latest | jq -r '.assets[0].browser_download_url' | xargs wget -q

tar -xvf qemu-system-arm.tar.xz -C $(pwd)