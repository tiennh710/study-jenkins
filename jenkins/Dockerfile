# Dockerfile.jenkins
FROM jenkins/jenkins:lts

USER root
# Cài đặt OpenSSH client để dùng ssh-keyscan
RUN apt-get update && apt-get install -y openssh-client && rm -rf /var/lib/apt/lists/*

USER jenkins
# Script khởi động
COPY init-ssh.sh /usr/local/bin/init-ssh.sh
RUN chmod +x /usr/local/bin/init-ssh.sh
ENTRYPOINT ["/usr/local/bin/init-ssh.sh"]
