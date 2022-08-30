#!/bin/bash
#SBATCH --job-name=spider_fastortho_i2
#SBATCH --output=%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gthomas@g.harvard.edu
#SBATCH --partition=holy-info,shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=24:00:00

source ~/anaconda3/bin/activate
conda activate main

cd /n/home07/gthomas/projects/spiders/scripts/

time -p /n/home07/gthomas/env/pkgs/FastOrtho/src/FastOrtho --option_file fastortho_opts.txt