############################################################
# For phyloacc site, 08.21
# This generates the file "index.html"
############################################################

import sys, os
sys.path.append(os.path.abspath('../lib/'))
import read_chunks as RC

######################
# HTML template
######################

html_template = """
<!doctype html>
    {head}

<body>
	<div class="row" id="top_grid">
		<div class="col-2-24" id="margin"></div>
		<div class="col-20-24" id="main_header">Spider WGD</div>
		<div class="col-2-24" id="margin"></div>
	</div>

	{nav}

	<div class="sep_div"></div>

	<div class="row">
		<div class="col-2-24" id="margin"></div>
		<div class="col-20-24" id="main_col">
			<ul>
				<li><h3><a href="https://github.com/gwct/spider-wgd">github repo</a></h3></li>
				<li><h3><a href="annotations.html">Annotation stats</a></h3></li>
				<li><h3><a href="orthologs.html">Ortholog clustering summary</a></h3></li>
				<li><h3><a href="alignments.html">Alignment summary stats</a></h3></li>
				<li><h3><a href="trees.html">Species trees</a></h3></li>
				<li><h3><a href="grampa_results.html">GRAMPA results</a></h3></li>
			</ul>
		</div>
        <div class="col-2-24" id="margin"></div>
	</div>

	<div class="sep_div"></div>
	<div class="sep_div"></div>
	<div class="sep_div"></div>
	<div class="sep_div"></div>
	<div class="sep_div"></div>
	<div class="sep_div"></div>
	<div class="sep_div"></div>
	<div class="sep_div"></div>
	<div class="sep_div"></div>

    {footer}
</body>
"""

######################
# Main block
######################
pagefile = "index.html";
print("Generating " + pagefile + "...");
title = "Spider WGD"

head = RC.readHead(title, pagefile);
nav = RC.readNav(pagefile);
footer = RC.readFooter();

outfilename = "../../" + pagefile;

with open(outfilename, "w") as outfile:
    outfile.write(html_template.format(head=head, nav=nav, footer=footer));