FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    openssh-server \
    python3 \
    python3-pip \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ansible \
    && echo "ansible:ansible" | chpasswd \
    && usermod -aG sudo ansible \
    && echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir /var/run/sshd
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
