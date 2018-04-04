#!/usr/bin/env bash

PURPLE='\033[0;35m'
NC='\033[0m' # No Color


printf "${PURPLE}Building docker...${NC}\n"
docker build -t openlibra_bot .

printf "${PURPLE}Running docker...${NC}\n"
docker run -d openlibra_bot
