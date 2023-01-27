#!/bin/bash
#SBATCH --job-name=spider_astral
#SBATCH --output=slurm_logs/%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gthomas@g.harvard.edu
#SBATCH --partition=holy-info,shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=1:00:00

module load jdk
# Load java module
####################

specstr="19spec"

indir="/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/$specstr"
gtdir="$indir/cds-iqtree/loci.treefile"

# DATASET: 16spec or 19spec
####################

prodir="$indir/astral-pro-tree/"
promap="$prodir/gene-to-spec-map.txt"
proout="$prodir/chelicerate-$specstr-astral-pro.tre"
prolog="$prodir/astral-pro.log"

echo "# RUNNING ASTRAL PRO"
time -p astral-pro -a $promap -o $proout $gtfile 2> $prolog

echo "# ROOTING ASTRAL PRO TREE"
prorooted="$prodir/chelicerate-$specstr-astral-pro.rooted.tre"
nw_reroot -l $proout DMELA BMORI > $prorooted

# ASTRAL-PRO
####################

astraldir="$indir/astral-single-copy/"
scgtfile="$indir/cds-iqtree/loci-single-copy.rooted.treefile"
astralout="$astraldir/chelicerate-$specstr-astral-single-copy.tre"
astrallog="$astraldir/astral.log"

echo "# RUNNING ASTRAL ON SINGLE COPY GENES"
time -p astral -i $scgtfile -o $astralout 2> $astrallog

echo "# ROOTING ASTRAL SINGLE COPY TREE"
astralrooted="$astraldir/chelicerate-$specstr-astral-single-copy.rooted.tre"
nw_reroot -l $astralout DMELA BMORI > $astralrooted

# ASTRAL SINGLE COPY
####################

multidir="$indir/astral-multi-tree/"
multimap="$multidir/gene-to-spec-map-single-line.txt"
gtrelabel="$multidir/loci-relabled.treefile"
multiremap="$multidir/gene-to-spec-remap.txt"
multiout="$multidir/chelicerate-$specstr-astral-multi.tre"
multilog="$multidir/astral-multi.log"

echo "# RELABELING GENE TREES FOR ASTRAL MULTI"
time -p astral -i $gtfile -a $multimap -o $gtrelabel -R > $multiremap

echo "# RUNNING ASTRAL MULTI"
time -p astral -i $gtrelabel -a $multiremap -o $multiout 2> $multilog

echo "# ROOTING ASTRAL MULTI TREE"
multirooted="$multidir/chelicerate-$specstr-astral-multi.rooted.tre"
nw_reroot -l $multiout DMELA BMORI > $multirooted

# ASTRAL MULTI
####################