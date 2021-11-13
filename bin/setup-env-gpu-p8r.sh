#!/bin/bash -l

set -euo pipefail

module load PrgEnv-gnu
module load cpe-cuda
module load cuda/11.3.0
module load python

PREFIX=$1

conda env create -f env/env-conda.yml --prefix $PREFIX
source activate $PREFIX

pip install cupy-cuda113 -f https://github.com/cupy/cupy/releases/v9.6.0

# pip install packages from github one at a time
cat env/env-pip-extra-wip.txt | xargs -l pip install --no-cache-dir

# build mpi4py with compiler wrappers
MPICC="cc -shared" pip install --force --no-cache-dir --no-binary=mpi4py mpi4py 

printf "#\n# Ignore what conda tells you! To activate, use\n#\n"
printf "#     \$ source activate $PREFIX\n#\n"
printf "# To deactivate, use\n#\n"
printf "#     \$ conda deactivate\n#\n"
