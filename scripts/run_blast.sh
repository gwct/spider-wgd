#!/bin/bash
#SBATCH --job-name=spider_blast
#SBATCH --output=%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gthomas@g.harvard.edu
#SBATCH --partition=holy-info,holy-smokes,holy-cow
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=12g
#SBATCH --time=72:00:00

cd /n/holylfs05/LABS/informatics/Users/gthomas/spiders/blast/

blastp -db spider-16spec-blastdb -query ../isofilter/spider-16spec-peptides.fa -outfmt 7 -seg yes -num_threads 48 > spider-16spec-blast-output.txt