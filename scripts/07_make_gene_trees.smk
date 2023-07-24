#############################################################################
# Snakemake rule to run IQ-Tree on an input directory with CDS alignments
# Gregg Thomas, January 2023
#############################################################################

# snakemake -p -s 07_make_gene_trees.smk --configfile 19spec_config.yaml --profile slurm_profile/ --keep-going --dryrun

#############################################################################

import os

#############################################################################

DATASET = config["dataset"];
ALNDIR = config["aln_filter_directory"];
ALNDIR = os.path.join(ALNDIR, "cds");
TREEDIR = config["tree_directory"];

loci = [ aln_file.split("-cds.guidance.filter.fa")[0] for aln_file in os.listdir(ALNDIR) ];
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
        os.path.join(ALNDIR, "{locus}-cds.guidance.filter.fa")
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