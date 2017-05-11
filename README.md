# AGILE scripts

This repository contains start and stop scripts for various [AGILE](http://agile-iot.eu/) components.
It is only a wrapper for two other repositoriesL
- agile-stack: the docker-compose based definition of AGILE components
- agile-cli: a simple command line interface to manage the AGILE stack

Currently, AGILE is tested on Raspberry PI 2/3 Model B running Raspbian, and on x86_64 running Ubuntu 16.04.
Since we use docker containers, it should also run in many other environment.

## Requirements

### On Raspberry PI 2/3 Model B running Raspbian

- Install recent version of Raspbian

Download image from [Raspbian](https://downloads.raspberrypi.org/raspbian/images/raspbian-2016-05-31/2016-05-27-raspbian-jessie.zip)

Write it to SD, using
```
sudo dd bs=1m if=2016-05-27-raspbian-jessie.img of=/dev/<YOUR_uSD_DISK>
```

- Start the Pi and log in
```
ssh pi@raspberrypi.local
```

Default password is "raspberry"

- Install recent versions of `docker` and `docker-compose`

Install docker from [Hypriot](http://blog.hypriot.com/post/your-number-one-source-for-docker-on-arm/)

```
curl -s https://packagecloud.io/install/repositories/Hypriot/Schatzkiste/script.deb.sh | sudo bash
sudo apt-get install -y docker-hypriot docker-compose
sudo usermod -a -G docker pi
# you can make the group change effective without logout/login (http://superuser.com/questions/272061/reload-a-linux-users-group-assignments-without-logging-out)
sudo su - $USER
```

- Disable and stop Bluez in the host

Unfortunately Bluez on the Raspbian is too old. Our BLE driver needs version 5.39 with experimental features enabled. Bluez is part of the agile-core container, thus it should be disabled in the host OS.

```
sudo systemctl disable bluetooth
sudo systemctl stop bluetooth
```

### On Ubuntu 16.04 (x86_64)

- Install recent versions of `docker` and `docker-compose`

Based on the [offical instructions](https://docs.docker.com/engine/installation/linux/ubuntulinux/), these are the commands for docker

```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install docker-engine
sudo usermod -aG docker $USER
```

Install docker-compose using the [official method](https://docs.docker.com/compose/install/)

```
curl -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

- Install ARM binformat support for docker

Since our main platform is the Raspberry Pi, some of our containers might contain ARM binaries. Insall support for these as follows

```
apt-get install qemu binfmt-support qemu-user-static
```

- Disable and stop Bluez in the host

```
sudo systemctl disable bluetooth
sudo systemctl stop bluetooth
```


### On other machines (x86_64)

- Install recent versions of `docker` and `docker-compose`

On other machines, install docker (at least version 1.11) and docker-compose (at least version 1.8). Check it with `docker -v` and `docker-compose -v`.
Read more on how to [install or upgrade](https://docs.docker.com/compose/install/)

- Install ARM binformat support for docker

```
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

- Disable and stop Bluez in the host

```
sudo systemctl disable bluetooth
sudo systemctl stop bluetooth
```

## Getting AGILE

- Pull our library to have AGILE startup scripts, if not yet done.
```
git clone https://github.com/Agile-IoT/agile-scripts.git
cd agile-scripts
git submodule update --init
```

## Configuration

Select one of the configuration files in `agile-cli/agile.config.examples` and copy it to `agile-cli`. E.g. use the following command
```
cp agile-cli/agile.config.examples/agile.config.local agile-cli/agile.config
```
Customize the config if needed. 

## Usage

Use `agile-cli/agile start` to start the main components, and `agile-cli/agile stop` to stop them.

Once component started you can visit http://127.0.0.1:8000 to access the AGILE user interface and start building your IoT solution.

For more details, please see the README inside agile-cli and agile-stack.
