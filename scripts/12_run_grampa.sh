#!/bin/bash
#SBATCH --job-name=spider_grampa_70
#SBATCH --output=%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gthomas@g.harvard.edu
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH --ntasks=1  
#SBATCH --cpus-per-task=32
#SBATCH --mem=8g
#SBATCH --time=48:00:00

specstr="19spec"
# DATASET: 16spec or 18spec or 19spec

bs="50"
# The bootstrap threshold for rearrangement

indir="/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/$specstr"
grampadir="/n/holylfs05/LABS/informatics/Users/gthomas/spiders/grampa/"

grampa_srcdir="/n/home07/gthomas/projects/grampa/"
grampa="grampa.py"
grampa_procs="30"
cd $grampa_srcdir
pwd
# IO paths and options

if [ $specstr == "16spec" ]; then
    hc_clade="CROTU,LPOLY"
    sp_clade="CSCUL,LRECL,SMIMO,LHESP,PTEPI,NCLAV,TANTI"
    hcsp_clade="CROTU,LPOLY,CSCUL,LRECL,SMIMO,LHESP,PTEPI,NCLAV,TANTI"
elif [ $specstr == "18spec" ]; then
    hc_clade="CROTU,TGIGA,LPOLY"
    sp_clade="CSCUL,LRECL,SMIMO,LHESP,ABRUE,NCLAV,TANTI"
    hcsp_clade="CROTU,TGIGA,LPOLY,CSCUL,LRECL,SMIMO,LHESP,ABRUE,NCLAV,TANTI"
elif [ $specstr == "19spec" ]; then
    hc_clade="CROTU,TGIGA,LPOLY"
    sp_clade="CSCUL,LRECL,SMIMO,LHESP,PTEPI,ABRUE,NCLAV,TANTI"
    hcsp_clade="CROTU,TGIGA,LPOLY,CSCUL,LRECL,SMIMO,LHESP,PTEPI,ABRUE,NCLAV,TANTI"
fi    
# The H1 clades for spiders and horseshoe crabs based on species sampling

# SETUP
####################

prodir="$indir/astral-pro-tree/"
prost="$prodir/chelicerate-$specstr-astral-pro.rooted.tre"
progt="$prodir/loci-rearrange-$bs.rooted.treefile"
proout_full="$grampadir/$specstr/astral-pro-bs$bs-full/"
prefix_full="astral-pro-bs$bs-full"
proout_hc="$grampadir/$specstr/astral-pro-bs$bs-h1-hc/"
prefix_hc="astral-pro-bs$bs-hc"
proout_sp="$grampadir/$specstr/astral-pro-bs$bs-h1-sp/"
prefix_sp="astral-pro-bs$bs-sp"
proout_hcsp="$grampadir/$specstr/astral-pro-bs$bs-h1-hcsp/"
prefix_hcsp="astral-pro-bs$bs-hcsp"

echo "# ASTRAL PRO FULL"
time -p python $grampa -s $prost -g $progt -o $proout_full -c 15 -f $prefix_full -p $grampa_procs
# Full search

echo "# ASTRAL PRO HC"
time -p python $grampa -s $prost -g $progt -o $proout_hc -h1 "$hc_clade" -c 15 -f $prefix_hc -p $grampa_procs
# H1 horseshoe crab branch

echo "# ASTRAL PRO SP"
time -p python $grampa -s $prost -g $progt -o $proout_sp -h1 "$sp_clade" -c 15 -f $prefix_sp -p $grampa_procs
# H1 spider+scorpion branch

echo "# ASTRAL PRO HC+SP"
time -p python $grampa -s $prost -g $progt -o $proout_hcsp -h1 "$hc_clade $sp_clade $hcsp_clade" -c 15 -f $prefix_hcsp -p $grampa_procs
# H1 horseshoe crab AND spider+scorpion branches

# ASTRAL-PRO
####################

astraldir="$indir/astral-single-copy/"
astralst="$astraldir/chelicerate-$specstr-astral-single-copy.rooted.tre"
astralgt="$astraldir/loci-rearrange-$bs.rooted.treefile"
astralout_full="$grampadir/$specstr/astral-single-copy-bs$bs-full/"
prefix_full="astral-sc-bs$bs-full"
astralout_hc="$grampadir/$specstr/astral-single-copy-bs$bs-h1-hc/"
prefix_hc="astral-sc-bs$bs-hc"
astralout_sp="$grampadir/$specstr/astral-single-copy-bs$bs-h1-sp/"
prefix_sp="astral-sc-bs$bs-sp"
astralout_hcsp="$grampadir/$specstr/astral-single-copy-bs$bs-h1-hcsp/"
prefix_hcsp="astral-sc-bs$bs-hcsp"

echo "# ASTRAL SINGLE COPY FULL"
time -p python $grampa -s $astralst -g $astralgt -o $astralout_full -c 15 -f $prefix_full -p $grampa_procs
# Full search

echo "# ASTRAL SINGLE COPY HC"
time -p python $grampa -s $astralst -g $astralgt -o $astralout_hc -h1 "$hc_clade" -c 15 -f $prefix_hc -p $grampa_procs
# H1 horseshoe crab branch

echo "# ASTRAL SINGLE COPY SP"
time -p python $grampa -s $astralst -g $astralgt -o $astralout_sp -h1 "$sp_clade" -c 15 -f $prefix_sp -p $grampa_procs
# H1 spider+scorpion branch

echo "# ASTRAL SINGLE COPY HC+SP"
time -p python $grampa -s $astralst -g $astralgt -o $astralout_hcsp -h1 "$hc_clade $sp_clade" -c 15 -f $prefix_hcsp -p $grampa_procs
# H1 horseshoe crab AND spider+scorpion branches

# ASTRAL SINGLE COPY
####################

multidir="$indir/astral-multi-tree/"
multist="$multidir/chelicerate-$specstr-astral-multi.rooted.tre"
multigt="$multidir/loci-rearrange-$bs.rooted.treefile"
multiout_full="$grampadir/$specstr/astral-multi-bs$bs-full/"
prefix_full="astral-multi-bs$bs-full"
multiout_hc="$grampadir/$specstr/astral-multi-bs$bs-h1-hc/"
prefix_hc="astral-multi-bs$bs-hc"
multiout_sp="$grampadir/$specstr/astral-multi-bs$bs-h1-sp/"
prefix_sp="astral-multi-bs$bs-sp"
multiout_hcsp="$grampadir/$specstr/astral-multi-bs$bs-h1-hcsp/"
prefix_hcsp="astral-multi-bs$bs-hcsp"

echo "# ASTRAL MULTI FULL"
time -p python $grampa -s $multist -g $multigt -o $multiout_full -c 15 -f $prefix_full -p $grampa_procs
# Full search

echo "# ASTRAL MULTI HC"
time -p python $grampa -s $multist -g $multigt -o $multiout_hc -h1 "$hc_clade" -c 15 -f $prefix_hc -p $grampa_procs
# H1 horseshoe crab branch

echo "# ASTRAL MULTI SP"
time -p python $grampa -s $multist -g $multigt -o $multiout_sp -h1 "$sp_clade" -c 15 -f $prefix_sp -p $grampa_procs
# H1 spider+scorpion branch

echo "# ASTRAL MULTI HC+SP"
time -p python $grampa -s $multist -g $multigt -o $multiout_hcsp -h1 "$hc_clade $sp_clade" -c 15 -f $prefix_hcsp -p $grampa_procs
# H1 horseshoe crab AND spider+scorpion branches

# ASTRAL MULTI
####################

baldir="$indir/ballesteros/"
balst="$baldir/ballesteros.tre"
balgt="$baldir/loci-rearrange-$bs.rooted.treefile"
balout_full="$grampadir/$specstr/ballesteros-bs$bs-full/"
prefix_full="ballesteros-bs$bs-full"
balout_hc="$grampadir/$specstr/ballesteros-bs$bs-h1-hc/"
prefix_hc="ballesteros-bs$bs-hc"
balout_sp="$grampadir/$specstr/ballesteros-bs$bs-h1-sp/"
prefix_sp="ballesteros-bs$bs-sp"
balout_hcsp="$grampadir/$specstr/ballesteros-bs$bs-h1-hcsp/"
prefix_hcsp="ballesteros-bs$bs-hcsp"

echo "# BALLESTEROS FULL"
time -p python $grampa -s $balst -g $balgt -o $balout_full -c 15 -f $prefix_full -p $grampa_procs
# Full search

echo "# BALLESTEROS HC"
time -p python $grampa -s $balst -g $balgt -o $balout_hc -h1 "$hc_clade" -c 15 -f $prefix_hc -p $grampa_procs
# H1 horseshoe crab branch

echo "# BALLESTEROS SP"
time -p python $grampa -s $balst -g $balgt -o $balout_sp -h1 "$sp_clade" -c 15 -f $prefix_sp -p $grampa_procs
# H1 spider+scorpion branch

echo "# BALLESTEROS HC+SP"
time -p python $grampa -s $balst -g $balgt -o $balout_hcsp -h1 "$hc_clade $sp_clade $hcsp_clade" -c 15 -f $prefix_hcsp -p $grampa_procs
# H1 horseshoe crab AND spider+scorpion branches

# BALLESTEROS
####################

traddir="$indir/traditional/"
tradst="$traddir/traditional.tre"
tradgt="$traddir/loci-rearrange-$bs.rooted.treefile"
tradout_full="$grampadir/$specstr/traditional-bs$bs-full/"
prefix_full="traditional-bs$bs-full"
tradout_hc="$grampadir/$specstr/traditional-bs$bs-h1-hc/"
prefix_hc="traditional-bs$bs-hc"
tradout_sp="$grampadir/$specstr/traditional-bs$bs-h1-sp/"
prefix_sp="traditional-bs$bs-sp"
tradout_hcsp="$grampadir/$specstr/traditional-bs$bs-h1-hcsp/"
prefix_hcsp="traditional-bs$bs-hcsp"

echo "# TRADITIONAL FULL"
time -p python $grampa -s $tradst -g $tradgt -o $tradout_full -c 15 -f $prefix_full -p $grampa_procs
# Full search

echo "# TRADITIONAL HC"
time -p python $grampa -s $tradst -g $tradgt -o $tradout_hc -h1 "$hc_clade" -c 15 -f $prefix_hc -p $grampa_procs
# H1 horseshoe crab branch

echo "# TRADITIONAL SP"
time -p python $grampa -s $tradst -g $tradgt -o $tradout_sp -h1 "$sp_clade" -c 15 -f $prefix_sp -p $grampa_procs
# H1 spider+scorpion branch

echo "# TRADITIONAL HC+SP"
time -p python $grampa -s $tradst -g $tradgt -o $tradout_hcsp -h1 "$hc_clade $sp_clade" -c 15 -f $prefix_hcsp -p $grampa_procs
# H1 horseshoe crab AND spider+scorpion branches

# TRADITIONAL
####################