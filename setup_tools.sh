#!/bin/bash

# Installing GCSFUSE - tool to mount google cloud buckets

# Add the Cloud Storage FUSE repository
# Import the Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# do this before sudo update in order to also update the Google Cloud repo
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

# -- Update and upgrade
sudo apt-get update -y && sudo apt-get upgrade -y

# -- Install miniconda for current stable Python release
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3*.sh

# -- Add R repo to apt, then use it to install R
sudo apt install dirmngr gnupg apt-transport-https ca-certificates \
    software-properties-common
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
    E298A3A825C0D65DFD57CBB651716619E084DAB9
# Add the CRAN repository to the apt sources list
echo "deb https://cloud.r-project.org/bin/linux/debian $(lsb_release -cs)-cran40/" | sudo tee /etc/apt/sources.list.d/r.list


# -- Install apt useful packages
#
apt_pkgs=(
    # system deps
    'libcurl4-openssl-dev' 'libssl-dev' 'libxml2-dev' 'build-essential'
    'libsodium-dev' 'libopenblas-dev' 'gnupg2'
    # databases
    'sqlite' 'mariabd-server-10.3' 'mariadb-server' 
    'libmariadbclient-dev'
    # CLI tools
    'git'  'pigz'  'htop' 'thefuck' 'silversearcher-ag' 'parallel' 'tree'
    # GCP tools
    'fuse' 'gcsfuse'
    # programming languages
    'r-base'
)

# appends an environment variable export command to the ~/.bashrc file. 
# This command sets the LD_LIBRARY_PATH variable to /usr/lib/openblas-base/, which is the path to the OpenBLAS library.
echo "export LD_LIBRARY_PATH=/usr/lib/openblas-base/" >> ~/.bashrc

q
# iterate over each package in the apt_pkgs array and uses apt-get to install them with the -y flag, 
# which automatically confirms any prompts that may appear during the installation process. 
for pkg in "${apt_pkgs[@]}"
do
    sudo apt-get install -y "$pkg"
done

# Install Cloud Storage FUSE
sudo apt-get install 


# # Install s3cmd
#  commands to instlal and configure the s3 compute canada storage 
# sudo pip3 install s3cmd
# # Configure s3cmd
# s3cmd --configure



# setup bioconda
# conda config --add channels defaults
# conda config --add channels bioconda
# conda config --add channels conda-forge
# conda config --set channel_priority strict