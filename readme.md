# desiscaleflow


```
# Checkout this repo
git clone git@github.com:dmargala/desiscaleflow.git
cd desiscaleflow
```

## Setup conda env

Choose a place to setup your conda environment. For example, I've chosen a directory on `/global/common/software` at NERSC.

```
DESI_SCALE_ENV=/global/common/software/dasrepo/dmargala/desi-scale-run
```

The `bin/setup-env-gpu-p8r.sh` script will create a conda environment using the provided environment prefix. It will install all package dependencies and set required DESI environment variables in the environment. The script assumes you are on a perlmutter login node with default modules loaded.

```
# Setup conda environment
bin/setup-env-gpu-p8r.sh $DESI_SCALE_ENV
```

Finally, use the `bin/launch-p8r.sh` script to install this repo into the new conda environment. The `bin/launch-p8r.sh` script assumes you are on a perlmutter login node with default modules loaded. It will load the required modules and activate the specified conda environment before executing the rest of your command.

```
# Install desi_scale_run and desi_redirect_output
bin/launch-p8r.sh $DESI_SCALE_ENV pip install .
```

## Run using existing conda env

```
# Run a single node job
bin/launch-p8r.sh $DESI_SCALE_ENV sbatch -N 1 -q early_science slurm/scale-run.sh
```

```
# Run a 1536 node job
bin/launch-p8r.sh $DESI_SCALE_ENV sbatch -N 1536 -q early_science slurm/scale-run.sh
```
