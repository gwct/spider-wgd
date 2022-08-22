#!/usr/bin/python
############################################################
# For spider genomes, 01.2022
# Roots gene trees
############################################################

import sys, os, argparse, subprocess
import core as CORE
import treeparse as TREE
from collections import defaultdict
#from Bio.Seq import Seq

############################################################

indir = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/pep-iqtree/loci/";
num_rooted, num_skipped = 0, 0;
cant_root, no_outgroup = 0, 0;
outgroup_counts = defaultdict(int);

num_spec = 16;
single_copy = [];
single_copy_rooted = [];
missing_gt = [];

for orthogroup in os.listdir(indir):
    treefile = os.path.join(indir, orthogroup, orthogroup + ".treefile");
    if not os.path.isfile(treefile):
        missing_gt.append(orthogroup);
        continue;
    outfilename = os.path.join(indir, orthogroup, orthogroup + ".rooted.treefile");

    rooted = False;

    tinfo, tree, root = TREE.treeParse(open(treefile, "r").read());
    outgroups, tip_spec = [], [];
    for node in tinfo:
        if tinfo[node][2] != 'tip':
            continue;

        if "_DMELA" in node or "_BMORI" in node:
            outgroups.append(node);

        tip_spec.append(node.split("_")[-1]);

    if outgroups:
        #print("Rooting " + orthogroup);
        nw_cmd = "nw_reroot -l " + treefile + " " + " ".join(outgroups)# + " > " + outfile;
        #print(nw_cmd);
        #os.system(nw_cmd);
        cmd_result = subprocess.run(nw_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE);
        cmd_stdout = cmd_result.stdout.decode();
        cmd_stderr = cmd_result.stderr.decode();

        if "LCA is still tree's root - be sure to include ALL outgroup leaves with -l" in cmd_stderr:
            cant_root += 1;
            continue;
        elif cmd_stderr:
            print("CMD:   ", nw_cmd);
            print("STDOUT:", cmd_stdout);
            print("STDERR:", cmd_stderr);
            sys.exit();
        else:
            with open(outfilename, "w") as outfile:
                outfile.write(cmd_stdout.strip());
            og_specs = [ og.split("_")[-1] for og in outgroups ];

            og_specs = tuple(sorted(set(og_specs)));
            outgroup_counts[og_specs] += 1;
            num_rooted += 1;
            rooted = True;

        if len(set(tip_spec)) == num_spec and len(tip_spec) == num_spec:
            single_copy.append(orthogroup);
            scfilename = os.path.join("/n/holylfs05/LABS/informatics/Users/gthomas/spiders/tree/pep-iqtree/astral-single-copy-tree/loci-single-copy/", orthogroup + ".treefile");
            spec_tree = tree;
            for node in tinfo:
                if tinfo[node][2] == 'tip':
                    spec = node.split("_")[-1];
                    spec_tree = spec_tree.replace(node, spec);
                else:
                    spec_tree = spec_tree.replace(node, "");

            with open(scfilename, "w") as sc:
                sc.write(spec_tree +"\n");

            # cp_cmd = "cp " + treefile + " " + scfilename;
            # print(cp_cmd);
            # os.system(cp_cmd);
            if rooted:
                single_copy_rooted.append(orthogroup);
    else:
        no_outgroup += 1;

print("Trees rooted:                   ", num_rooted);
print("Trees can't root:               ", cant_root);
print("Trees with no outgroup:         ", no_outgroup);
for og in outgroup_counts:
    print("Trees with ", og, " outgroup: ", outgroup_counts[og]);
print("Single copy gene trees:         ", len(single_copy));
print("Single copy gene trees rooted:  ", len(single_copy_rooted));

