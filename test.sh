#!/bin/sh

  #cd /usr/local/cuda/samples/1_Utilities/deviceQuery
  #make; make run

  #th /opt/neuraltalk2/eval.lua -model checkpoint/model_id1-501-1448236541.t7_cpu.t7 -image_folder test -num_images 1
  #need to be in /opt/neuraltalk2 in order to run
  mkdir -p vis/imgs/
  th /opt/neuraltalk2/eval.lua -model /uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/chpc/Singularity-ubuntu-neuraltalk/checkpoint/model_id1-501-1448236541.t7_cpu.t7 -image_folder /uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/chpc/Singularity-ubuntu-neuraltalk/test -num_images 1
