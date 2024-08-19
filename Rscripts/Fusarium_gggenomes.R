# This will be a gggenomes script for identifying the integration region for Fusarium oxysporum
# I call it Foxy here as an abbreviation but it is an attractive fungus

library(tidyverse)
library(gggenomes)
library(patchwork)
library(ggplot2)
library(ggfittext)

s0 <- tibble(
  seq_id = c("JAKELM010000019.1", "JACWCA010001204.1", "JAOQAX010000044.1", "JAVENW010000013.1"),
  length = c(4726,4726,4726,6579) 
)
s0

g0 <- read.table("Foxy_int_features.txt", header = TRUE)
g0

p2 <- gggenomes(seqs = s0, genes = g0)
p2
p2 + 
  geom_seq() +         # draw contig/chromosome lines
  geom_seq_label() + 
  geom_gene(position = "strand")


paf <- read.table("Foxy_int.paf.txt", header = TRUE)
paf
p3 <- gggenomes(seqs = s0, genes = g0, links=paf)
p3 +
  geom_seq() + # draw contig/chromosome lines
  geom_seq_label() +
  geom_gene(position = "strand") +
  geom_link()

p3

p4 <- flip_by_links(p3, link_track = 1, min_coverage = 0.1)

p5 <- p3 %>% flip(4)

global <- p5 +
  geom_seq() + # draw contig/chromosome lines
  #geom_seq_label() +
  geom_bin_label() +
  geom_gene(position = "strand") +
  geom_link() + geom_gene(aes(fill=Organism, color = Organism),position = "strand") +
  geom_gene_tag(aes(label = Function)) +
  scale_fill_manual(values = c("gray", "#F8766D")) +
  scale_color_manual(values = c("gray","#F8766D")) +
  theme(legend.position="top", axis.text.y = element_blank()) + theme(axis.title.y=element_blank())
global

