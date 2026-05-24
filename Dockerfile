FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg lsb-release software-properties-common sudo \
    build-essential git \
    python3-pip \
    libceres-dev libeigen3-dev \
    libpcl-dev \
    nlohmann-json3-dev \
    libusb-1.0-0-dev \
    tmux \
    libgoogle-glog-dev \
    libgflags-dev \
    libatlas-base-dev \
    libsuitesparse-dev \
    wget \
    cmake \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
    | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] \
    http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/ros2.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-desktop \
    python3-rosdep \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    python3-colcon-common-extensions 

RUN python3 -m pip install --break-system-packages "rosbags==0.10.5"


# RUN git clone https://github.com/ceres-solver/ceres-solver.git && \
#     cd ceres-solver && \
#     git checkout 2.2.0 && \
#     mkdir build && cd build && \
#     cmake .. && \
#     make -j$(nproc) && \
#     make install

WORKDIR /ros2_ws
COPY ./src ./src

RUN source /opt/ros/jazzy/setup.bash && \
    colcon build --cmake-args -DCMAKE_POLICY_VERSION_MINIMUM=3.5

    
WORKDIR /ros2_ws

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc && \
    echo "source /ros2_ws/install/setup.bash" >> ~/.bashrc

CMD ["bash"]
