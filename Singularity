Bootstrap: docker
From: nvidia/cuda:8.0-cudnn5-devel-ubuntu14.04
# for list of available Docker images see https://hub.docker.com/r/nvidia/cuda/
# use cudnn5 as with cudnn7 neuraltalk2 complained it can't find libcudnn

%runscript
  th /opt/neuraltalk2/eval.lua "$@"

%environment

  #Use bash as default shell
  SHELL=/bin/bash
  
  #Add nvidia driver paths
  
  PATH="/nvbin:$PATH"
  LD_LIBRARY_PATH="/nvlib:$LD_LIBRARY_PATH"
  
  #Add CUDA paths
  
  CPATH="/usr/local/cuda/include:$CPATH"
  PATH="/usr/local/cuda/bin:$PATH"
  LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
  CUDA_HOME="/usr/local/cuda"
  
  export PATH LD_LIBRARY_PATH CPATH CUDA_HOME

  export LUA_PATH='/opt/torch/install/share/lua/5.1/?.lua;/opt/torch/install/share/lua/5.1/?/init.lua;./?.lua;/opt/torch/install/share/luajit-2.1.0-beta1/?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua'
  export LUA_PATH='/opt/neuraltalk2/?.lua;'$LUA_PATH
  export LUA_CPATH='/opt/torch/install/lib/lua/5.1/?.so;./?.so;/usr/local/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so'
  export PATH=/opt/torch/install/bin:$PATH
  export LD_LIBRARY_PATH=/opt/torch/install/lib:$LD_LIBRARY_PATH
  export LUA_CPATH='/opt/torch/install/lib/?.so;'$LUA_CPATH
  export LUA_CPATH='/opt/neuraltalk2/misc/?.so;'$LUA_CPATH

%setup
  #Runs on host
  #The path to the image is $SINGULARITY_ROOTFS

%post
  #Post setup script
  
  #Default mount paths
  mkdir /scratch /uufs
  
  #Nvidia Library mount paths
  mkdir /nvlib /nvbin

  #fix locale so apt-get does not complain
  locale-gen "en_US.UTF-8"
  dpkg-reconfigure locales
  export LANGUAGE="en_US.UTF-8"
  echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
  echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale

  #Updating and getting required packages
  apt-get update
  apt-get install -y wget git vim build-essential cmake curl libatlas-base-dev gfortran software-properties-common python-software-properties

  # CUDA samples for testing
  #echo CUDA_PKG_VERSION $CUDA_PKG_VERSION
  #apt-get install -y cuda-samples-$CUDA_PKG_VERSION

  # neuraltalk2 packages, as in 
  # https://github.com/beeva-enriqueotero/docker-neuraltalk2/blob/master/Dockerfile
  curl -sk https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash

  cd /opt
  git clone https://github.com/torch/distro.git /opt/torch --recursive
  cd torch; ./install.sh
 
  #luarocks is installed with torch
  export PATH="/opt/torch/install/bin:$PATH"
 
  luarocks install nn
  luarocks install nngraph
  luarocks install image
  luarocks install lua-cjson

  #GPU stuff
  luarocks install cutorch
  luarocks install cunn

  # Only for training
  apt-get -y install libprotobuf-dev protobuf-compiler
  luarocks install loadcaffe

  apt-get -y install libhdf5-dev hdf5-tools python-dev python-pip cython python-numpy python-scipy python-h5py
  #numpy throws an error when installed with pip 
  #pip install cython numpy h5py scipy
  luarocks install hdf5

  #neuraltalk
  cd /opt
  git clone https://github.com/karpathy/neuraltalk2

%test
  # build the deviceQuery sample and run it - it should show available GPU(s)
  #cd /usr/local/cuda/samples/1_Utilities/deviceQuery
  #make; make run
  #th /opt/neuraltalk2/eval.lua -model checkpoint/model_id1-501-1448236541.t7_cpu.t7 -image_folder test -num_images 1
  #need to be in /opt/neuraltalk2 in order to run
  #mkdir -p vis/imgs/
  #th /opt/neuraltalk2/eval.lua -model /uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/tests/Singularity-ubuntu-neuraltalk/checkpoint/model_id1-501-1448236541.t7_cpu.t7 -image_folder /uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/tests/Singularity-ubuntu-neuraltalk/test -num_images 1
  #

# NOTE: also need to download the trained set, whcih is expected to sit in directory checkpoint:
# mkdir checkpoint
# cd checkpoint
# wget http://cs.stanford.edu/people/karpathy/neuraltalk2/checkpoint_v1_cpu.zip
# unzip checkpoint_v1_cpu.zip
