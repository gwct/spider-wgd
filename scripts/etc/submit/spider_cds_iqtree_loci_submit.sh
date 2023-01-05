#!/bin/bash
#SBATCH --job-name=spider_cds_iqtree
#SBATCH --output=spider_cds_iqtree-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gregg.thomas@umontana.edu
#SBATCH --partition=holy-info,holy-smokes,holy-cow
#SBATCH --nodes=1
#SBATCH --ntasks=48
#SBATCH --ntasks-per-node=48
#SBATCH --cpus-per-task=1
#SBATCH --mem=24g
#SBATCH --time=48:00:00

parallel -j 48 < /n/home07/gthomas/projects/spider-wgd/scripts/jobs/spider_cds_iqtree_loci.sh