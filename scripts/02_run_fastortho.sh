#!/bin/bash
#SBATCH --job-name=spider_fastortho_19spec
#SBATCH --output=slurm_logs/%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=gthomas@g.harvard.edu
#SBATCH --partition=holy-info,shared
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=1:00:00

cd /n/home07/gthomas/projects/spider-wgd/scripts/

specstr="18spec"
configfile="/n/home07/gthomas/projects/spider-wgd/scripts/02_fastortho_opts_$specstr.txt"

i=2
sed -i "s/--project_name chelicerate_fastortho_i[0-9]/--project_name chelicerate_fastortho_i$i/g" $configfile
sed -i "s/chelicerate-fastortho-i[0-9].out/chelicerate-fastortho-i$i.out/g" $configfile
sed -i "s/--inflation [0-9]/--inflation $i/g" $configfile
time -p /n/home07/gthomas/env/pkgs/FastOrtho/src/FastOrtho --option_file $configfile

i=3
sed -i "s/--project_name chelicerate_fastortho_i[0-9]/--project_name chelicerate_fastortho_i$i/g" $configfile
sed -i "s/chelicerate-fastortho-i[0-9].out/chelicerate-fastortho-i$i.out/g" $configfile
sed -i "s/--inflation [0-9]/--inflation $i/g" $configfile
time -p /n/home07/gthomas/env/pkgs/FastOrtho/src/FastOrtho --option_file $configfile

i=4
sed -i "s/--project_name chelicerate_fastortho_i[0-9]/--project_name chelicerate_fastortho_i$i/g" $configfile
sed -i "s/chelicerate-fastortho-i[0-9].out/chelicerate-fastortho-i$i.out/g" $configfile
sed -i "s/--inflation [0-9]/--inflation $i/g" $configfile
time -p /n/home07/gthomas/env/pkgs/FastOrtho/src/FastOrtho --option_file $configfile

i=5
sed -i "s/--project_name chelicerate_fastortho_i[0-9]/--project_name chelicerate_fastortho_i$i/g" $configfile
sed -i "s/chelicerate-fastortho-i[0-9].out/chelicerate-fastortho-i$i.out/g" $configfile
sed -i "s/--inflation [0-9]/--inflation $i/g" $configfile
time -p /n/home07/gthomas/env/pkgs/FastOrtho/src/FastOrtho --option_file $configfile

i=6
sed -i "s/--project_name chelicerate_fastortho_i[0-9]/--project_name chelicerate_fastortho_i$i/g" $configfile
sed -i "s/chelicerate-fastortho-i[0-9].out/chelicerate-fastortho-i$i.out/g" $configfile
sed -i "s/--inflation [0-9]/--inflation $i/g" $configfile
time -p /n/home07/gthomas/env/pkgs/FastOrtho/src/FastOrtho --option_file $configfile