## Ubuntu Singularity 2.3 container for Neuraltalk2 with Nvidia GPU support

We bootstrap the container with the Nvidia Docker image, a list of available Docker images are at [https://hub.docker.com/r/nvidia/cuda/](https://hub.docker.com/r/nvidia/cuda/).

This necessitates to set environment variables in the `%environment` section to point to the `/usr/local/cuda` directory.

We are using the Singularity 2.3+ `--nv` flag to bring in the Nvidia driver stack from the host. This only works for the execution commands (`exec`, `shell`, etc.), not for bootstrap, but, installations inside bootstrap dont necessarily need the GPU access. `%post` testing is a different story - as the GPU driver stack is not in during the `%post`, instead of running tests in `%post` during bootstrap, we do it after bootstrap with `singularity exec`. See the `build_container23.sh` script for details.

The Neuraltalk2 dependencies were installed similarly to the Dockerfile from [https://github.com/beeva-enriqueotero/docker-neuraltalk2](https://github.com/beeva-enriqueotero/docker-neuraltalk2), except for the Python packages (numpy, scipy, hdf5), which threw error with pip so I installed them from the Ubuntu repo.

Thanks to the `--nv` command this container should be independent from the host GPU driver version.

To build the container, do the following:
```
ml singularity
./build_container23.sh
```
(note that you will need sudo access to singularity, which all hpcapps users should have, or build on your own machine with root).

To shell into the container, do:
```
ml singularity
singularity shell --nv -B /scratch -s /bin/bash ubuntu_neuraltalk2.img 
```

To run the Neuraltalk2 programs, one needs to specify explicitly the paths to the Lua programs (and also add the Neuraltalk2 directory to LUA_PATH - which is done in the %environment section of the container.

I have not tried any training, but, using the trained model provided at the Neuraltalk2 page, to run the evaluation, we can do:
```
ml singularity
singularity exec --nv /uufs/chpc.utah.edu/sys/installdir/neuraltalk2/master/ubuntu_neuraltalk2.img th /opt/neuraltalk2/eval.lua -model /uufs/chpc.utah.edu/sys/installdir/neuraltalk2/master/checkpoint/model_id1-501-1448236541.t7_cpu.t7 -image_folder /uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/chpc/Singularity-ubuntu-neuraltalk/test -num_images 1
```

where `singularity exec --nv` tells to execute the container, `/uufs/chpc.utah.edu/sys/installdir/neuraltalk2/master/ubuntu_neuraltalk2.img` is the actual container location and the rest is the Neuraltalk2 command. Here I am using the pretrained model located in `/uufs/chpc.utah.edu/sys/installdir/neuraltalk2/master/checkpoint/model_id1-501-1448236541.t7_cpu.t7` and have the images to process in `/uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/chpc/Singularity-ubuntu-neuraltalk/test`

To make things a bit easier, I have created an environment module for this, so, the same can be done with:
```
ml use /uufs/chpc.utah.edu/sys/installdir/neuraltalk2/master/module
ml neuraltalk2
evaluate -model /uufs/chpc.utah.edu/sys/installdir/neuraltalk2/master/checkpoint/model_id1-501-1448236541.t7_cpu.t7 -image_folder /uufs/chpc.utah.edu/common/home/u0101881/containers/singularity/containers/chpc/Singularity-ubuntu-neuraltalk/test -num_images 1
```
there is 2 commands available, `evaluate` which equals to `th eval.lua` and `train` which equals to `th train.lua`.


Useful links:
- Nvidia Docker images: https://hub.docker.com/r/nvidia/cuda/
- Our base GPU container which served as a base: https://github.com/CHPC-UofU/Singularity-ubuntu-gpu
- Neuraltalk2 page: https://github.com/karpathy/neuraltalk2
