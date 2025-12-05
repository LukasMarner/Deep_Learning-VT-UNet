#!/bin/bash
#BSUB -J vtunet-small
#BSUB -o /dtu/blackhole/18/168632/VT-UNet/logs/vtunet_small_%J.out
#BSUB -e /dtu/blackhole/18/168632/VT-UNet/logs/vtunet_small_%J.err
#BSUB -n 8
#BSUB -R "rusage[mem=8GB]"
#BSUB -R "span[hosts=1]"
#BSUB -W 72:00
#BSUB -gpu "num=1:mode=exclusive_process"
#BSUB -q gpua100

echo "=== Job Info ==="
echo "Job ID: $LSB_JOBID"
echo "Host: $(hostname)"
echo "Date: $(date)"

# Load CUDA module
echo "=== Loading CUDA ==="
module load cuda/11.3
module list

# Setup UV and Python environment
echo "=== Setting up Python environment ==="
export PATH="$HOME/.local/bin:$PATH"
export UV_CACHE_DIR=/dtu/blackhole/18/168632/uv_cache

# Activate virtual environment
echo "Activating virtual environment..."
source /dtu/blackhole/18/168632/VT-UNet/VTUNet/.venv/bin/activate

# Verify Python and packages
echo "=== Environment Check ==="
which python
python --version
echo "Checking mmcv..."
python -c "import mmcv; print('mmcv version:', mmcv.__version__)"
python -c "from mmcv.runner import load_checkpoint; print('mmcv.runner: OK')"
echo "Checking torch..."
python -c "import torch; print('PyTorch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available())"

# Set environment variables
export vtunet_raw_data_base="/dtu/blackhole/18/168632/VT-UNet/DATASET/vtunet_raw/vtunet_raw_data"
export vtunet_preprocessed="/dtu/blackhole/18/168632/VT-UNet/DATASET/vtunet_preprocessed"
export RESULTS_FOLDER_VTUNET="/dtu/blackhole/18/168632/VT-UNet/DATASET/vtunet_trained_models"

echo "=== Environment Variables ==="
echo "vtunet_raw_data_base: $vtunet_raw_data_base"
echo "vtunet_preprocessed: $vtunet_preprocessed"
echo "RESULTS_FOLDER_VTUNET: $RESULTS_FOLDER_VTUNET"

# Change to vtunet directory
cd /dtu/blackhole/18/168632/VT-UNet/VTUNet/vtunet
echo "Working directory: $(pwd)"

# Print GPU info
echo "=== GPU Info ==="
nvidia-smi

# Start training
echo "=== Starting Training ==="
echo "Command: vtunet_train 3d_fullres vtunetTrainerV2_vtunet_tumor 3 0"
vtunet_train 3d_fullres vtunetTrainerV2_vtunet_tumor 3 0

echo "=== Training Completed ==="
echo "End time: $(date)"
