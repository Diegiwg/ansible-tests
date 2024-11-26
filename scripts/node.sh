#!/bin/bash

set -e

NODE_NAME="node_a"
IMAGE="ubuntu:22.04"
PORT="2222"
ENGINE="docker"

REPO_PATH="$(dirname "$(dirname "$(realpath "$0")")")"

function checkNodesFile() {
    if [ ! -f "${REPO_PATH}/.tmp/nodes" ]; then
        touch "${REPO_PATH}/.tmp/nodes"
    fi
}

function createNode() {
    local engine=$1
    if [ -z "$engine" ]; then
        echo "Please provide an engine name (docker or podman) as the first argument."
        exit 1
    fi

    local image=$2
    if [ -z "$image" ]; then
        echo "Please provide an image name as the second argument."
        exit 1
    fi

    local port=$3
    if [ -z "$port" ]; then
        echo "Please provide a port number as the third argument."
        exit 1
    fi

    local script=$4
    if [ -z "$script" ]; then
        echo "Please provide a script as the fourth argument."
        exit 1
    fi

    local nodeName=$5
    if [ -z "$nodeName" ]; then
        echo "Please provide a node name as the fifth argument."
        exit 1
    fi

    if $engine ps -a --format '{{.Names}}' | grep -q "^${nodeName}$"; then
        echo "Node '${nodeName}' already exists."
    else
        $engine run -d \
            --name "${nodeName}" \
            -p "${port}:22" \
            --privileged \
            "${image}" /bin/bash -c "${script}"
    fi

    # Register in .tmp/nodes
    checkNodesFile
    echo "${nodeName}" >> "${REPO_PATH}/.tmp/nodes"
}

function removeNode() {
    local nodeName=$1
    if [ -z "$nodeName" ]; then
        echo "Please provide a node name as the first argument."
        exit 1
    fi

    local engine=$2
    if [ -z "$engine" ]; then
        echo "Please provide an engine name (docker or podman) as the second argument."
        exit 1
    fi

    if $engine ps -a --format '{{.Names}}' | grep -q "^${nodeName}$"; then
        $engine rm -f "${nodeName}"
    else
        echo "Node '${nodeName}' does not exist."
    fi

    # Remove from .tmp/nodes
    checkNodesFile
    sed -i "/^${nodeName}$/d" "${REPO_PATH}/.tmp/nodes"
}

usage() {
    echo "Usage: $0 [--docker|--podman] --image <image> --port <port> --name <name> <command>"
    echo "Commands:"
    echo "  create    Create a new container with the provided configurations."
    echo "  remove    Remove an existing container."
    exit 1
}

if [ ! -f "${REPO_PATH}/ssh/id_rsa.pub" ]; then
    echo "Public SSH key not found at ${REPO_PATH}/ssh/id_rsa.pub"
    exit 1
fi

SSH_KEY_CONTENT="$(cat "${REPO_PATH}/ssh/id_rsa.pub")"

SSH_SETUP_SCRIPT=$(cat <<EOF
    if ! id "ansible" &>/dev/null; then
        useradd -m -s /bin/bash ansible && echo "ansible:ansible" | chpasswd
    fi
    
    mkdir -p /run/sshd
    mkdir -p /home/ansible/.ssh
    echo "${SSH_KEY_CONTENT}" > /home/ansible/.ssh/authorized_keys
    chown -R ansible:ansible /home/ansible/.ssh
    sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
    
    apt update && apt install -y openssh-server
    service ssh restart

    while :; do sleep 1; done
EOF
)

# Argument parsing
while [[ $# -gt 0 ]]; do
    case "$1" in
        --docker)
            ENGINE="docker"
            shift
            ;;

        --podman)
            ENGINE="podman"
            shift
            ;;

        --image)
            IMAGE="$2"
            shift 2
            ;;

        --port)
            PORT="$2"
            shift 2
            ;;

        --name)
            NODE_NAME="$2"
            shift 2
            ;;
    esac
    
    case "$1" in
        create)
            shift
            
            createNode "$ENGINE" "$IMAGE" "$PORT" "$SSH_SETUP_SCRIPT" "$NODE_NAME"

            NODE_IP="$($ENGINE inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "${NODE_NAME}")"

            echo "Node '${NODE_NAME}' created successfully!"
            echo "Access the container via SSH: ssh ansible@localhost -p ${PORT} -i ./ssh/id_rsa"
            echo "Container IP: ${NODE_IP}"

            exit 0
            ;;

        remove)
            shift
            removeNode "$NODE_NAME" "$ENGINE"
            exit 0
            ;;
        *)
            usage
            ;;
    esac
done
