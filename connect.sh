#!/bin/bash

set -e

BASE_DIR=$(readlink -f $(dirname ${0}))
CLIENT_DIR="${BASE_DIR}/client"
SERVER_IP="$(terraform -chdir=${BASE_DIR}/terraform output -raw vm_public_ip)"
GATEWAY=$(ip route get 8.8.8.8 | grep -oP 'via \K\S+')

# Safety checks
if ! command -v openvpn &> /dev/null; then
    echo "openvpn command not found. Please install openvpn and try again."
    exit 1
fi
if ! command -v docker compose &> /dev/null && ! docker compose --help &> /dev/null; then
    echo "docker compose command not found. Please install docker compose and try again."
    exit 1
fi

sudo ip route add $SERVER_IP/32 via $GATEWAY

cleanup() {
    echo "Cleaning up..."
    docker compose -f ${CLIENT_DIR}/docker-compose.yaml down
    sudo ip route del $SERVER_IP/32 via $GATEWAY
}

# Trap SIGINT (Ctrl+C) and EXIT to call the cleanup function
trap cleanup SIGINT EXIT

sed -i "s/^connect = .*/connect = ${SERVER_IP}:443/" ${CLIENT_DIR}/stunnel.conf
docker compose -f ${CLIENT_DIR}/docker-compose.yaml up --build -d
sudo openvpn --config ${CLIENT_DIR}/client.ovpn
