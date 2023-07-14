FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# install wine
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install python3 xvfb x11vnc xdotool wget tar supervisor net-tools fluxbox gnupg2 xz-utils cabextract

RUN mkdir -pm755 /etc/apt/keyrings \
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && apt update \
    && apt install --install-recommends -y winehq-stable
# && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN \
    wget -O /usr/local/bin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
    && chmod +x /usr/local/bin/winetricks

RUN useradd -lmU -s /bin/bash hphater
USER hphater

ENV WINEPREFIX=/home/hphater/prefix32 \
    WINEARCH=win32 \
    DISPLAY=:0 \
    GNUTLS_SYSTEM_PRIORITY_FILE=/home/hphater/gnutls_config

COPY ./gnutls_config /home/hphater/gnutls_config

RUN wineboot --init \
    && winetricks -q dotnet462 corefonts

# /root/prefix32/drive_c/Program Files/Hewlett Packard Enterprise/HPE iLO Integrated Remote Console/HPLOCONS.exe

# mkdir -vp /opt/wine-devel/share/wine/mono && wget -O - https://dl.winehq.org/wine/wine-mono/7.4.0/wine-mono-7.4.0-x86.tar.xz | tar -xJv -C /opt/wine-devel/share/wine/mono && \
# mkdir -vp /opt/wine-devel/share/wine/gecko && wget -O /opt/wine-devel/share/wine/gecko/wine-gecko-2.47.3-x86.msi https://dl.winehq.org/wine/wine-gecko/2.47.3/wine-gecko-2.47.3-x86.msi && wget -O /opt/wine-devel/share/wine/gecko/wine-gecko-2.47.3-x86_64.msi https://dl.winehq.org/wine/wine-gecko/2.47.3/wine-gecko-2.47.3-x86_64.msi

# WORKDIR /root/
# RUN wget -O - https://github.com/novnc/noVNC/archive/v1.3.0.tar.gz | tar -xzv -C /root/ && mv /root/noVNC-1.3.0 /root/novnc && ln -s /root/novnc/vnc_lite.html /root/novnc/index.html && \
#     wget -O - https://github.com/novnc/websockify/archive/v0.10.0.tar.gz | tar -xzv -C /root/ && mv /root/websockify-0.10.0 /root/novnc/utils/websockify

USER root
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 8080 5900
CMD ["/usr/bin/supervisord"]
