#!/bin/bash
set -e

# Đọc danh sách agent từ biến môi trường, mặc định agent1 agent2
AGENT_LIST=${AGENT_HOSTS:-"agent1 agent2"}

mkdir -p /var/jenkins_home/.ssh
chmod 700 /var/jenkins_home/.ssh

# Xóa known_hosts cũ để tránh lỗi host key mismatch
rm -f /var/jenkins_home/.ssh/known_hosts

echo "[INFO] Starting SSH key scan for agents: $AGENT_LIST"
for host in $AGENT_LIST; do
    echo "[INFO] Scanning $host..."
    ssh-keyscan -H "$host" >> /var/jenkins_home/.ssh/known_hosts 2>/dev/null || \
    echo "[WARN] Could not scan $host"
done

chmod 644 /var/jenkins_home/.ssh/known_hosts
echo "[INFO] Final known_hosts:"
cat /var/jenkins_home/.ssh/known_hosts

# Chạy Jenkins gốc
exec /usr/local/bin/jenkins.sh
