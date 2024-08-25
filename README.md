#rat-container
These instuctions are based on the ones made by SNO+

# FEATURES
- Full RAT6-compatible environment, GEANT4 and scons
- GUI output support on all operating systems
- TensorFlow and CppFlow (CPU-only for the time being)
- Apptainer and Docker compatibility
- Cluster-compatible

# To download the pre-built container
**If on a shared system/cluster**, you need to load which version of Apptainer you want to use so you
will need to run the command below to choose the default version
```
module load apptainer
```
You will need to not call any other modules as some interfer with Apptainer. This means make sure your 
.bashrc file doesn't call any extra software. Apptainer should be available so use the following command 
to obtain the latest version of the container:
```
apptainer pull --name rat-container.sif docker://djauty/ratcontainer:ubuntu
```
The tag (in the above command, `ubuntu`) can be replaced with the desired tag.


**If on your own local machine**, Docker should be used as it is easier to install (on linux I found apptainer to be easier to install).
The command to obtain the latest version of the container for Docker is:
```
docker pull djauty/ratcontainer:ubuntu
```
The tag (in the above command, `ubuntu`) can be replaced with the desired tag.

Docker doesn't actually create a file in your working directory in the same way that Apptainer does; rather, it
downloads the image layers and adds an entry to your local **Docker registry** which can be viewed by going:
```
docker images
```
This difference doesn't have an effect on how the container is actually used.

# Instructions on how to use the container with RAT

**To build RAT for the first time**:
- Clone RAT from GitHub (**NOTE** - If on Windows, make sure you run `git config --global core.autocrlf input` prior to
  cloning or else Git will automatically change the Unix line-endings to Windows (which **will break the next steps**)
- Enter the following command, filling in the path to RAT with your own.
  This will mount your RAT repo to the directory `/rat` inside the container:

  For *Apptainer*:
  ```
  apptainer shell -B path/to/rat:/rat rat-container.sif
  ```
  For *Docker*:
  ```
  docker run -ti --init --rm -v /absolute/path/to/rat:/rat djauty/ratcontainer:ubuntu
  ```
  *Note* - the `-v` flag operates the same as `-B` in Aptainer BUT you **must** provide it with an absolute path (one starting at /);
  relative paths (the path from where you are now) will **not** work.

- Once in the container you need to run the following:
  ```
  source /home/scripts/setup-env.sh
  ```
  At the moment in **Docker** this is **necessary** as Docker doesn't source it automatically on launch.
  You may see a message about how it could not find `/rat/env.sh`; this is expected as you have not built RAT yet.
  If the build is successful, you shouldn't see this message next time.

  Change the PYTHON_INCs := in makefile.include to 
  ```
  PYTHON_INCS := /usr/include/python3.9
  ```
  and remove **Werror** from the **CXXWFLAGS**

  - Finally, run these commands in the rat folder to build RAT:
 
 ```
 make -f makefile.version
 ./configure
 scons -c
 make -f makefile.rat
 ```
- RAT is now ready to use! Look at the instructions below for how to run it
- After the first build you can just use scons

***
**To exit the container (Apoptainer and Docker)**:
```
exit
```



**To use GUI apps like ROOT's TBrowser**:
(This is based on CERN's documentation for [running ROOT with graphics](https://hub.docker.com/r/rootproject/root-ubuntu16/))

 For **Linux**:
  ```
  docker run -ti --init --rm --user $(id -u) -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /absolute/path/to/rat:/rat djauty/ratcontainer:ubuntu
  ```
  As you can see, the difference is a few extra options. As the command has gotten so large, you can [set an alias in your .bashrc](https://askubuntu.com/a/17538) to something much shorter and more convenient.


 For **macOS**:

  1. Install [XQuartz](https://www.xquartz.org/)
  2. Open XQuartz, and then go XQuartz -> Preferences -> Security, and tick the box "Allow connections from network clients"
  3. Run `xhost + 127.0.0.1` which will whitelist your local IP
  4. Finally, you can run the container with the following:
  ```
  docker run --rm --init -ti -v /tmp/.X11-unix:/tmp/.X11-unix -v /absolute/path/to/rat:/rat -e DISPLAY=host.docker.internal:0 djauty/ratcontainer:ubuntu
  ```
  
  For **Windows**
  To enable graphics, you must have Xming⁠ installed. Make sure Xming is whitelisted in the Windows firewall when prompted. After installing Xming, white-list the IP-address of the Docker containers in Xming by running the following command in PowerShell as administrator: Add-Content 'C:\Program Files (x86)\Xming\X0.hosts' "`r`n10.0.75.2" Restart Xming and start the container with the following command:
```
  docker run --rm -it -e DISPLAY=10.0.75.1:0 rootproject/root
```
