CoppeliaSim Docker image for MacOS
=======================================

## Summary:

This repository contains instructions to execute CoppeliaSim inside a Docker container and use the GUI (Graphical User Interface) through XQuartz in a MacOS host. 

Why should I run CoppeliaSim in a docker container?
- Running in a virtual machine is extremely slow.
- You don't want or can't install it in your MacOS.

## Credits:
Most of the code was taken from:

https://github.com/CoppeliaRobotics/docker-image-coppeliasim

Other useful links for using CoppeliaSim in MacOS:
- https://sourabhbajaj.com/blog/2017/02/07/gui-applications-docker-mac/
- https://techsparx.com/software-development/docker/display-x11-apps.html
- https://github.com/XQuartz/XQuartz/issues/54

## Softwares used:

- MacOS: Big Sur 11.6
- CoppeliaSim: CoppeliaSim_Edu_V4_2_0_Ubuntu20_04.tar.xz
- XQuartz: XQuartz 2.8.1 (xorg-server 1.20.11)

## Setup:

### XQuartz setup:
```bash
brew install xquartz
```
Restart the computer (might not be necessary)

```bash
open -a XQuartz
```
In the XQuartz preferences, go to the “Security” tab and make sure you’ve got “Allow connections from network clients” ticked.

Test the installation:
```bash
docker run -d --name firefox -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix jess/firefox
```

Close xQuartz.

In the Mac terminal (not in the XQuartz terminal):
```bash
defaults write org.xquartz.X11 enable_iglx -bool true
open -a XQuartz
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $IP
```

### Build the Docker image:

```bash
sh build.sh
```

## Running:

Open XQuartz and set the authorization:
```bash
open -a XQuartz
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $IP
```

Run the container:

```bash
docker run -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix -v $PWD/shared:/shared -p 19996-19999:19996-19999 -it coppeliasim-ubuntu20
```

Inside the container:

```bash
./run_cop
```

You can adjust the window size in the lower right corner of the window.

## Observations:

- It is necessary to restart the XQuartz when CoppeliaSim is closed.
- The Dockerfile only exposes and publishes the ports 19996 to 19999, feel free to change it. Note that CoppeliaSim uses port 19997, so it should be published.
- Some plugins are not loaded. For example, B0 and ROS.


## Using the remote API
- CoppeliaSim server (Inside the container):
```lua
simRemoteApi.start(19999)
```

- Client python (In the MacOS host): 
```python
clientID=sim.simxStart('127.0.0.1',19999,True,True,5000,5)
```