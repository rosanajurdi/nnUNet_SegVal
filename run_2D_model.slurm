#!/bin/bash
#SBATCH -A pzi@v100
#SBATCH --job-name=nnUnet-Hippocampus     # job name
#SBATCH --ntasks=1                   # number of MP tasks
#SBATCH --ntasks-per-node=1          # number of MPI tasks per node
#SBATCH --partition=gpu_p2
#SBATCH --gres=gpu:1                 # number of GPUs per node
#SBATCH --cpus-per-task=24           # number of cores per tasks
# /!\ Caution, in the following line, "multithread" refers to hyperthreading.
#SBATCH --hint=nomultithread         # we get physical cores not logical
#SBATCH --distribution=block:block   # we pin the tasks on contiguous cores
#SBATCH --time=99:00:00              # maximum execution time (HH:MM:SS)
#SBATCH --output=./2D%j.out # output file name
#SBATCH --error=./2D%j.out  # error file name
##SBATCH --qos=qos_gpu-t4         # we are submitting a test job
set -x
cd ${SLURM_SUBMIT_DIR}
#export INPUT_FOLDER=/gpfswork/rech/pzi/uju59ys/nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Task004_SegVal_Hippocampu/imagesTs
#export OUTPUT_FOLDER=/gpfswork/rech/pzi/uju59ys/nnUNet/nnUNet_raw_data_base/nnUNet_raw_data/Task004_SegVal_Hippocampu/predict_2D
module purge
conda activate nnUnet_2
srun nnUNet_plan_and_preprocess -t 600 --verify_dataset_integrity
#srun nnUNet_plan_and_preprocess -t 1
#srun nnUNet_train 3d_fullres nnUNetTrainerV2 1 0
#srun nnUNet_predict -i ${INPUT_FOLDER} -o ${OUTPUT_FOLDER} -t 4 -m 2d
wait
