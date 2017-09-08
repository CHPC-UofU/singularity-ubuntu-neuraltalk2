-- -*- lua -*-
-- Written by MC on 9/8/2017
help(
[[
This module sets up Neuraltalk2 from GIT master repository

]])

load("singularity")
local PVPATH="/uufs/chpc.utah.edu/sys/installdir/neuraltalk2/master"

--set_alias("startparaview","singularity shell -s /bin/bash -B /scratch,/uufs/chpc.utah.edu " .. PVPATH .. "/ubuntu_paraview.img")
--set_alias("paraview","singularity exec -B /scratch,/uufs/chpc.utah.edu " .. PVPATH .. "/ubuntu_biobakery.img paraview")

-- singularity environment variables to bind the paths and set shell
setenv("SINGULARITY_BINDPATH","/scratch,/uufs/chpc.utah.edu")
setenv("SINGULARITY_SHELL","/bin/bash")
-- shell function to provide "alias" to the neuraltalk2 commands, as plain aliases don't get exported to bash non-interactive shells by default
set_shell_function("eval",'singularity exec' .. PVPATH .. '/ubuntu_neuraltalk2.img th /opt/neuraltalk2/eval.lua "$@"',"singularity exec " .. PVPATH .. "/ubuntu_neuraltalk2.img th /opt/neuraltalk2/eval.lua $*")
-- to export the shell function to a subshell
if (myShellName() == "bash") then
 execute{cmd="export -f eval",modeA={"load"}}
end
set_shell_function("train",'singularity exec' .. PVPATH .. '/ubuntu_neuraltalk2.img th /opt/neuraltalk2/train.lua "$@"',"singularity exec " .. PVPATH .. "/ubuntu_neuraltalk2.img th /opt/neuraltalk2/train.lua $*")
-- to export the shell function to a subshell
if (myShellName() == "bash") then
 execute{cmd="export -f train",modeA={"load"}}
end

whatis("Name        : neuraltalk")
whatis("Version     : master")
whatis("Category    : Image captioning model based on CNN and RNN")
whatis("URL         : https://github.com/karpathy/neuraltalk2")
