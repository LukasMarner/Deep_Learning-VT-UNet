#!/bin/bash
#BSUB -J vtunet-scratch
#BSUB -o /dtu/blackhole/18/168632/VT-UNet/logs/scratch_%J.out
#BSUB -e /dtu/blackhole/18/168632/VT-UNet/logs/scratch_%J.err
#BSUB -n 8
#BSUB -R "rusage[mem=8GB]"
#BSUB -R "span[hosts=1]"
#BSUB -W 72:00
#BSUB -gpu "num=1:mode=exclusive_process"
#BSUB -q gpua100

module load cuda/11.3
export PATH="$HOME/.local/bin:$PATH"
source /dtu/blackhole/18/168632/VT-UNet/VTUNet/.venv/bin/activate

export vtunet_raw_data_base="/dtu/blackhole/18/168632/VT-UNet/DATASET/vtunet_raw/vtunet_raw_data"
export vtunet_preprocessed="/dtu/blackhole/18/168632/VT-UNet/DATASET/vtunet_preprocessed"
export RESULTS_FOLDER_VTUNET="/dtu/blackhole/18/168632/VT-UNet/DATASET/vtunet_trained_models_scratch"

cd /dtu/blackhole/18/168632/VT-UNet/VTUNet/vtunet
nvidia-smi
vtunet_train 3d_fullres vtunetTrainerV2_vtunet_tumor 3 0
