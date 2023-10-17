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

save_fig = F

do_supp = T

save_supp_fig = T

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

trad_grampa = readGrampa(19, "traditional", 90, "hcsp", "Horseshoe crabs sister\nto arachnids")
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

legend_names = c("ASTRAL-Multi", "Ballesteros et al. 2022", "Horseshoe crabs sister\nto arachnids")
cols = corecol(numcol=3, pal="wilke")
names(cols) = legend_names
shapes = c(21, 22, 24)
names(shapes) = legend_names
# Colors for Fig. 2

multi_scores = ggplot(grampa_allo, aes(x=rank, y=score, shape=label, color=label, fill=label)) +
  geom_point(size=2, alpha=0.33, show.legend=F) +
  geom_point(data=grampa_st, aes(x=rank, y=score, shape=label), size=3, alpha=0.75, color="#000000", fill="#000000", show_guide=F) +
  geom_point(data=grampa_auto, aes(x=rank, y=score, shape=label, color=label, fill=label), size=5, alpha=0.5) +
  scale_x_continuous(limits=c(-10,max(grampa_scores$rank)+10)) +
  scale_color_manual(name="Species tree", values=cols) +
  scale_fill_manual(name="Species tree", values=cols) +
  scale_shape_manual(name="Species tree", values=shapes) +
  xlab("MUL-tree rank") +
  ylab("Duplications + losses") +
  bartheme() +
  theme(legend.position="bottom",
        legend.title=element_text(size=12),
        legend.text=element_text(size=10)) +
  guides(color=guide_legend(nrow=1, byrow=TRUE, label.hjust = 0.5))
print(multi_scores)
# Fig. 2

if(save_fig){
  figfile = here("manuscript", "figs", "fig2.png")
  cat(as.character(Sys.time()), " | Fig2: Saving figure:", figfile, "\n")
  ggsave(filename=figfile, multi_scores, width=7, height=6, units="in")
}

########################################

if(do_supp){
  multi_low_mul = multi_grampa$scores[2:4,]
  # Read the GRAMPA results and get the info for the lowest scoring MUL-tree (first row in scores df)
  
  multi_plot_list = list()
  
  for(i in 1:nrow(multi_low_mul)){
    multi_low_counts = multi_grampa$counts %>% filter(mul.tree == multi_low_mul[i,]$mul.tree)
    names(multi_low_counts)[2] = "mul.label"
    # Get the counts per branch for the lowest scoring MUL-tree
    
    multi_low = readTrees(multi_low_mul[i,]$labeled.tree, type="string")
    # Read the lowest scoring MUL-tree into an R phylo object
    ## Read the Astral-MULTI data
    
    multi_low$info = multi_low$info %>% 
      mutate(mul.label = label) %>%
      mutate(label = str_replace(label, "\\*", "")) %>%
      mutate(label = str_replace(label, "\\+", "")) %>%
      left_join(select(genome_data, label, S.name), by="label") %>%
      # Get the formatted species names for nice tip labels
      left_join(multi_low_counts, by="mul.label") %>%
      # Get the counts to match up to the branches in the tree df
      #mutate(h1 = ifelse(clade %in% h1_clades, "Y", "N")) %>%
      # Add a column for whether or not a branch is an H1 branch
      arrange(node)
    # Re-order by node for ggtree
    # Adjust Multi results
    
    # multi_low$info = multi_low$info %>%
    #   mutate(h.branch = ifelse(clade %in% h_clades, "Y", "N"))
    
    multi_low_p = ggtree(multi_low[["tree"]], size=0.75, ladderize=T, aes(color=!!multi_low[["info"]][["dups"]])) +
      scale_color_viridis(name='Duplications', option="C", limits=c(0, max_dups+100)) +
      xlim(0, 18) +
      geom_tiplab(aes(label=!!multi_low[["info"]][["S.name"]]), size=2, color="#333333", fontface=3) +
      #geom_label2(aes(subset=(multi_low$info$h1=="Y"), x=branch, label="H1"), size=2.5, fill=corecol(pal="trek", numcol=1), color="#ececec", nudge_x=-0.1, nudge_y=0.65) +
      ggtitle(paste0("MUL tree ", multi_low_mul[i,]$mul.tree, " (Score: ", multi_low_mul[i,]$score,", Rank ", i+1,")")) +
      theme(legend.position="bottom",
            legend.text=element_text(size=6),
            legend.title=element_text(size=8),
            plot.title = element_text(hjust=0.5, size=10),
            plot.margin=unit(c(1,1,1,0), "cm"))
    
    ## SET MARGINS, FIX FONT SIZES, FIX LEGEND FONT
    
    print(multi_low_p)
    
    leg = get_legend(multi_low_p)
    multi_low_p = multi_low_p + theme(legend.position="none")
    
    multi_plot_list[[i]] = multi_low_p
  }
  
  multi_plot_main = plot_grid(plotlist=multi_plot_list, ncol=3, labels=c("A", "B", "C"), label_size=14, align='vh', rel_widths=c(1,1,1))
  multi_plot = plot_grid(multi_plot_main, leg, nrow=2, rel_heights=c(1,0.1))
  
  if(save_supp_fig){
    figfile = here("manuscript", "figs", "supp", "figS1-base.png")
    cat(as.character(Sys.time()), " | FigS1: Saving figure:", figfile, "\n")
    ggsave(filename=figfile, multi_plot, width=8, height=4, units="in")
  }
  
  ####################
  
  bal_low_mul = bal_grampa$scores[2:4,]
  # Read the GRAMPA results and get the info for the lowest scoring MUL-tree (first row in scores df)
  
  bal_plot_list = list()
  
  for(i in 1:nrow(bal_low_mul)){
    bal_low_counts = bal_grampa$counts %>% filter(mul.tree == bal_low_mul[i,]$mul.tree)
    names(bal_low_counts)[2] = "mul.label"
    # Get the counts per branch for the lowest scoring MUL-tree
    
    bal_low = readTrees(bal_low_mul[i,]$labeled.tree, type="string")
    # Read the lowest scoring MUL-tree into an R phylo object
    ## Read the Astral-MULTI data
    
    bal_low$info = bal_low$info %>% 
      mutate(mul.label = label) %>%
      mutate(label = str_replace(label, "\\*", "")) %>%
      mutate(label = str_replace(label, "\\+", "")) %>%
      left_join(select(genome_data, label, S.name), by="label") %>%
      # Get the formatted species names for nice tip labels
      left_join(bal_low_counts, by="mul.label") %>%
      # Get the counts to match up to the branches in the tree df
      #mutate(h1 = ifelse(clade %in% h1_clades, "Y", "N")) %>%
      # Add a column for whether or not a branch is an H1 branch
      arrange(node)
    # Re-order by node for ggtree
    # Adjust Multi results
    
    bal_low$info = bal_low$info %>%
      mutate(h.branch = ifelse(clade %in% h_clades, "Y", "N"))
    
    bal_low_p = ggtree(bal_low[["tree"]], size=0.75, ladderize=T, aes(color=!!bal_low[["info"]][["dups"]])) +
      scale_color_viridis(name='Duplications', option="C", limits=c(0, max_dups+100)) +
      xlim(0, 18) +
      geom_tiplab(aes(label=!!bal_low[["info"]][["S.name"]]), size=2, color="#333333", fontface=3) +
      #geom_label2(aes(subset=(bal_low$info$h1=="Y"), x=branch, label="H1"), size=2.5, fill=corecol(pal="trek", numcol=1), color="#ececec", nudge_x=-0.1, nudge_y=0.65) +
      ggtitle(paste0("MUL tree ", bal_low_mul[i,]$mul.tree, " (Score: ", bal_low_mul[i,]$score,", Rank ", i+1,")")) +
      theme(legend.position="bottom",
            legend.text=element_text(size=6),
            legend.title=element_text(size=8),
            plot.title = element_text(hjust=0.5, size=10),
            plot.margin=unit(c(1,1,1,0), "cm"))
    
    ## SET MARGINS, FIX FONT SIZES, FIX LEGEND FONT
    
    print(bal_low_p)
    
    leg = get_legend(bal_low_p)
    bal_low_p = bal_low_p + theme(legend.position="none")
    
    bal_plot_list[[i]] = bal_low_p
  }
  
  bal_plot_main = plot_grid(plotlist=bal_plot_list, ncol=3, labels=c("A", "B", "C"), label_size=14, align='vh', rel_widths=c(1,1,1))
  bal_plot = plot_grid(bal_plot_main, leg, nrow=2, rel_heights=c(1,0.1))
  
  if(save_supp_fig){
    figfile = here("manuscript", "figs", "supp", "figS2-base.png")
    cat(as.character(Sys.time()), " | FigS2: Saving figure:", figfile, "\n")
    ggsave(filename=figfile, bal_plot, width=8, height=4, units="in")
  }
  
  ####################
  
  trad_low_mul = trad_grampa$scores[2:4,]
  # Read the GRAMPA results and get the info for the lowest scoring MUL-tree (first row in scores df)
  
  trad_plot_list = list()
  
  for(i in 1:nrow(trad_low_mul)){
    trad_low_counts = trad_grampa$counts %>% filter(mul.tree == trad_low_mul[i,]$mul.tree)
    names(trad_low_counts)[2] = "mul.label"
    # Get the counts per branch for the lowest scoring MUL-tree
    
    trad_low = readTrees(trad_low_mul[i,]$labeled.tree, type="string")
    # Read the lowest scoring MUL-tree into an R phylo object
    ## Read the Astral-MULTI data
    
    trad_low$info = trad_low$info %>% 
      mutate(mul.label = label) %>%
      mutate(label = str_replace(label, "\\*", "")) %>%
      mutate(label = str_replace(label, "\\+", "")) %>%
      left_join(select(genome_data, label, S.name), by="label") %>%
      # Get the formatted species names for nice tip labels
      left_join(trad_low_counts, by="mul.label") %>%
      # Get the counts to match up to the branches in the tree df
      #mutate(h1 = ifelse(clade %in% h1_clades, "Y", "N")) %>%
      # Add a column for whether or not a branch is an H1 branch
      arrange(node)
    # Re-order by node for ggtree
    # Adjust Multi results
    
    trad_low$info = trad_low$info %>%
      mutate(h.branch = ifelse(clade %in% h_clades, "Y", "N"))
    
    trad_low_p = ggtree(trad_low[["tree"]], size=0.75, ladderize=T, aes(color=!!trad_low[["info"]][["dups"]])) +
      scale_color_viridis(name='Duplications', option="C", limits=c(0, max_dups+100)) +
      xlim(0, 18) +
      geom_tiplab(aes(label=!!trad_low[["info"]][["S.name"]]), size=2, color="#333333", fontface=3) +
      #geom_label2(aes(subset=(trad_low$info$h1=="Y"), x=branch, label="H1"), size=2.5, fill=corecol(pal="trek", numcol=1), color="#ececec", nudge_x=-0.1, nudge_y=0.65) +
      ggtitle(paste0("MUL tree ", trad_low_mul[i,]$mul.tree, " (Score: ", trad_low_mul[i,]$score,", Rank ", i+1,")")) +
      theme(legend.position="bottom",
            legend.text=element_text(size=6),
            legend.title=element_text(size=8),
            plot.title = element_text(hjust=0.5, size=10),
            plot.margin=unit(c(1,1,1,0), "cm"))
    
    ## SET MARGINS, FIX FONT SIZES, FIX LEGEND FONT
    
    print(trad_low_p)
    
    leg = get_legend(trad_low_p)
    trad_low_p = trad_low_p + theme(legend.position="none")
    
    trad_plot_list[[i]] = trad_low_p
  }
  
  trad_plot_main = plot_grid(plotlist=trad_plot_list, ncol=3, labels=c("A", "B", "C"), label_size=14, align='vh', rel_widths=c(1,1,1))
  trad_plot = plot_grid(trad_plot_main, leg, nrow=2, rel_heights=c(1,0.1))
  
  if(save_supp_fig){
    figfile = here("manuscript", "figs", "supp", "figS3-base.png")
    cat(as.character(Sys.time()), " | FigS3: Saving figure:", figfile, "\n")
    ggsave(filename=figfile, trad_plot, width=8, height=4, units="in")
  }
}

####################



