FROM ubuntu:focal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install python3 xvfb x11vnc xdotool wget tar supervisor net-tools fluxbox gnupg2 && \
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add -  && \
    echo 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' |tee /etc/apt/sources.list.d/winehq.list && \
    apt-get update && apt-get -y install winehq-devel  && \
    mkdir /opt/wine-stable/share/wine/mono && wget -O - https://dl.winehq.org/wine/wine-mono/7.4.0/wine-mono-7.4.0-x86.tar.xz | tar -xJv -C /opt/wine-stable/share/wine/mono && \
    mkdir /opt/wine-stable/share/wine/gecko && wget -O /opt/wine-stable/share/wine/gecko/wine-gecko-2.47.3-x86.msi https://dl.winehq.org/wine/wine-gecko/2.47.3/wine-gecko-2.47.3-x86.msi && wget -O /opt/wine-stable/share/wine/gecko/wine-gecko-2.47.3-x86_64.msi https://dl.winehq.org/wine/wine-gecko/2.47.3/wine-gecko-2.47.3-x86_64.msi && \
    apt-get -y full-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/*
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV WINEPREFIX /root/prefix32
ENV WINEARCH win32
ENV DISPLAY :0

WORKDIR /root/
RUN wget -O - https://github.com/novnc/noVNC/archive/v1.3.0.tar.gz | tar -xzv -C /root/ && mv /root/noVNC-1.3.0 /root/novnc && ln -s /root/novnc/vnc_lite.html /root/novnc/index.html && \
    wget -O - https://github.com/novnc/websockify/archive/v0.10.0.tar.gz | tar -xzv -C /root/ && mv /root/websockify-0.10.0 /root/novnc/utils/websockify

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
