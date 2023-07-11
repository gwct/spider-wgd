#############################################################################
# Snakemake rule to run Guidance on an input directory with CDS sequences
# Gregg Thomas, January 2023
#############################################################################

# snakemake -p -s 05_aln_cds.smk --configfile 16spec_config.yaml --profile slurm_profile/ --keep-going --dryrun
# snakemake -p -s 05_aln_cds.smk --configfile 18spec_config.yaml --profile slurm_profile/ --keep-going --dryrun
# snakemake -p -s 05_aln_cds.smk --configfile 19spec_config.yaml --profile slurm_profile/ --keep-going --dryrun

#############################################################################

import os

#############################################################################

CONDAPATH = config["conda_env_path"]

DATASET = config["dataset"]
INFILE = config["locus_file"]
CDSDIR = config["cds_directory"]
ALNDIR = config["aln_directory"]

loci = [ line.strip() for line in open(INFILE) ];
print("# aligning ", len(loci), " orthogroups");


#############################################################################
# Final rule - rule that depends on final expected output file and initiates all
# the other rules

localrules: all

rule all:
    input:
        expand(os.path.join(ALNDIR, "{locus}", "{locus}.MAFFT.Without_low_SP_Col.With_Names"), locus=loci),
        # Output files from run_guidance

#############################################################################
# Pipeline rules

rule run_guidance:
    input:
        os.path.join(CDSDIR, "{locus}-cds.fa")
    output:
        aln_file = os.path.join(ALNDIR, "{locus}", "{locus}.MAFFT.Without_low_SP_Col.With_Names"),
        output_directory = directory(os.path.join(ALNDIR, "{locus}"))
    params:
        locus = "{locus}",
    log:
        os.path.join(ALNDIR, "logs", "01-Guidance", "{locus}-cds.log")
    resources:
        cpus = 4,
	time = "8:00:00"
    shell:
        """
        perl {CONDAPATH}/opt/guidance/www/Guidance/guidance.pl --seqFile {input} --msaProgram MAFFT --seqType codon --outDir {output.output_directory} --dataset {params.locus} --proc_num {resources.cpus} &> {log}
        """

#############################################################################
