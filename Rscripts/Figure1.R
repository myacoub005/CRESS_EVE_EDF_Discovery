library(tidyverse)
library(patchwork)
library(ggplot2)
library(gggenes)
library(ggfittext)
library(ggtree)
library(dplyr)
library(rvcheck)
library(treeio)
library(phytools)
library(ggstance)
library(ggtreeExtra)
library(RColorBrewer)
library(ggnewscale)
library(ggrepel)
library(ggstar)
library(gridExtra)

## ggtree script for visualizing barplot and basic phylo ##

tree <- read.tree("1KFG-2020_v3.1633_taxa.fungi_odb10.ft_lg_long.tre")
tree <- read.tree("Fungal_phyla_tree2.nwk")
tree

tip_metadata <- read.table("Percent_EVE_ncbi.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)
tip_metadata

tipnames <- tree$tip.label
tipnames
to_drop <- setdiff(tree$tip.label, tip_metadata$Phylum)
to_drop
straintree <- drop.tip(tree, to_drop)
tipnames <- straintree$tip.label
tipnames

p1 <- ggtree(straintree, layout="rectangular", branch.length = 'none') +
  geom_text2(aes(subset=!isTip, label=node))

p1 <- ggtree(straintree, layout="rectangular", branch.length = 'none')
p1

plot(straintree)
nodelabels()
title("ggtree::reroot")

# For aesthetics we're going to flip the clades for Dikarya and Mucoro #

p2 <- flip(p1, 17,16)
p2

d <- ggimage::phylopic_uid(straintree$tip.label)
d$name
d
p <- p2 %<+% d + 
  geom_tiplab(aes(image=uid), geom="phylopic", offset=.5, size=c(0.1,.02,.05,.05,.1,.1,.05,0.1,0.05,0.05)) +
  geom_tiplab(aes(label=label), offset = 1.5)
p



df <- data.frame(id = rep(straintree$tip.label, each=2),
                 value = abs(rnorm(60, mean=100, sd=50)),
                 category = rep(LETTERS[1:2], 30))



barplot2 <- facet_plot(p, panel = 'Percent EVE +', data = tip_metadata, 
                       geom = geom_barh,
                       mapping = aes(x =`Percent EVE+`, fill=as.factor(Status)), 
                       stat='identity') + scale_fill_manual(values =c('lightblue','#4682B4')) + theme_tree2()
barplot2


Fig1a <- barplot2 + 
  xlim_tree(10)  
Fig1a

# Visualize violin plots for Figure 1B #

boxp <- read.table("Hits_per_ncbi_genome.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)
boxp


Fig1b <- ggplot(boxp, aes(x=Gene, y=Count, fill=Gene)) + 
  geom_violin() + scale_fill_manual(values = c("springgreen3","purple1")) + theme_bw() + geom_point() +
  ylab("EVE Counts per Genome") +
  theme(axis.text.x=element_text(size=12, face="bold"), legend.position = 'none') + facet_wrap(~ factor(Phylum, c("Microsporidiomycota","Neocallimastigomycota","Chytridiomycota","Zoopagomycota","Glomeromycota","Mucoromycota","Ascomycota","Basidiomycota")), ncol = 4, scales = "free")
Fig1b

### Let's look at the overall distribution in a pie Chart Figure 1C ##
FG <- read.table("Viral_Fam_Distribution.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)

df <- as.data.frame(FG)
df

Fig1C <- ggplot(df, aes(x="",y=Percent,fill=Classification)) + 
  geom_col(width=1, color=1) + geom_label_repel(data = df, aes(y=pos,label=Count), nudge_x = .8, show.legend = FALSE) +
  coord_polar(theta='y')+
  theme(axis.ticks=element_blank(), axis.title=element_blank(), 
        axis.text.y = element_blank(), panel.grid  = element_blank(),
        axis.text.x = element_blank())+
  #axis.text.x = element_text(size=15,hjust=0))+ 
  scale_fill_manual(values = c("#A6CEE3","#f38400","#f3c300","#875692","#be0032","#c2b280","#008856","#8db600","#f99379","tan4","#0067a5","#5EF1F2","#F0A3FF")) + theme_bw()
Fig1C<-Fig1C+facet_wrap(~ factor(Phylum, c("Microsporidiomycota","Neocallimastigomycota","Chytridiomycota","Zoopagomycota","Glomeromycota","Mucoromycota","Ascomycota","Basidiomycota")), ncol = 4) +
  theme(legend.position = "bottom",axis.ticks=element_blank(), axis.text.x = element_blank(),panel.grid  = element_blank(), axis.title = element_blank())
Fig1C

library(cowplot)

dev.new()

pdf(file = "EVE_Figure1.pdf",   # The directory you want to save the file in
    width = 20, # The width of the plot in inches
    height = 12) # The height of the plot in inches


Figure1 <- plot_grid(
  Fig1a, Fig1b, Fig1C,
  labels = "AUTO", ncol = 1
)

Figure1
plot_grid(
  Fig1a, Fig1b, Fig1C,
  labels = "AUTO", ncol = 1
)

dev.off()

Fig1a


# Let's try to arrange the plots for final presentation #

bottom_row <- plot_grid(Fig1b, Fig1C, labels = c('B', 'C'), label_size = 15, ncol=2)
bottom_row

plot_grid(
  Fig1a, bottom_row,
  labels = "AUTO", ncol = 1, rel_widths = c(1.25,2)
)

