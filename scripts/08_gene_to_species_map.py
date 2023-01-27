#!/usr/bin/python
############################################################
# For spider genomes, 01.2022
# Creates a gene to species map file for ASTRAL-Pro
############################################################

import sys, os, argparse
import core as CORE
import treeparse as TREE
from collections import defaultdict

############################################################

dataset = "16spec";
# The dataset to run on, 16spec of 19spec

infilename = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/" + dataset + "/cds-iqtree/loci.treefile";
# The input file name: a file with one gene tree per line

pro_outdir = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/" + dataset + "/astral-pro-tree/";
if not os.path.isdir(pro_outdir):
    os.makedirs(pro_outdir);
pro_outfilename = os.path.join(pro_outdir, "gene-to-spec-map.txt");
# Output locations for the ASTRAL-PRO map

multi_outdir = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/" + dataset + "/astral-multi-tree/";
if not os.path.isdir(multi_outdir):
    os.makedirs(multi_outdir);
multi_outfilename = os.path.join(multi_outdir, "gene-to-spec-map-single-line.txt");
# Output locations for the ASTRAL-MULTI map

specs = defaultdict(list);

with open(pro_outfilename, "w") as pro_outfile, open(multi_outfilename, "w") as multi_outfile:
    for line in open(infilename):
        tinfo, tree, root = TREE.treeParse(line);
        # Read the tree

        for node in tinfo:
            if tinfo[node][2] != 'tip':
                continue;
            # Skip internal nodes

            node_list = node.split("_");
            if len(node_list) != 2:
                print(line);
                print(node);
                sys.exit();
            # Split the tip label and exit if it doesn't work (shouldn't happen)

            gene = node_list[0];
            spec = node_list[1];
            # Parse the gene and the species labels out of the current tip list

            specs[spec].append(node);
            # Add the current label to the full list of labels for ASTRAL-MULTI output

            pro_outfile.write(node + " " + spec + "\n");
            # Write the map for the current tip to the ASTRAL-PRO output

        ## End node loop
    ## End tree loop

    for spec in specs:
        genes = ",".join(specs[spec]);
        multi_outfile.write(spec + ": " + genes + "\n");
    ## End spec loop for ASTRAL-MULTI output
## Close output files
