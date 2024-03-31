#!/bin/bash

# Update package list
sudo apt update

# Install necessary packages to use HTTPS repositories
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository to sources list
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list for the addition to be recognized
sudo apt update

# Install Docker CE
sudo apt install docker-ce -y

# Add current user to the docker group to run Docker commands without sudo
sudo usermod -aG docker ubuntu

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Run the container on port 80
docker run -p 80:3000 ghcr.io/benc-uk/nodejs-demoapp:latest