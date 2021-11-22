#############################################################################
# Pulls sequences from a FastOrtho result file
#
# Authors: Gregg Thomas and Clara Boothby (regex)
#############################################################################

import sys
import os
import re
import core as CORE
import seqparse as SEQ
import gxfparse as GXF

#############################################################################

specs = ["bmori", "crotu", "cscul", "dmela", "iscap", "lhesp", "lpoly", "lrecl", "mocci", "nclav", "ptepi", "smimo", "sscab", "tanti", "turti", "vdest"];
#specs = ["sscab"];
# Species list

seqs = { s : {'pep' : {}, 'cds' : {}, 'ids' : {}} for s in specs }
# A dict to store the sequences and ids for each species in memory

cds_dir = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/genomes/"
pep_dir = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/isofilter/"
ortholog_file = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/fastortho/spider-fastortho-i3.out"
outdir = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/seq/"

logfilename = "get-orths-" + CORE.getLogTime() + ".log";
# I/O options

####################

pad = 20;
with open(logfilename, "w") as logfile:
    CORE.runTime("# Get sequences", logfile);
    CORE.PWS(CORE.spacedOut("# Ortholog file:", pad) + ortholog_file, logfile);
    CORE.PWS(CORE.spacedOut("# Peptide dir:", pad) + pep_dir, logfile);
    CORE.PWS(CORE.spacedOut("# CDS dir:", pad) + cds_dir, logfile);
    CORE.PWS(CORE.spacedOut("# Output dir:", pad) + outdir, logfile);
    CORE.PWS(CORE.spacedOut("# Log file:", pad) + logfilename, logfile);
    CORE.PWS("# ----------------", logfile);

    CORE.PWS("# " + CORE.getDateTime() + " Reading sequences", logfile);

    for spec in specs:
        CORE.PWS("# " + CORE.getDateTime() + " " + spec, logfile);

        pep_file = os.path.join(pep_dir, spec, spec + "-longest-isoforms.fa");
        cds_file = [ f for f in os.listdir(os.path.join(cds_dir, spec)) if any(s in f for s in ["cds", "CDS"]) ][0];
        cds_file = os.path.join(cds_dir, spec, cds_file);
        gff_file = [ f for f in os.listdir(os.path.join(cds_dir, spec)) if any(f.endswith(ext) for ext in [".gff.gz", ".gff3.gz", ".gff3", ".gff"]) ][0];
        gff_file = os.path.join(cds_dir, spec, gff_file);
        # Get files for the current species

        CORE.PWS("# " + CORE.getDateTime() + "    Reading peptides   : " + pep_file, logfile);
        seqs[spec]['pep'] = SEQ.fastaReadSeqs(pep_file, header_sep=" ");
        CORE.PWS("# " + CORE.getDateTime() + "    Success            : " + str(len(seqs[spec]['pep'])) + " seqs read", logfile);
        CORE.PWS("# " + CORE.getDateTime() + "    Reading CDS        : " + cds_file, logfile);
        seqs[spec]['cds'] = SEQ.fastaReadSeqs(cds_file, header_sep=" ");
        CORE.PWS("# " + CORE.getDateTime() + "    Success            : " + str(len(seqs[spec]['cds'])) + " seqs read", logfile);
        # Read sequences for the current species

        #print(seqs[spec]['pep'].keys());

        CORE.PWS("# " + CORE.getDateTime() + "    Reading annotations: " + gff_file, logfile);
        cur_exons, comp, tid_to_gid, pid_to_tid = GXF.getExons(gff_file, coding_only=True);
        # Read annotations for the current species

        #print(pid_to_tid);
        #sys.exit();
        pid_to_tid_edit = {};
        for pid in pid_to_tid:
        # The species come from a variety of databases, each with their own quirks re ids. This
        # block tries to fix them so we can easily link the protein and CDS ids

            if spec in ["bmori", "dmela", "iscap", "smimo", "sscab", "turti", "vdest"]:
                pid_edit = pid.replace("CDS:", "");
                tid_edit = pid_to_tid[pid].replace("transcript:", "");

            elif spec in ["crotu"]:
                pid_edit = pid.replace(".cds", "");
                tid_edit = pid_to_tid[pid];
            
            elif spec in ["cscul", "lpoly", "mocci", "nclav", "ptepi"]:
                pid_edit = pid.replace("cds-", "");
                tid_edit = pid_edit;

            elif spec in ["lhesp", "lrecl"]:
                pid_edit = pid_to_tid[pid].replace("-RA", "-PA");
                tid_edit = pid_to_tid[pid];

            elif spec in ["tanti"]:
                pid_edit = pid.replace(":cds", "");
                tid_edit = pid_to_tid[pid];

            else:
                pid_edit = pid;
                tid_edit = pid_to_tid[pid];


            if re.search("-PA.[\d]+", pid_edit):
                pid_edit = pid_edit[:-2];

            if re.search("-RA.[\d]+", tid_edit):
                tid_edit = tid_edit[:-2];
            # Some ids have a version for the sequence (e.g. .1) which 
            # we remove here
            
            pid_to_tid_edit[pid_edit] = tid_edit
        ## End id edit block

        seqs[spec]['ids'] = pid_to_tid_edit;
        CORE.PWS("# " + CORE.getDateTime() + "    Success            : " + str(len(seqs[spec]['ids'])) + " protein IDs read", logfile);
        # Save the ids

####################

    CORE.PWS("# " + CORE.getDateTime() + " Reading orthologs and writing sequences", logfile);
    num_clusters = "41448";
    # The total number of clusters from the i3 file

    num_written = 0;
    incorrect_num_seqs = [];
    # Some trackers

    i = 1;
    multi_cds = 0;
    for line in open(ortholog_file):
    # Go through every ortholog cluster in the file

        line = line.strip().split("\t");
        # Parse the line

        cluster_info = line[0].split(" ");
        # Parse the cluster info

        cluster_id = cluster_info[0];
        # Extract the cluster id

        expected_seqs = int(cluster_info[1].replace("(", ""));
        # Extract the number of sequences in the cluster

        #print(str(i) + " / " + num_clusters + " " + cluster_id);
        i += 1;
        # Print a status update

        protein_ids = re.sub("\(([^)]+)\)", "", line[1]).split(" ");
        protein_ids = list(filter(None, protein_ids));
        # Remove the file name from the protein ids

        pep_outfile = os.path.join(outdir, "pep", cluster_id + "-pep.fa");
        cds_outfile = os.path.join(outdir, "cds", cluster_id + "-cds.fa");
        # Set the output files

        cur_num_written = 0;
        # Tracking for the current cluster

        with open(pep_outfile, "w") as pepout, open(cds_outfile, "w") as cdsout:
        # Open the output files

            for orth in protein_ids:
            # Go through every ortholog in the current cluster

                spec = orth[:orth.index("-")].lower();
                pid = orth[orth.index("-")+1:];
                # Split the ortholog id into the species label and protein id

                if re.search("-PA.[\d]+", pid):
                    pid = pid[:-2];
                # Remove any version numbers from the protein id (e.g. .1)

                pep_seq = seqs[spec]['pep'][orth];
                # Lookup the protein sequence

                tid = seqs[spec]['ids'][pid];
                # Lookup the transcript/CDS id

                cds_header = [key for key, val in seqs[spec]['cds'].items() if tid in key];
                # Lookup the CDS header by looking for headers that contain the current transcript id

                if len(cds_header) != 1:
                # Ideally, there would be only one header per transcript, but that isn't the case for some (8)
                # sequences... Skip these for now
                    CORE.PWS("# " + CORE.getDateTime() + " Multiple headers found for transcript ID: " + tid, logfile);
                    CORE.PWS("# " + CORE.getDateTime() + " Species: " + spec, logfile);
                    CORE.PWS("# " + CORE.getDateTime() + " Associated protein ID: " + pid, logfile);
                    CORE.PWS("# " + CORE.getDateTime() + " Ortho cluster: " + cluster_id, logfile);
                    CORE.PWS("# " + CORE.getDateTime() + " Headers: " + str(cds_header), logfile);
                    CORE.PWS("# " + CORE.getDateTime() + " ********** ", logfile);
                    multi_cds += 1;
                    continue;
                ## End multi-header check

                cds_header = cds_header[0];
                # Conver the header to a string

                cds_seq = seqs[spec]['cds'][cds_header];
                # Lookup the CDS sequence

                pepout.write(">" + orth + "\n");
                pepout.write(pep_seq + "\n");
                # Write out the protein sequence

                cdsout.write(">" + spec.upper() + "-" + cds_header + "-" + pid + "\n");
                cdsout.write(cds_seq + "\n");
                # Write out the CDS sequence

                cur_num_written += 1;
                num_written += 1;
                # Update trackers
            ## End ortho cluster loop
        ## Close output files

        if cur_num_written != expected_seqs:
            incorrect_num_seqs.append(cluster_id + ": " + str(cur_num_written) + "/" + str(expected_seqs));
        # Check if the number of sequences written matches the number expected for the current cluster
    ## End ortholog loop

    CORE.PWS("# " + CORE.getDateTime() + " Done!", logfile);
    CORE.PWS("# " + CORE.getDateTime() + " Total sequences written: " + str(num_written), logfile);
    if incorrect_num_seqs:
        CORE.PWS("# " + CORE.getDateTime() + " " + str(len(incorrect_num_seqs)) + " clusters didn't have the correct number of sequences written:", logfile);
        for seq in incorrect_num_seqs:
            CORE.PWS("# " + CORE.getDateTime() + "\t" + seq, logfile);

    if multi_cds:
        CORE.PWS("# " + CORE.getDateTime() + " " + str(multi_cds) + " sequences had multiple headers. See above.", logfile);
## Close log file