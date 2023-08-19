############################################################
# For spider wgds
# Figure 1
# Gregg Thomas
############################################################

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

library(tidyverse)
library(viridis)
library(cowplot)
library(ggsignif)
library(here)
library("ggtree")
source(here("manuscript", "scripts", "lib", "design.r"))
source(here("manuscript", "scripts", "lib", "get_tree_info.r"))

############################################################

readTrees <- function(tree_input, type="file"){
  if(type=="file"){
    tree = read.tree(file=tree_input)
  }else if(type == "string"){
    tree = read.tree(text=tree_input)
  }
  tree_to_df_list = treeToDF(tree, add_avg_bl=TRUE)
  tree_info = tree_to_df_list[["info"]]
  tree = tree_to_df_list[["labeled.tree"]]  
  
  return(list("tree"=tree, "info"=tree_info))
}
## A function to read a Newick tree from a file and parse it with get_tree_info

####################

readGrampa <- function(spec, type, bs, search, label) {
  score_file = here("data", paste0(spec, "spec"), "grampa", paste0(type, "-bs", bs, "-", search, "-scores.txt"))
  count_file = here("data", paste0(spec, "spec"), "grampa", paste0(type, "-bs", bs, "-", search, "-dup-counts.txt"))
  
  score_data = read_tsv(score_file) %>% mutate(rank = row_number()) %>% mutate(label = label) %>% mutate(labeled.tree = paste0(labeled.tree, ";"))
  count_data = read_tsv(count_file)
  # Read the GRAMPA results
  
  names(count_data)[2] = "label"
  
  for(i in levels(as.factor(count_data$mul.tree))) {
    if(i != "0"){
      h_nodes = c()
      for(j in 1:nrow(count_data)){
        if(count_data[j,]$mul.tree == i){
          
          if(grepl("*", count_data[j,]$label, fixed=T)) {
            h_nodes = c(h_nodes, gsub("\\*", "", count_data[j,]$label))
          }
        }
      }
      count_data = count_data %>% mutate(label = ifelse(mul.tree == as.numeric(i) & label %in% h_nodes, paste0(label, "+"), label))
    }
  }
  # This block adds the + to the hybrid clade tips in the dup counts table because GRAMPA doesn't do that...
  
  return(list("scores"=score_data, "counts"=count_data))
}
## A function to read GRAMPA ooutput files

############################################################

save_fig = T

genome_file = here("data", "chelicerate_genomes-gwct.csv")

genome_data = read_csv(genome_file)
names(genome_data) = make.names(names(genome_data))
genome_data = genome_data %>% rename(label = Abbr) %>% filter(Dataset != "Exclude")

h1_clades = c("CROTU;LPOLY;TGIGA", 
              "ABRUE;CSCUL;LHESP;LRECL;NCLAV;PTEPI;SMIMO;TANTI", 
              "ABRUE;CROTU;CSCUL;LHESP;LPOLY;LRECL;NCLAV;PTEPI;SMIMO;TANTI;TGIGA")
# The H1 clades specified for the run

####################

multi_grampa = readGrampa(19, "astral-multi", 90, "hcsp", "ASTRAL-Multi")
multi_low_mul = multi_grampa$scores[1,]
# Read the GRAMPA results and get the info for the lowest scoring MUL-tree (first row in scores df)

multi_low_counts = multi_grampa$counts %>% filter(mul.tree == multi_low_mul$mul.tree)
# Get the counts per branch for the lowest scoring MUL-tree

multi_low = readTrees(multi_low_mul$labeled.tree, type="string")
# Read the lowest scoring MUL-tree into an R phylo object
## Read the Astral-MULTI data

#####

bal_grampa = readGrampa(19, "ballesteros", 90, "hcsp", "Ballesteros et al. 2022")
bal_low_mul = bal_grampa$scores[1,]
# Read the GRAMPA results and get the info for the lowest scoring MUL-tree (first row in scores df)

bal_low_counts = bal_grampa$counts %>% filter(mul.tree == bal_low_mul$mul.tree)
# Get the counts per branch for the lowest scoring MUL-tree

bal_low = readTrees(bal_low_mul$labeled.tree, type="string")
# Read the lowest scoring MUL-tree into an R phylo object
## Read the Ballesteros tree data

#####

trad_grampa = readGrampa(19, "traditional", 90, "hcsp", "Horseshoe crabs sister")
trad_low_mul = trad_grampa$scores[1,]
# Read the GRAMPA results and get the info for the lowest scoring MUL-tree (first row in scores df)

trad_low_counts = trad_grampa$counts %>% filter(mul.tree == trad_low_mul$mul.tree)
# Get the counts per branch for the lowest scoring MUL-tree

trad_low = readTrees(trad_low_mul$labeled.tree, type="string")
# Read the lowest scoring MUL-tree into an R phylo object
## Read the traditional tree data

#####

max_dups = max(c(multi_low_counts$dups, bal_low_counts$dups, trad_low_counts$dups))
# For the Fig. 1 legend

####################

multi_low$info = multi_low$info %>% 
  left_join(select(genome_data, label, S.name), by="label") %>%
  # Get the formatted species names for nice tip labels
  left_join(multi_low_counts, by="label") %>%
  # Get the counts to match up to the branches in the tree df
  mutate(h1 = ifelse(clade %in% h1_clades, "Y", "N")) %>%
  # Add a column for whether or not a branch is an H1 branch
  arrange(node)
  # Re-order by node for ggtree
# Adjust Multi results

multi_low_p = ggtree(multi_low$tree, size=0.75, ladderize=T, aes(color=multi_low$info$dups)) +
  scale_color_viridis(name='Duplications', option="C", limits=c(0, max_dups+100)) +
  xlim(0, 15) +
  geom_tiplab(aes(label=multi_low$info$S.name), size=3, color="#333333", fontface=3) +
  geom_label2(aes(subset=(multi_low$info$h1=="Y"), x=branch, label="H1"), size=2.5, fill=corecol(pal="trek", numcol=1), color="#ececec", nudge_x=-0.1, nudge_y=0.65) +
  theme(legend.position="right")
print(multi_low_p)

####################

bal_low$info = bal_low$info %>% 
  left_join(select(genome_data, label, S.name), by="label") %>%
  # Get the formatted species names for nice tip labels
  left_join(bal_low_counts, by="label") %>%
  # Get the counts to match up to the branches in the tree df
  mutate(h1 = ifelse(clade %in% h1_clades, "Y", "N")) %>%
  # Add a column for whether or not a branch is an H1 branch
  arrange(node)
# Re-order by node for ggtree

bal_low_p = ggtree(bal_low$tree, size=0.75, ladderize=T, aes(color=bal_low$info$dups)) +
  scale_color_viridis(name='Duplications', option="C", limits=c(0, max_dups+100)) +
  xlim(0, 15) +
  geom_tiplab(aes(label=bal_low$info$S.name), size=3, color="#333333", fontface=3) +
  geom_label2(aes(subset=(bal_low$info$h1=="Y"), x=branch, label="H1"), size=2.5, fill=corecol(pal="trek", numcol=1), color="#ececec", nudge_x=-0.3, nudge_y=0.65) +
  theme(legend.position="none")
print(bal_low_p)

####################

trad_low$info = trad_low$info %>% 
  left_join(select(genome_data, label, S.name), by="label") %>%
  # Get the formatted species names for nice tip labels
  left_join(trad_low_counts, by="label") %>%
  # Get the counts to match up to the branches in the tree df
  mutate(h1 = ifelse(clade %in% h1_clades, "Y", "N")) %>%
  # Add a column for whether or not a branch is an H1 branch
  arrange(node)
# Re-order by node for ggtree

trad_low_p = ggtree(trad_low$tree, size=0.75, ladderize=T, aes(color=trad_low$info$dups)) +
  scale_color_viridis(name='Duplications', option="C", limits=c(0, max_dups+100)) +
  xlim(0, 15) +
  geom_tiplab(aes(label=trad_low$info$S.name), size=3, color="#333333", fontface=3) +
  geom_label2(aes(subset=(trad_low$info$h1=="Y"), x=branch, label="H1"), size=2.5, fill=corecol(pal="trek", numcol=1), color="#ececec", nudge_x=-0.3, nudge_y=0.65) +
  theme(legend.position="none")
print(trad_low_p)

####################

leg = get_legend(multi_low_p)
top = plot_grid(NULL, multi_low_p + theme(legend.position="none"), leg, ncol=3, labels=c("", "A", ""), label_size=14, rel_widths=c(0.1, 0.6, 0.3))
bot = plot_grid(bal_low_p, NULL, trad_low_p, NULL, ncol=4, labels=c("B", "", "C", ""), label_size=14, rel_widths=c(0.4, 0.1, 0.4, 0.1))
main = plot_grid(top, bot, nrow=2)
#fig = plot_grid(main, leg, nrow=2, rel_heights=c(1,0.1))

if(save_fig){
  figfile = here("manuscript", "figs", "fig1-base.pdf")
  cat(as.character(Sys.time()), " | Fig1: Saving figure:", figfile, "\n")
  ggsave(filename=figfile, main, width=7.5, height=7.5, units="in")
}

####################

grampa_scores = rbind(multi_grampa$scores, bal_grampa$scores, trad_grampa$scores)
grampa_allo = grampa_scores %>% filter(h1.node != h2.node & mul.tree != 0)
grampa_st = grampa_scores %>% filter(mul.tree == 0)
grampa_auto = grampa_scores %>% filter(h1.node == h2.node & mul.tree != 0)
# Select data For Fig. 2

cols = corecol(numcol=3, pal="wilke")
names(cols) = c("ASTRAL-Multi", "Ballesteros et al. 2022", "Horseshoe crabs sister")
# Colors for Fig. 2

multi_scores = ggplot(grampa_allo, aes(x=rank, y=score, color=label)) +
  geom_point(size=2, alpha=0.33, show.legend=F) +
  geom_point(data=grampa_st, aes(x=rank, y=score), size=3, alpha=0.75, color="#333333", fill="#999999") +
  geom_point(data=grampa_auto, aes(x=rank, y=score, color=label), size=5, alpha=0.5) +
  scale_x_continuous(limits=c(-10,max(grampa_scores$rank)+10)) +
  scale_color_manual(name="Species tree", values=cols) +
  xlab("MUL-tree rank") +
  ylab("Duplications + losses") +
  bartheme() +
  theme(legend.position="right",
        legend.title=element_text(size=12),
        legend.text=element_text(size=10)) +
  guides(color=guide_legend(nrow=3, byrow=TRUE))
print(multi_scores)
# Fig. 2

if(save_fig){
  figfile = here("manuscript", "figs", "fig2.png")
  cat(as.character(Sys.time()), " | Fig2: Saving figure:", figfile, "\n")
  ggsave(filename=figfile, multi_scores, width=8, height=6, units="in")
}

####################

