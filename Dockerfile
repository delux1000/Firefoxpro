FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    firefox \
    tigervnc-standalone-server \
    novnc \
    websockify \
    dbus-x11 \
    && rm -rf /var/lib/apt/lists/*

# Create a non‑root user and set up VNC without password
RUN useradd -m browser && \
    mkdir -p /home/browser/.vnc && \
    echo "browser" | vncpasswd -f > /home/browser/.vnc/passwd && \
    chmod 600 /home/browser/.vnc/passwd && \
    chown -R browser:browser /home/browser/.vnc

USER browser
ENV DISPLAY=:1
ENV HOME=/home/browser

CMD vncserver :1 -geometry 1280x720 -depth 24 -localhost no -SecurityTypes None && \
    websockify --web=/usr/share/novnc 8080 localhost:5901
