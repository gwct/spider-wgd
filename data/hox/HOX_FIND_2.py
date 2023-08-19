import numpy as np
import sys, statistics, random, itertools, csv, os
from ete3 import Tree

#Open hoxgene file
file = sys.argv[1]
f = open(f"{file}",'r').read()
f = f.split("\n")

#Species to exclude
skippers = ["DSYLV","LHESP","LRECL","BMORI","TTRID"]

#For each gene family...

missing = []
syn = []
non_syn = []
summary = {}
for i in f:
    #### parse out gene names from file ####
    i = str(i)
    i = i.split(",")
    for g in i:
        if "_" in g:
            g = g.split(":")[0]
            if "(" in g:
                g = g.split("(")[-1]
            g = g.rsplit("_",1)
            check = g[1] # get species it belongs to
            if check not in skippers:
               # edit gene names to match annotation (some minor symbol changes) 
                g = g[0]
                g = g.replace("XP-","XP_")
                g = g.replace("Cr-","Cr_")
                g = g.replace("-PA","")
                g = g.replace("-TA","")
                g = g.replace("FBpp","FBtr")
                g = g.replace(".1","")            
                g = g.replace("Trichonephila-antipodiana-","antipodiana_")
    ####
            #Find the gene in MCScanX dup classifier file
                pp = os.popen(f'grep {g} {check}.gene_type').read()
                if pp == "":
                    missing.append(check)
                else:
                    pp = pp.split("\t")[1].split("\n")[0]
                    if check not in summary:
                        summary[check] = [pp]
                    else:
                        summary[check].append(pp)

# Summarize the results
for i in summary:
    print(f"{[i][0]}\t{summary[i].count('0')}\t{summary[i].count('1')}\t{summary[i].count('2')}\t{summary[i].count('3')}\t{summary[i].count('4')}\t{check.count([i][0])}")


#missing genes?
print(missing)              
