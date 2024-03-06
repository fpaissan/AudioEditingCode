#!/bin/bash
directory=$1

mkdir -p eval

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Directory '$directory' not found."
    exit 1
fi

# Iterate through the files in the directory
for file in "$directory"/*.txt; do
    # Check if the file is a regular file
    if [ -f "$file" ]; then
        echo "Processing file: $file"
        stringified_path=${file//\//_}

        file_path=$(head -n 1 $file)
        t_arg=$(tail -n 1 $file)
       
        # Check if file_path exists
        if [ ! -f "$file_path"  ]; then
            echo "Error: File $file_path not found"
            exit 1
        fi

        for tstart in 25 50 75; do
          echo WANDB_SILENT=true python -Wignore main_run_sdedit.py --init_aud $file_path --cfg_tar 3 --target_prompt "$t_arg" --num_diffusion_steps 100 --tstart $tstart --wandb_disable
          WANDB_SILENT=true python -Wignore main_run_sdedit.py --init_aud $file_path --cfg_tar 3 --target_prompt "$t_arg" --num_diffusion_steps 100 --tstart $tstart --wandb_disable
        done
    fi
done
