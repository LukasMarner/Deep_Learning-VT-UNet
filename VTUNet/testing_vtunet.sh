#!/bin/bash
#BSUB -J vtunet-predict
#BSUB -o /dtu/blackhole/18/168632/VT-UNet/logs/predict_%J.out
#BSUB -e /dtu/blackhole/18/168632/VT-UNet/logs/predict_%J.err
#BSUB -n 8
#BSUB -R "rusage[mem=8GB]"
#BSUB -R "span[hosts=1]"
#BSUB -W 4:00
#BSUB -gpu "num=1:mode=exclusive_process"
#BSUB -q gpuv100

module load cuda/11.3
export PATH="$HOME/.local/bin:$PATH"
source /dtu/blackhole/18/168632/VT-UNet/VTUNet/.venv/bin/activate

export vtunet_raw_data_base="/dtu/blackhole/18/168632/VT-UNet/DATASET/vtunet_raw/vtunet_raw_data"
export vtunet_preprocessed="/dtu/blackhole/18/168632/VT-UNet/DATASET/vtunet_preprocessed"
export RESULTS_FOLDER_VTUNET="/dtu/blackhole/18/168632/VT-UNet/DATASET/vtunet_trained_models"

mkdir -p /dtu/blackhole/18/168632/VT-UNet/predictions/

vtunet_predict -i /dtu/blackhole/18/168632/VT-UNet/DATASET/vtunet_raw/vtunet_raw_data/vtunet_raw_data/Task003_tumor/imagesTs/ \
               -o /dtu/blackhole/18/168632/VT-UNet/predictions/ \
               -t 3 \
               -m 3d_fullres \
               -tr vtunetTrainerV2_vtunet_tumor \
               -f 0 \
               -chk model_best
