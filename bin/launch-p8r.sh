#!/bin/bash -l

set -e

module load PrgEnv-gnu
module load cpe-cuda
module load cuda/11.3.0
module load python

PREFIX=$1

shift

source activate $PREFIX

exec "$@"
