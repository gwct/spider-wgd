#############################################################################
# Summarizes a FastOrtho run
# Gregg Thomas
#############################################################################

import sys
import os
import datetime

#############################################################################

def getDateTime():
# Function to get the date and time in a certain format.
    return datetime.datetime.now().strftime("%m.%d.%Y | %H:%M:%S");

####################

def PWS(o_line, o_stream=False, std_stream=True, newline=True):
# Function to print a string AND write it to the file.
    if std_stream:
        print(o_line);
    if o_stream:
        o_stream.write(o_line);
        if newline:
            o_stream.write("\n");

####################

def spacedOut(string, totlen, sep=" "):
# Properly adds spaces to the end of a string to make it a given length
    spaces = sep * (totlen - len(string));
    return string + spaces;

####################

def runTime(msg=False, writeout=False, printout=True):
# Function to print out some info at the start of the script
    if msg:
        if not msg.startswith("#"):
            msg = "# " + msg;
        PWS(msg, writeout, printout);

    PWS("# PYTHON VERSION: " + ".".join(map(str, sys.version_info[:3])), writeout, printout)
    PWS("# Script call:    " + " ".join(sys.argv), writeout, printout)
    PWS("# Runtime:        " + datetime.datetime.now().strftime("%m/%d/%Y %H:%M:%S"), writeout, printout);
    PWS("# ----------------", writeout, printout);

#############################################################################

inflation_params = ["2", "3", "4", "5", "6"];
# The various inflation params used when running fastortho

spec_str = "18spec"
# The dataset to parse

fastortho_dir = "/n/holylfs05/LABS/informatics/Users/gthomas/spiders/fastortho/" + spec_str + "/"
outfilename = "../data/" + spec_str + "/fastortho-summary-" + spec_str + ".csv";
# I/O options

headers = ["inflation", "genes", "taxa"];
# Columns for the output

pad = 20;
with open(outfilename, "w") as outfile:
    runTime("# Summarize FastOrtho", outfile);
    PWS(spacedOut("# Ortholog directory:", pad) + fastortho_dir, outfile);
    PWS(spacedOut("# Output file:", pad) + outfilename, outfile);
    PWS("# ----------------", outfile);
    # Write some log info to the output file

    outfile.write(",".join(headers) + "\n");
    # Write the headers to the output file

    for inflation in inflation_params:
        ortholog_file = os.path.join(fastortho_dir, "chelicerate-fastortho-i" + inflation + ".out");
        # Get the filename for the current inflation parameter

        for line in open(ortholog_file):
            line = line.strip().split("\t");
            line = line[0].split(" (");
            counts = line[1];
            counts = counts.replace(" genes", "").replace(" taxa):", "");
            # Parse every line in the file

            outline = [inflation, counts];
            outfile.write(",".join(outline) + "\n");
            # Write the summary to the output file

        ## End line loop
    ## End inflation param loop

#############################################################################