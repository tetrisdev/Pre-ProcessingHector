# Base image
FROM ubuntu:20.04

# Disable interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO noetic
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TZ=Etc/UTC
ENV ROS_HOSTNAME=localhost
# Install general tools
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    wget \
    curl \
    nano \
    lsb-release \
    gnupg2 \
    software-properties-common \
    python3-pip \               
    libpcl-dev \                
    pcl-tools \
    x11-apps \                  
    locales \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install ROS Noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -
RUN apt-get update && apt-get install -y \
    ros-noetic-desktop-full \
    ros-noetic-pcl-conversions \
    ros-noetic-pcl-ros \
    ros-noetic-laser-filters \
    ros-noetic-hector-slam \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init \
    && rosdep update

# Source ROS setup for future use
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
ARG WORKSPACE=/workspaces/Bachelor/RosWorkspace

# Set the working directory
WORKDIR /workspaces/Bachelor/RosWorkspace
