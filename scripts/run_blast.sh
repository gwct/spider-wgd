#!/bin/bash
#SBATCH --job-name=spider_blast
#SBATCH --output=%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gthomas@g.harvard.edu
#SBATCH --partition=holy-info,shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=12g
#SBATCH --time=24:00:00

cd /n/holylfs05/LABS/informatics/Users/gthomas/spiders/blast/

blastp -db chelicerate-19spec-blastdb -query ../isofilter/chelicerate-19spec-peptides.fa -outfmt 7 -seg yes -num_threads 48 > chelicerate-19spec-blast-output.txt