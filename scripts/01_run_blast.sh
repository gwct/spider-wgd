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
#SBATCH --time=72:00:00

## Note that this is run AFTER initial processing of sequences (including makeblast db). See workflow-notes.txt steps 1-6.

cd /n/holylfs05/LABS/informatics/Users/gthomas/spiders/blast/18spec/

blastp -db chelicerate-18spec-blastdb -query ../../isofilter/chelicerate-18spec-peptides.fa -outfmt 7 -seg yes -num_threads 48 > chelicerate-18spec-blast-output.txt
