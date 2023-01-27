#!/usr/bin/python
############################################################
# For spider genomes, 01.2022
# Roots gene trees
############################################################

## NOTE: After this script, generate species trees before continuing with run_grampa.sh. See workflow-notes.txt steps 14+15

############################################################

import sys, os, argparse, subprocess
import core as CORE
import treeparse as TREE
from collections import defaultdict
#from Bio.Seq import Seq

############################################################

dataset = "19spec";
# The current dataset, 16spec of 19spec

indir = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/" + dataset + "/cds-iqtree/loci/";
# The input directory with the gene trees in individual folders

scdir = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/" + dataset + "/cds-iqtree/loci-single-copy/";
if not os.path.isdir(scdir):
    os.makedirs(scdir);
# The directory to store single-copy gene trees

num_rooted, num_skipped = 0, 0;
cant_root, no_outgroup = 0, 0;
outgroup_counts = defaultdict(int);
# Initialize some counts

#####
if dataset == "16spec":
    num_spec = 16;
elif dataset == "19spec":
    num_spec = 19;
else:
    num_spec = NA;
# Set the number of species in the dataset
#####

single_copy = [];
single_copy_rooted = [];
missing_gt = [];
# Initialize some lists to print at the end

for orthogroup in os.listdir(indir):
    treefile = os.path.join(indir, orthogroup, orthogroup + ".treefile");
    if not os.path.isfile(treefile):
        missing_gt.append(orthogroup);
        continue;
    # Get the tree file for the current orthogroup and skip if it isn't found

    outfilename = os.path.join(indir, orthogroup, orthogroup + ".rooted.treefile");
    # Set the output file name to be the same as the input, but with the rooted suffix

    rooted = False;
    # Track whether the current tree has been rooted

    tinfo, tree, root = TREE.treeParse(open(treefile, "r").read());
    outgroups, tip_spec = [], [];
    # Read the current gene tree and initialize some lists

    for node in tinfo:
        if tinfo[node][2] != 'tip':
            continue;
        # Look only at tips for the outgroup

        if "_DMELA" in node or "_BMORI" in node:
            outgroups.append(node);
        # If one of the two outgroups is found, note it here

        tip_spec.append(node.split("_")[-1]);
        # Add all tips to a list of tips without their gene id
    ## End node loop to find outgorups

    if outgroups:
        #print("Rooting " + orthogroup);
        nw_cmd = "nw_reroot -l " + treefile + " " + " ".join(outgroups)# + " > " + outfile;
        #print(nw_cmd);
        cmd_result = subprocess.run(nw_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE);
        cmd_stdout = cmd_result.stdout.decode();
        cmd_stderr = cmd_result.stderr.decode();
        # Run nw_reroot on the current gene tree if any outgroups are contained in it

        if "LCA is still tree's root - be sure to include ALL outgroup leaves with -l" in cmd_stderr:
            cant_root += 1;
            continue;
        elif cmd_stderr:
            print("CMD:   ", nw_cmd);
            print("STDOUT:", cmd_stdout);
            print("STDERR:", cmd_stderr);
            sys.exit();
        ## Check for errors when rooting
        else:
            with open(outfilename, "w") as outfile:
                outfile.write(cmd_stdout.strip());
            # Write the rooted gene tree to the output file

            og_specs = [ og.split("_")[-1] for og in outgroups ];
            og_specs = tuple(sorted(set(og_specs)));
            outgroup_counts[og_specs] += 1;
            # Note which outgroups were found in this gene

            num_rooted += 1;
            rooted = True;
            # Bookkeeping
        ## End tree writing block

        if len(set(tip_spec)) == num_spec and len(tip_spec) == num_spec:
            single_copy.append(orthogroup);
            # If this gene contains one sequence from each species, mark it as single copy and write it to a file

            # sc_tree = tree;
            # for node in tinfo:
            #     if tinfo[node][2] == 'tip':
            #         spec = node.split("_")[-1];
            #         sc_tree = sc_tree.replace(node, spec);
            #     else:
            #         sc_tree = sc_tree.replace(node, "");
            # # For every tip in the tree, replace the gene_spec label with just spec for ASTRAL

            # scfilename = os.path.join(scdir, orthogroup + ".treefile");
            # with open(scfilename, "w") as scfile:
            #     scfile.write(sc_tree);
            # # Write the single copy gene tree to a file

            if rooted:
                single_copy_rooted.append(orthogroup);
                # Add the rooted, single-copy tree to a list

                sc_tinfo, sc_tree, sc_root = TREE.treeParse(cmd_stdout.strip());
                # Parse the rooted tree

                for node in sc_tinfo:
                    if sc_tinfo[node][2] == 'tip':
                        spec = node.split("_")[-1];
                        sc_tree = sc_tree.replace(node, spec);
                    else:
                        sc_tree = sc_tree.replace(node, "");
                # For every tip in the tree, replace the gene_spec label with just spec for ASTRAL
            
                scfilename = os.path.join(scdir, orthogroup + ".rooted.treefile");
                with open(scfilename, "w") as scfile:
                    scfile.write(sc_tree);
                # Write the single copy gene tree to a file
            ## Do the same thing for the ROOTED single copy tree.
        ## End single copy block
    ## End rooting block
    else:
        no_outgroup += 1;
    ## Increment if no outgroup is found
## End gene tree loop

####################

print("Trees rooted:                   ", num_rooted);
print("Trees can't root:               ", cant_root);
print("Trees with no outgroup:         ", no_outgroup);
for og in outgroup_counts:
    print("Trees with ", og, " outgroup: ", outgroup_counts[og]);
print("Single copy gene trees:         ", len(single_copy));
print("Single copy gene trees rooted:  ", len(single_copy_rooted));
# Print some summary info
####################