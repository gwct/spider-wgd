#!/bin/bash
#SBATCH --job-name=spider_grampa
#SBATCH --output=%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gthomas@g.harvard.edu
#SBATCH --partition=holy-info,holy-smokes,shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=8g
#SBATCH --time=2:00:00

cd /n/home07/gthomas/projects/grampa/
#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/loci.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-full -p 30
# Full search

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/ballesteros.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/loci.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/ballesteros-full -p 30
# Ballesteros topology

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/traditional.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/loci.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/traditional-full -p 30
# Traditional topology (horseshoe crabs outside of arachnids)

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/loci.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-h1-5 -h1 5 -p 30
# H1 spider branch

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/loci.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-h1-7 -h1 7 -p 30
# H1 horseshoe crab branch

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/loci.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-h1-5-7 -h1 "5 7" -p 30
# H1 horseshoe crab branch AND spider branch

#######################

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-70.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-r70-full -p 30
# Full search, BS rearrange 70

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-70.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-r70-h1-5 -h1 5 -p 30
# H1 spider branch, BS rearrange 70

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-70.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-r70-h1-7 -h1 7 -p 30
# H1 horseshoe crab branch, BS rearrange 70

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-70.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-r70-h1-5-7 -h1 "5 7" -p 30
# H1 horseshoe crab branch AND spider branch, BS rearrange 70

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/ballesteros.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-70.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/ballesteros-r70-full -p 30
# Ballesteros topology, BS rearrange 70

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/traditional.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-70.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/traditional-r70-full -p 30
# Traditional topology (horseshoe crabs outside of arachnids), BS rearrange 70

#######################

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-90.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-r90-full-c15 -c 15 -p 30
# Full search, BS rearrange 90

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-90.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-r90-h1-5 -h1 5 -p 30
# H1 spider branch, BS rearrange 90

#time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-90.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-r90-h1-7 -h1 7 -p 30
# H1 horseshoe crab branch, BS rearrange 90

time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/chelicerate-16spec-astral-pro.rooted.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-90.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/cds-apro-r90-h1-5-7-c15 -h1 "5 7" -c 15 -p 30
# H1 horseshoe crab branch AND spider branch, BS rearrange 90

time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/ballesteros.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-90.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/ballesteros-r90-full-c15 -c 15 -p 30
# Ballesteros topology, BS rearrange 90

time -p python /n/home07/gthomas/projects/grampa/grampa.py -s /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/traditional.tre -g /n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/cds-iqtree/astral-pro-tree/loci-rearrange-90.rooted.treefile -o /n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/traditional-r90-full-c15 -c 15 -p 30
# Traditional topology (horseshoe crabs outside of arachnids), BS rearrange 90