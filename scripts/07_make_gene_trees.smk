#############################################################################
# Snakemake rule to run IQ-Tree on an input directory with CDS alignments
# Gregg Thomas, January 2023
#############################################################################

# snakemake -p -s 01_guidance.smk --configfile snakemake-config.yaml --profile slurm_profile/ --keep-going --dryrun

#############################################################################

import os

#############################################################################

ALNDIR = config["aln_filter_directory"]
TREEDIR = config["tree_directory"]

loci = [ cds_file.split("-cds.guidance.filter.fa")[0] for cds_file in os.listdir(CDSDIR) ];
print("# making gene trees for ", len(loci), " loci");

#############################################################################
# Final rule - rule that depends on final expected output file and initiates all
# the other rules

localrules: all

rule all:
    input:
        expand(os.path.join(TREEDIR, "cds-iqtree", "loci", "{locus}", "{locus}.treefile"), locus=loci)
        # Output from make_gene_trees

#############################################################################
# Pipeline rules

rule make_gene_trees:
    input: 
        os.path.join(ALNDIR, "02-Filter-spec7-seq50-site50", "cds", "{locus}-cds.guidance.filter.fa")
    output:
        os.path.join(TREEDIR, "cds-iqtree", "loci", "{locus}", "{locus}.treefile")
    params:
        prefix = os.path.join(TREEDIR, "cds-iqtree", "loci", "{locus}", "{locus}")
    log:
        os.path.join(TREEDIR, "logs", "cds-iqtree", "{locus}-cds-iqtree.log")
    resources:
        cpus = 4
    shell:
     """
        iqtree -s {input} --prefix {params.prefix} -B 1000 -T 4 &> {log}
     """

#############################################################################