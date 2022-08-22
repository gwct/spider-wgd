#!/bin/bash
#SBATCH --job-name=spider_pep_iqtree
#SBATCH --output=spider_pep_iqtree-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gregg.thomas@umontana.edu
#SBATCH --partition=holy-info,holy-smokes,holy-cow
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=24

iqtree -p /n/holylfs05/LABS/informatics/Users/gthomas/spiders/aln/02-Filter-spec4-seq20-site50/pep --prefix /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/pep-iqtree/concat/spider_pep_iqtree -B 1000 -T 1 &> /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/pep-iqtree/concat/concat-terminal.log
iqtree -t /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/pep-iqtree/concat/spider_pep_iqtree.treefile --gcf /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/pep-iqtree/loci.treefile -p /n/holylfs05/LABS/informatics/Users/gthomas/spiders/aln/02-Filter-spec4-seq20-site50/pep --scf 100 --cf-verbose --prefix /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/pep-iqtree/concord/spider_pep_iqtree -T 1