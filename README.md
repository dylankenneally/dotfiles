# Development machine setup
*NB: these notes are a work in progress / not complete*

General notes on setting up my development environment's in various operating systems. Typical setups are for a combination of C++, Node / JavaScript & Python.

## Linux setup
This will guide you through setting up a CentOS 7 developer workstation, either via VirtualBox or a physical machine. Once completed, this will provide the following tools:
- GCC 5.x
- git
- python 3
- CMake
- UUID
- OpenGL
- libXt
- Node JS

### Basics for the OS & desktop
Installing CentOS version 7 (with full desktop)
- Working with VirtualBox?
  - Ensure that `Enable 3D Acceleration` is on _before_ installing the OS.
  - **Unless** you're planning in using the Cinnamon desktop - found problems getting this working with 3D Acceleration on 
- Install [CentOS 7](https://www.centos.org/), _full environment_, then open a terminal and:
```bash
# Run the following as root, 'su', or with 'sudo <command>'

# Update the system via yum
yum update -y

# Using VirtualBox? Install the kernel dev tools & reboot - allows the guest additions of VirtualBox to be used
# ref. https://linuxacademy.com/community/posts/show/topic/12002-failed-to-set-up-service-for-vboxadd
yum install -y kernel-devel
yum install -y gcc*
reboot
    # ... install GuestAdditions CD here

# Personal preference - install the Cinnamon desktop
# ref. https://www.rootusers.com/how-to-install-cinnamon-gui-in-centos-7-linux/
yum install epel-release -y
yum install cinnamon -y
    # ... log out, use the settings cog on the log in screen to select the Cinnamon UI
```

### Development tools we want on the system
**TODO: make a script that does this**
```bash
# Run the following as root, 'su', or with 'sudo <command>'

# GCC 5.x (via devtoolset 4), etc.
yum -y groupinstall "development tools"
yum -y install centos-release-scl
yum -y install devtoolset-4-toolchain

# git
yum -y install git

# Python & it's dependencies
yum -y install zlib-devel bzip2-devel openssl-devel sqlite-devel
yum -y install python34

# Install pip for Python 3.4
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python3 get-pip.py
rm get-pip.py

# CMake
yum -y install cmake3
ln -s /usr/bin/cmake3 /usr/bin/cmake

# UUID
yum -y install uuid-devel libuuid-devel

# OpenGL
yum -y install mesa-libGL-devel
yum -y install mesa-libOSMesa-devel

# X11
yum -y install libXt-devel

# Node JS
# ref. https://nodejs.org/en/download/package-manager/#enterprise-linux-and-fedora
curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
yum -y install nodejs

# which (how is that missing from Linux?)
yum -y install which

# Install wget
yum -y install wget

# rpmbuild for creating rpm installers
yum -y install rpm-build
```

### Use gcc 5 by default
Either edit your `.bashrc` file manually to enable the dev tool set, or nuke it with the following _(manual edit recommended)_
```bash
echo "source /opt/rh/devtoolset-4/enable" > ~/.bashrc
```

### IDE setup we want on the system
_todo:_

### bash
_todo:_ colours scheme notes...
https://www.if-not-true-then-false.com/2012/solarized-linux/
in .bashrc, to get colours for the prompt
PS1="\u \w $(git branch 2>/dev/null | sed -n "s/* \(.*\)/\1 /p")$ "

PS1='\[\e[32m\u\] \[\e[36m\w\] \[\e[33m\]\[\e[1m\]$ \[\e[0m\]'

## MacOS setup
*todo:*
- System updates
- Slack
- git https://git-scm.com/download/mac
  - git lfs ??
  - git setup todo
- Visual Studio Code https://code.visualstudio.com/docs/?dv=osx
  - todo: typical extentions used??
- todo: alias to do
- todo: iTerm
- todo: node, python, cmake

Finder preferences
- Show Hard disks & External disks on the desktop (especially if set up with bootcamp)
- Open New Finder windows in the home folder
- Sidebar, removel anything that you don't really use (Recents, AirDrop, Applications, iCloud, Tags) & add what you do use (Movies, Music, Pictures, Home folder)

## Window setup
*todo:*

## Docker containers for automated builds
*todo:*
