FROM ros:galactic-ros-core-focal

# Change the default shell to Bash
SHELL [ "/bin/bash" , "-c" ]

# Install Git
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git ros-galactic-joint-state-publisher ros-galactic-robot-state-publisher ros-galactic-cartographer ros-galactic-cartographer-ros ros-galactic-gazebo-plugins ros-galactic-teleop-twist-keyboard  ros-galactic-teleop-twist-joy ros-galactic-rviz2 ros-galactic-xacro ros-galactic-nav2* ros-galactic-urdf python3-colcon-common-extensions cmake pkg-config && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential

# Create a Catkin workspace and clone Tortoisebot repos
RUN source /opt/ros/galactic/setup.bash 
RUN mkdir -p /ros2_ws/src 


RUN cd /ros2_ws/src && git clone -b ros2-galactic https://github.com/rigbetellabs/tortoisebot.git
RUN cd /ros2_ws/ && git clone https://github.com/YDLIDAR/YDLidar-SDK.git
RUN cd /ros2_ws/YDLidar-SDK/ &&  mkdir build && cd build/ && cmake .. && make && make install
# RUN cd /ros2_ws/src/tortoisebot && rm -rf ydlidar-ros2 && git clone https://github.com/YDLIDAR/ydlidar_ros2_driver.git 
RUN sed -i 's/rviz_launch_cmd,/\# rviz_launch_cmd,/' /ros2_ws/src/tortoisebot/tortoisebot_bringup/launch/bringup.launch.py
RUN sed -i 's/state_publisher_launch_cmd,/# state_publisher_launch_cmd,/'    /ros2_ws/src/tortoisebot/tortoisebot_bringup/launch/autobringup.launch.py
RUN sed -i 's/robot_state_publisher_node,/# robot_state_publisher_node,/'   /ros2_ws/src/tortoisebot/tortoisebot_bringup/launch/autobringup.launch.py
RUN sed -i 's/joint_state_publisher_node,/# joint_state_publisher_node,/'   /ros2_ws/src/tortoisebot/tortoisebot_bringup/launch/autobringup.launch.py
RUN sed -i 's/ydlidar_launch_cmd,/# ydlidar_launch_cmd,/'        /ros2_ws/src/tortoisebot/tortoisebot_bringup/launch/autobringup.launch.py
RUN sed -i 's/differential_drive_node,/# differential_drive_node,/'   /ros2_ws/src/tortoisebot/tortoisebot_bringup/launch/autobringup.launch.py
RUN sed -i 's/gazebo_launch_cmd,/# gazebo_launch_cmd,/'   /ros2_ws/src/tortoisebot/tortoisebot_bringup/launch/autobringup.launch.py
RUN sed -i 's/camera_node$/# camera_node\n/'  /ros2_ws/src/tortoisebot/tortoisebot_bringup/launch/autobringup.launch.py
RUN cd /ros2_ws/src && git clone https://github.com/peerajak/Checkpoint23_2o2_CppROS2.git
RUN source /opt/ros/galactic/setup.bash && cd /ros2_ws/ && colcon build #--symlink-install
RUN source /opt/ros/galactic/setup.bash
RUN source /ros2_ws/install/setup.bash
RUN echo "source /opt/ros/galactic/setup.bash" >> /root/.bashrc
RUN echo "source /ros2_ws/install/setup.bash" >> /root/.bashrc

# Set the working folder at startup
WORKDIR /ros2_ws



RUN apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get install -y vim


# Copy entrypoint
COPY ./entrypoint_waypoint_test.sh /ros2_ws/entrypoint.sh


CMD ["/bin/bash", "-c", "/ros2_ws/entrypoint.sh"]
