#!/bin/bash
#SBATCH --job-name=spider_notung_50
#SBATCH --output=slurm_logs/%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gthomas@g.harvard.edu
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=1:00:00

specstr="19spec"
# DATASET: 16spec or 19spec

bs="50"
# The bootstrap threshold for rearrangement

####################

indir="/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/$specstr"
gtdir="$indir/cds-iqtree/loci/"
gtfilenames="$indir/cds-iqtree/loci-filenames.txt"

cd $gtdir

echo "# GETTING GENE TREE FILE NAMES..."
find "$(pwd -P)" -name *.rooted.treefile > $gtfilenames
# Write the filenames of the rooted trees to a file
####################

prodir="$indir/astral-pro-tree/"
prorooted="$prodir/chelicerate-$specstr-astral-pro.rooted.tre"
profilenames="$prodir/loci-filenames-pro-st.txt"
prorearrange="$prodir/loci-rearrange-$bs/"
prolog="$prodir/loci-rearrange-$bs.log"
progt="$prodir/loci-rearrange-$bs.rooted.treefile"

echo "# ADDING SPECIES TREE FILE NAME TO ASTRAL-PRO GENE TREE FILE..."
echo $prorooted | cat - $gtfilenames > $profilenames
# Add the species tree filename to the list of gene tree files for Notung

echo "# RUNNING NOTUNG FOR BOOTSTRAP REARRANGEMENT ON ASTRAL-PRO TREE..."
time -p java -jar /n/home07/gthomas/env/pkgs/notung/Notung-2.9.1.5.jar -b $profilenames --absfilenames --rearrange --speciestag postfix --threshold $bs --edgeweights name --treeoutput newick --nolosses --outputdir $prorearrange 2> $prolog
# Bootstrap rearrangement for NOTUNG

echo "# COMBINING ASTRAL-PRO REARRANGED TREES IN SINGLE FILE..."
awk '{print}' $prorearrange/*.rooted.treefile.rearrange.0 > $progt
# Combine rearranged gene trees for GRAMPA

# ASTRAL-PRO
####################

astraldir="$indir/astral-single-copy/"
astralrooted="$astraldir/chelicerate-$specstr-astral-single-copy.rooted.tre"
astralfilenames="$astraldir/loci-filenames-single-copy-st.txt"
astralrearrange="$astraldir/loci-rearrange-$bs/"
astrallog="$astraldir/loci-rearrange-$bs.log"
astralgt="$astraldir/loci-rearrange-$bs.rooted.treefile"

echo "# ADDING SPECIES TREE FILE NAME TO ASTRAL SINGLE COPY GENE TREE FILE..."
echo $astralrooted | cat - $gtfilenames > $astralfilenames
# Add the species tree filename to the list of gene tree files for Notung

echo "# RUNNING NOTUNG FOR BOOTSTRAP REARRANGEMENT ON ASTRAL SINGLE COPY TREE..."
time -p java -jar /n/home07/gthomas/env/pkgs/notung/Notung-2.9.1.5.jar -b $astralfilenames --absfilenames --rearrange --speciestag postfix --threshold $bs --edgeweights name --treeoutput newick --nolosses --outputdir $astralrearrange 2> $astrallog
# Bootstrap rearrangement for NOTUNG

echo "# COMBINING ASTRAL SINGLE COPY REARRANGED TREES IN SINGLE FILE..."
awk '{print}' $astralrearrange/*.rooted.treefile.rearrange.0 > $astralgt
# Combine rearranged gene trees for GRAMPA

# ASTRAL SINGLE COPY
####################

multidir="$indir/astral-multi-tree/"
multirooted="$multidir/chelicerate-$specstr-astral-multi.rooted.tre"
multifilenames="$multidir/loci-filenames-multi-st.txt"
multirearrange="$multidir/loci-rearrange-$bs/"
multilog="$multidir/loci-rearrange-$bs.log"
multigt="$multidir/loci-rearrange-$bs.rooted.treefile"

echo "# ADDING SPECIES TREE FILE NAME TO ASTRAL-MULTI GENE TREE FILE..."
echo $multirooted | cat - $gtfilenames > $multifilenames
# Add the species tree filename to the list of gene tree files for Notung

echo "# RUNNING NOTUNG FOR BOOTSTRAP REARRANGEMENT ON ASTRAL-MULTI TREE..."
time -p java -jar /n/home07/gthomas/env/pkgs/notung/Notung-2.9.1.5.jar -b $multifilenames --absfilenames --rearrange --speciestag postfix --threshold $bs --edgeweights name --treeoutput newick --nolosses --outputdir $multirearrange 2> $multilog
# Bootstrap rearrangement for NOTUNG

echo "# COMBINING ASTRAL MULTI SINGLE COPY REARRANGED TREES IN SINGLE FILE..."
awk '{print}' $multirearrange/*.rooted.treefile.rearrange.0 > $multigt
# Combine rearranged gene trees for GRAMPA

# ASTRAL-MULTI
####################

baldir="$indir/ballesteros/"
balrooted="$baldir/ballesteros.tre"
balfilenames="$baldir/loci-filenames-ballesteros-st.txt"
balrearrange="$baldir/loci-rearrange-$bs/"
ballog="$baldir/loci-rearrange-$bs.log"
balgt="$baldir/loci-rearrange-$bs.rooted.treefile"

echo "# ADDING SPECIES TREE FILE NAME TO BALLESTEROS GENE TREE FILE..."
echo $balrooted | cat - $gtfilenames > $balfilenames
# Add the species tree filename to the list of gene tree files for Notung

echo "# RUNNING NOTUNG FOR BOOTSTRAP REARRANGEMENT ON BALLESTEROS TREE..."
time -p java -jar /n/home07/gthomas/env/pkgs/notung/Notung-2.9.1.5.jar -b $balfilenames --absfilenames --rearrange --speciestag postfix --threshold $bs --edgeweights name --treeoutput newick --nolosses --outputdir $balrearrange 2> $ballog
# Bootstrap rearrangement for NOTUNG

echo "# COMBINING BALLESTEROS REARRANGED TREES IN SINGLE FILE..."
awk '{print}' $balrearrange/*.rooted.treefile.rearrange.0 > $balgt
# Combine rearranged gene trees for GRAMPA

# BALLESTEROS
####################

traddir="$indir/traditional/"
tradrooted="$traddir/traditional.tre"
tradfilenames="$traddir/loci-filenames-traditional-st.txt"
tradrearrange="$traddir/loci-rearrange-$bs/"
tradlog="$traddir/loci-rearrange-$bs.log"
tradgt="$traddir/loci-rearrange-$bs.rooted.treefile"

echo "# ADDING SPECIES TREE FILE NAME TO TRADITIONAL GENE TREE FILE..."
echo $tradrooted | cat - $gtfilenames > $tradfilenames
# Add the species tree filename to the list of gene tree files for Notung

echo "# RUNNING NOTUNG FOR BOOTSTRAP REARRANGEMENT ON TRADITIONAL TREE..."
time -p java -jar /n/home07/gthomas/env/pkgs/notung/Notung-2.9.1.5.jar -b $tradfilenames --absfilenames --rearrange --speciestag postfix --threshold $bs --edgeweights name --treeoutput newick --nolosses --outputdir $tradrearrange 2> $tradlog
# Bootstrap rearrangement for NOTUNG

echo "# COMBINING TRADITIONAL REARRANGED TREES IN SINGLE FILE..."
awk '{print}' $tradrearrange/*.rooted.treefile.rearrange.0 > $tradgt
# Combine rearranged gene trees for GRAMPA

# TRADITIONAL
####################