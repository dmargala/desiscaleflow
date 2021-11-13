# desiscaleflow


```
# Checkout this repo
git clone git@github.com:dmargala/desiscaleflow.git

# Setup conda environment
cd desiscaleflow
CONDA_PREFIX=/global/common/software/dasrepo/dmargala/desi-scale-run
./bin/setup-env-gpu-p8r.sh $CONDA_PREFIX

# Install desi_scale_run and desi_redirect_output from this repo
pip install .

# Run a single node job
bin/launch-p8r.sh $CONDA_PREFIX sbatch -N 1 -q early_science slurm/scale-run.sh
```
