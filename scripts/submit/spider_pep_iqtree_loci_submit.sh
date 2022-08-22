#!/bin/bash
#SBATCH --job-name=spider_pep_iqtree
#SBATCH --output=spider_pep_iqtree-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gregg.thomas@umontana.edu
#SBATCH --partition=holy-info,holy-smokes,holy-cow
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --cpus-per-task=1
#SBATCH --mem=24g
#SBATCH --time=24:00:00

source ~/anaconda3/bin/activate
conda activate cds-aln-2

parallel -j 48 < /n/home07/gthomas/projects/spider-wgd/scripts/jobs/spider_pep_iqtree_loci.sh