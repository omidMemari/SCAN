#!/bin/bash

#SBATCH --account=cds
#SBATCH --gres=gpu:rtx8000:4
#SBATCH --cpus-per-task=16
#SBATCH --mem=320GB
#SBATCH --time=48:00:00
#SBATCH --job-name=t5_scan
#SBATCH --output=t5_scan_%A_%a.out
#SBATCH --array=0-2



SPLIT=around_right  # add_jump, add_turn_left, around_right, jump_around_right, length, opposite_right, right
EPOCHS=10 #60

python -u run_translation.py \
    --benchmark SCAN \
    --use_pretrained_weights True \
    --model_name_or_path t5-base \
    --output_dir out_t5_base_${SPLIT}_${EPOCHS} \
    --train_file data_scan/$SPLIT/train.json \
    --test_file data_scan/$SPLIT/test.json \
    --do_train \
    --do_predict \
    --source_lang en \
    --target_lang en \
    --source_prefix "translate English to English: " \
    --per_device_train_batch_size 10 \
    --per_device_eval_batch_size 10 \
    --num_train_epochs $EPOCHS \
    --seed 1000 \ #$SLURM_ARRAY_TASK_ID \
    --overwrite_output_dir \
    --save_steps 2500000000 \
    --max_target_length 512 \
    --max_source_length 512 \
    --learning_rate 0.0001 \
    --predict_with_generate

echo "Done"
