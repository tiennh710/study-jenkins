FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y openjdk-17-jdk openssh-server git && \
    apt-get clean

# Create Jenkins user
RUN useradd -m -s /bin/bash jenkins && \
    echo "jenkins:jenkins" | chpasswd

# Configure SSH
RUN mkdir /var/run/sshd
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
