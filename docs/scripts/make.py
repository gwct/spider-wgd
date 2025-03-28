import sys, os, argparse

print()
print("###### Build site pages ######");
print("PYTHON VERSION: " + ".".join(map(str, sys.version_info[:3])))
print("# Script call: " + " ".join(sys.argv) + "\n----------");

parser = argparse.ArgumentParser(description="Gets stats from a bunch of abyss assemblies.");
parser.add_argument("--all", dest="all", help="Build all pages", action="store_true", default=False);
parser.add_argument("--index", dest="index", help="Without --all: build index.html. With --all: exlude index.html", action="store_true", default=False);
parser.add_argument("--annotations", dest="annotations", help="Without --all: build annotations.html. With --all: exlude annotations.html", action="store_true", default=False);
parser.add_argument("--orthologs", dest="orthologs", help="Without --all: build orthologs.html. With --all: exlude orthologs.html", action="store_true", default=False);
parser.add_argument("--alignments", dest="alignments", help="Without --all: build alignments.html. With --all: exlude alignments.html", action="store_true", default=False);
parser.add_argument("--trees", dest="trees", help="Without --all: build trees.html. With --all: exlude trees.html", action="store_true", default=False);
parser.add_argument("--grampa", dest="grampa", help="Without --all: build grampa.html. With --all: exlude grampa.html", action="store_true", default=False);
parser.add_argument("--hox", dest="hox", help="Without --all: build hox.html. With --all: exlude hox.html", action="store_true", default=False);
# parser.add_argument("--links", dest="links", help="Without --all: build links.html. With --all: exlude links.html", action="store_true", default=False);
args = parser.parse_args();
# Input options.

#cwd = os.getcwd();
os.chdir("generators");

pages = {
    'index' : args.index,
    'annotations' : args.annotations,
    'orthologs' : args.orthologs,
    'alignments' : args.alignments,
    'trees' : args.trees,
    'grampa' : args.grampa,
    'hox' : args.hox,
    # 'links' : args.links
}

if args.all:
    pages = { page : False if pages[page] == True else True for page in pages };

if pages['index']:
    os.system("python index_generator.py");

if pages['annotations']:
    os.system("Rscript annotations_generator.r");

if pages['orthologs']:
    os.system("Rscript orthologs_generator.r");

if pages['alignments']:
    os.system("Rscript alignments_generator.r");

if pages['trees']:
    os.system("Rscript trees_generator.r");

if pages['grampa']:
    os.system("Rscript grampa_pro_generator.r");
    os.system("Rscript grampa_multi_generator.r");

if pages['hox']:
    os.system("Rscript hox_generator.r");

# if pages['links']:
#     os.system("python links_generator.py");
    
print("----------\nDone!");


