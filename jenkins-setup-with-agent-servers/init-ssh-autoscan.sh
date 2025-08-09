#!/bin/bash
set -e

NETWORK_NAME=${DOCKER_NETWORK:-jenkins_net}
KNOWN_HOSTS_PATH=/var/jenkins_home/.ssh/known_hosts

mkdir -p /var/jenkins_home/.ssh
chmod 700 /var/jenkins_home/.ssh

rm -f "$KNOWN_HOSTS_PATH"

echo "[INFO] Detecting agents in Docker network: $NETWORK_NAME"

AGENT_LIST=$(docker ps --format '{{.Names}}'     --filter "network=$NETWORK_NAME"     | grep -v "$(hostname)")

if [ -z "$AGENT_LIST" ]; then
    echo "[WARN] No agents found in network $NETWORK_NAME"
else
    echo "[INFO] Found agents: $AGENT_LIST"
    for host in $AGENT_LIST; do
        echo "[INFO] Scanning $host..."
        ssh-keyscan -H "$host" >> "$KNOWN_HOSTS_PATH" 2>/dev/null ||         echo "[WARN] Could not scan $host"
    done
fi

chmod 644 "$KNOWN_HOSTS_PATH"
echo "[INFO] Final known_hosts:"
cat "$KNOWN_HOSTS_PATH" || echo "[WARN] known_hosts is empty"

exec /usr/local/bin/jenkins.sh
