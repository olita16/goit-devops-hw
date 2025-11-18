#!/bin/bash

# Colors
GREEN="\033[0;32m"
NC="\033[0m"

echo -e "${GREEN}=== Starting installation of DevOps tools ===${NC}"

# 1. Install Docker
if ! command -v docker &> /dev/null
then
    echo -e "${GREEN}Installing Docker...${NC}"
    sudo apt update
    sudo apt install -y ca-certificates curl gnupg

    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" |
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    echo -e "${GREEN}Docker already installed.${NC}"
fi

# 2. Install Docker Compose (standalone binary)
if ! command -v docker-compose &> /dev/null
then
    echo -e "${GREEN}Installing Docker Compose...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/download/2.24.5/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo -e "${GREEN}Docker Compose already installed.${NC}"
fi

# 3. Install Python 3.9+
if ! command -v python3 &> /dev/null
then
    echo -e "${GREEN}Installing Python...${NC}"
    sudo apt update
    sudo apt install -y python3 python3-pip python3-venv
else
    echo -e "${GREEN}Python already installed.${NC}"
fi

# 4. Install Django
if ! python3 -m django --version &> /dev/null
then
    echo -e "${GREEN}Installing Django...${NC}"
    pip3 install django
else
    echo -e "${GREEN}Django already installed.${NC}"
fi

echo -e "${GREEN}=== Installation complete! ===${NC}"