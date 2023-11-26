#!/usr/bin/env python3

import rospy
from nav_msgs.msg import Odometry
from geometry_msgs.msg import PoseWithCovarianceStamped
import os

class PoseSaver:
    def __init__(self, output_file):
        # Ensure the directory exists
        directory = os.path.dirname(output_file)
        if directory and not os.path.exists(directory):
            os.makedirs(directory)

        self.pose_file = open(output_file, 'w')
        file_string = output_file.split('.')
        self.covariance_file = open(file_string[0]+"_covariance.txt" ,'w')
        # Subscribe to the appropriate topic (adjust the topic name as needed)
        # Decide whether it's Odometry or PoseStamped based on your setup
        rospy.Subscriber("/poseupdate", PoseWithCovarianceStamped, self.callback)

    def callback(self, msg):
        # Save in the TUM format: timestamp x y z qx qy qz qw
        pose_data = f"{msg.header.stamp.to_sec()} {msg.pose.pose.position.x} {msg.pose.pose.position.y} {msg.pose.pose.position.z} {msg.pose.pose.orientation.x} {msg.pose.pose.orientation.y} {msg.pose.pose.orientation.z} {msg.pose.pose.orientation.w}\n"
        covariance_data = f"{msg.header.stamp.to_sec()} " + ' '.join(map(str, msg.pose.covariance)) + "\n"
        self.pose_file.write(pose_data)
        self.covariance_file.write(covariance_data)

    def shutdown(self):
        self.pose_file.close()
        self.covariance_file.close()

if __name__ == "__main__":
    rospy.init_node('pose_saver_node')
    output_path = rospy.get_param('~output_path', 'output.txt')  # You can set this parameter or use the default 'output.txt'
    ps = PoseSaver(output_path)

    rospy.on_shutdown(ps.shutdown)  # Ensure the file is closed upon node shutdown

    rospy.spin()
