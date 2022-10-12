#!/usr/bin/python
############################################################
# For spider genomes, 01.2022
# Creates a gene to species map file for ASTRAL-Pro
############################################################

import sys, os, argparse
import core as CORE
import treeparse as TREE
from collections import defaultdict
#from Bio.Seq import Seq

############################################################

treedir = "cds-iqtree"
mode = "pro";
# pro or multi


infilename = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/" + treedir + "/loci.treefile";

if mode == "pro":
    outfilename = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/" + treedir + "/astral-pro-tree/gene-to-spec-map.txt";
elif mode == "multi":
    outfilename = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/" + treedir + "/astral-multi-tree/gene-to-spec-map-single-line.txt";
else:
    sys.exit("mode?");

specs = defaultdict(list);

with open(outfilename, "w") as outfile:
    for line in open(infilename):
        tinfo, tree, root = TREE.treeParse(line);
        for node in tinfo:
            if tinfo[node][2] != 'tip':
                continue;

            node_list = node.split("_");
            if len(node_list) != 2:
                print(line);
                print(node);
                sys.exit();

            #spec = node.split("_")[1];

            gene = node_list[0];
            spec = node_list[1];

            specs[spec].append(node);

            if mode == "pro":
                outfile.write(node + " " + spec + "\n");


    if mode == "multi":
        for spec in specs:
            genes = ",".join(specs[spec]);
            outfile.write(spec + ": " + genes + "\n");
