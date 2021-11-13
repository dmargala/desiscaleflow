#!/bin/bash -l
#SBATCH --constraint=gpu
#SBATCH --nodes=1
#SBATCH --gpus-per-node=4
#SBATCH --tasks-per-node=32
#SBATCH --cpus-per-task=2
#SBATCH --time=45
#SBATCH --qos=regular
#SBATCH --job-name=desi_scale_run
#SBATCH --output=slurm-%j.out
#SBATCH --gpu-bind=map_gpu:0,1,2,3
#SBATCH --account=desi_g

set -e

echo "Currently Loaded Modules:"
module -t list 2>&1 | sed 's/^/    /'

NAME=scale-run-$SLURM_JOB_ID

#- Writing to perlmutter scratch
OUTDIR=$SCRATCH/$NAME
#- if out directory exists, remove it and start over
if [ -d $OUTDIR ]; then
    echo removing existing $OUTDIR
    rm -rf $OUTDIR
fi
echo creating $OUTDIR
mkdir -p $OUTDIR

#- Create a symlink in DESI_SPECTRO_REDUX tree so pipeline can find outputs
export SPECPROD=$USER/$NAME
ln -sf $OUTDIR $DESI_SPECTRO_REDUX/$SPECPROD

#- Use calibnight from DESI production
export COMPARE_SPECPROD=everest
ln -s $DESI_SPECTRO_REDUX/$COMPARE_SPECPROD/calibnight $OUTDIR/calibnight

#- Create a unique directory for crumbs, log files, etc
cd $SCRATCH
mkdir -p ${SLURM_JOB_ID}
cd ${SLURM_JOB_ID}
mkdir -p log
LOGFILE=log/slurm-$SLURM_JOB_ID.out

#- OpenMP Settings
#- https://www.openmp.org/spec-html/5.1/openmpch6.html
export OMP_NUM_THREADS=1

#- Python settings
#- https://docs.python.org/3/using/cmdline.html#environment-variables
# export PYTHONOPTIMIZE=1
export PYTHONFAULTHANDLER=1

#- MPICH settings
export MPICH_GPU_SUPPORT_ENABLED=1

#- srun --cpu-bind=cores
export CPU_BIND=cores

#- Make DESI pipeline less verbose. INFO has noticeable impact on performance at NNODES > 256.
export DESI_LOGLEVEL=WARNING

#- Use exposure tables from DESI production
EXPTABLE=$DESI_SPECTRO_REDUX/$COMPARE_SPECPROD/exposure_tables/202???/exposure_table_*.csv

#- Disable glob expansion to prevent $EXPTABLE from being expanded
set -o noglob

cmd="srun\
 desi_redirect_output -q $LOGFILE\
 desi_mps_wrapper\
 desi_scale_run\
 --exptable $EXPTABLE --task-seed 2222 --weak-numnodes $SLURM_NNODES --weak-maxnodes 1536\
 --gpu --petal-tasks --redshifts\
"

echo "Running:"
echo "    $cmd"

time $cmd --starttime `date +%s.%N`

# time srun desi_redirect_output -c $LOGFILE desi_mps_wrapper desi_scale_run --starttime `date +%s.%N` --exptable "$EXPTABLE" --gpu --petal-tasks --task-seed 3333 --max-tasks $MAXTASKS --redshifts

echo "To compare:"
echo "ls -1 $OUTDIR/tiles/cumulative | sort -n > $(realpath tiles.txt)"
echo "desi_zcatalog -i $OUTDIR/tiles/cumulative/ -o $OUTDIR/ztile-cumulative-gpu.fits --minimal --tiles $(realpath tiles.txt)"
echo "desi_zcatalog -i $DESI_SPECTRO_REDUX/$COMPARE_SPECPROD/tiles/cumulative/ -o $OUTDIR/ztile-cumulative-everest.fits --minimal --tiles $(realpath tiles.txt)"
