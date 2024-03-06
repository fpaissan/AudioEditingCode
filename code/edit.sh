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

        echo "python imagic.py --input_path $file --out_ckpt $stringified_path.ckpt"
        python -Wignore imagic.py --input_path $file --out_ckpt $stringified_path.ckpt

        echo "python interpolate.py --input_path $file --finetuned checkpoints/$stringified_path.ckpt --output_dir eval/$stringified_path"
        python -Wignore interpolate.py --input_path $file --finetuned checkpoints/$stringified_path.ckpt --output_dir eval/$stringified_path

        echo "python eval.py --output_dir eval/$stringified_path"
        python -Wignore eval.py --output_dir eval/$stringified_path/interpolate
    fi
done
