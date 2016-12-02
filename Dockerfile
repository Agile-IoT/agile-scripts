FROM resin/raspberrypi2-debian

# Let's start with some basic stuff.
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables \
    wget \
    git \
    dbus

# Install Docker from hypriot repos
# Install Docker-compose from hypriot repos
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 37BBEE3F7AD95B3F && \
    echo "deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy main" > /etc/apt/sources.list.d/hypriot.list && \
    apt-get update && \
    apt-get install -y \
       docker-hypriot \
       docker-compose

COPY ./wrapdocker /usr/local/bin/wrapdocker

COPY ./dbus /dbus
COPY ./compose /compose
COPY agile /agile

WORKDIR /

# Define additional metadata for our image.
VOLUME /var/lib/docker
COPY start /start

ENV DBUS_SESSION_SOCKET	/agile_bus_socket
ENV DBUS_SYSTEM_SOCKET /host_run/dbus/system_bus_socket
ENV AGILE_GRAPH_PORT 3000
ENV AGILE_CLIENT_PORT 1337

CMD /start
