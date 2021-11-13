#!/bin/bash -l

module load PrgEnv-gnu
module load cpe-cuda
module load cuda/11.3.0
module load python

# https://docs.python.org/3/using/cmdline.html#envvar-PYTHONNOUSERSITE
# equivalent to `python -s` instead of `python`
export PYTHONNOUSERSITE=1

# https://matplotlib.org/stable/faq/environment_variables_faq.html#environment-variables
export MPLCONFIGDIR=$SCRATCH

# https://docs.astropy.org/en/stable/config/index.html?highlight=xdg_cache_home#getting-started
mkdir -p $SCRATCH/astropy
export XDG_CACHE_HOME=$SCRATCH
export XDG_CONFIG_HOME=$SCRATCH

# https://developer.nvidia.com/blog/cuda-pro-tip-understand-fat-binaries-jit-caching/
# https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#env-vars
export CUDA_CACHE_PATH=$SCRATCH

# https://docs.cupy.dev/en/stable/reference/environment.html#envvar-CUPY_CACHE_DIR
export CUPY_CACHE_DIR=/tmp/cupy/kernel_cache

# undocumented, see https://github.com/cupy/cupy/issues/3887
export CUPY_CUDA_LIB_PATH=/tmp/cupy/cuda_lib

# the python module at NERSC adds a path on $HOME to $PATH, undo
# split path on : into lines | use grep to filter out the path we do not want | reassemble path
export PATH=$(tr ":" "\n" <<<"$PATH" | grep -Fxv "$PYTHONUSERBASE/bin" | paste -sd:)

# and finally...
# $HOME/.nv/nvidia-application-profiles-rc
# https://download.nvidia.com/XFree86/Linux-x86_64/450.119.03/README/profiles.html
export HOME=$SCRATCH

PREFIX=$1

shift

source activate $PREFIX

exec "$@"
