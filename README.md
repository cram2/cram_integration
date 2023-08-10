# cram_integration

### Workspace Installation
* cd to_your_cram_workspace/src
* `wstool merge https://raw.githubusercontent.com/cram2/cram_integration/main/cram-20.04.rosinstall`
* `wstool update`
* `cd ~/workspace/`
* `rosdep update`
* `rosdep install --ignore-src --from-paths src/ -r`
* `catkin_make`
