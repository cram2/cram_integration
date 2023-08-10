# CRAM Integration Guide

## Setting Up the Workspace
1. Navigate to your CRAM workspace's `src` directory:
   ```
   cd to_your_cram_workspace/src
   ```
2. Merge the necessary tools:
   ```
   wstool merge https://raw.githubusercontent.com/cram2/cram_integration/main/cram-20.04.rosinstall
   ```
3. Update the workspace:
   ```
   wstool update
   ```
4. Go back to the workspace root:
   ```
   cd ~/workspace/
   ```
5. Update ROS dependencies:
   ```
   rosdep update
   ```
6. Install the required dependencies:
   ```
   rosdep install --ignore-src --from-paths src/ -r
   ```
7. Build the workspace:
   ```
   catkin_make
   ```

## Prerequisites
- Ensure you have the [CRAM](https://github.com/cram2/cram/tree/devel) repository installed. This integration will not function without it.

## About `cram_integration`
This repository provides interfaces to external frameworks. If you aim to operate CRAM using either the Unreal Engine Robot or a real robot, this package is essential.
