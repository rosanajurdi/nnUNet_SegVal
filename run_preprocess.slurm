#!/bin/bash
#SBATCH -A pzi@v100
#SBATCH --job-name=SMILE     # job name
#SBATCH --ntasks=1                   # number of MP tasks
#SBATCH --ntasks-per-node=1          # number of MPI tasks per node
#SBATCH --gres=gpu:3                 # number of GPUs per node
#SBATCH --cpus-per-task=24           # number of cores per tasks
# /!\ Caution, in the following line, "multithread" refers to hyperthreading.
#SBATCH --hint=nomultithread         # we get physical cores not logical
#SBATCH --distribution=block:block   # we pin the tasks on contiguous cores
#SBATCH --time=50:00:00              # maximum execution time (HH:MM:SS)
#SBATCH --output=./mod_9_redo%j.out # output file name
#SBATCH --error=./mod_9_redo%j.out  # error file name
#SBATCH --qos=qos_gpu-t4         # we are submitting a test job

set -x
cd ${SLURM_SUBMIT_DIR}

module purge
conda activate nnUnet_2
nnUNet_plan_and_preprocess -t 600 --verify_dataset_integrity

wait

