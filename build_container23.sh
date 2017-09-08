imgname=neuraltalk2
osname=ubuntu
rm -f ${osname}_${imgname}.img
sudo /uufs/chpc.utah.edu/sys/installdir/singularity/2.3.1/bin/singularity create --size 8192 ${osname}_${imgname}.img
sudo /uufs/chpc.utah.edu/sys/installdir/singularity/2.3.1/bin/singularity bootstrap ${osname}_${imgname}.img Singularity
singularity exec --nv ${osname}_${imgname}.img /usr/local/cuda/samples/1_Utilities/deviceQuery/deviceQuery
singularity exec --nv ${osname}_${imgname}.img sh test.sh

