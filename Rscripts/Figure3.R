## The purpose of this script is to examine correlations between EVE counts and genome size ##

library(tidyverse)
library(ggpubr)
library(RColorBrewer)

SIZE <- read.table("CRESS_POS_GenomeSize.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)
COUNT <- read.table("EVE_Counts_per_genome.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)
SIZE

total <- inner_join(SIZE, COUNT, by="ACC")
dim(total)
write.table(total, file = "EVE_GENOME_SIZE.csv", append = "FALSE", sep = ",")

total <- read.table("EVE_GENOME_SIZE.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)

total

# let's try log-transforming the x-axis

total_log <- total %>%
  mutate(log_bp = log10(bp))


Figure3 <- ggscatter(total, x = "Mbp", color="Phylum", y = "EVE_Count", shape = "EVE_Status",
                     conf.int = TRUE, 
                     cor.coef = TRUE, cor.method = "pearson",
                     xlab = "Genome Size (Mbp)", ylab = "EVE Count") +  scale_color_brewer(palette = "Set1")
Figure3


display.brewer.pal(8, "Set1")

Figure3 <- ggscatter(total, x = "Mbp", color="Phylum", y = "EVE_Count", shape = "EVE_Status",
                     add = "reg.line",conf.int = TRUE, 
                     cor.coef = TRUE, cor.method = "pearson",
                     xlab = "Genome Size (Mbp)", ylab = "EVE Count") +  scale_color_brewer(palette = "Set1")  +  scale_fill_brewer(palette = "Set1") +
  theme_classic() + theme(legend.position = 'bottom') + facet_wrap(~ factor(Phylum, c("Microsporidiomycota","Neocallimastigomycota","Chytridiomycota","Zoopagomycota","Glomeromycota","Mucoromycota","Ascomycota","Basidiomycota")), scales = "free", ncol=4)
Figure3

Figure3 <- ggscatter(total, x = "Mbp", color="Phylum", y = "EVE_Count", shape = "EVE_Status",
                     add = "reg.line",conf.int = TRUE, 
                     cor.coef = TRUE, cor.method = "pearson",
                     xlab = "Genome Size (Mbp)", ylab = "EVE Count") + scale_shape_manual(values = c(1,19)) +  scale_color_manual(values = c("red","#0066FF","#33CC33","purple","orange","gold","#993200","pink"))  +  scale_fill_manual(values = c("red","#0066FF","#33CC33","purple","orange","gold","#993200","pink")) +
  theme_classic() + theme(legend.position = 'bottom') + facet_wrap(~ factor(Phylum, c("Microsporidiomycota","Neocallimastigomycota","Chytridiomycota","Zoopagomycota","Glomeromycota","Mucoromycota","Ascomycota","Basidiomycota")), scales = "free", ncol=4)
Figure3

Figure3b <- ggscatter(total_log, x = "log_bp", color="Phylum", y = "EVE_Count", shape = "EVE_Status",
                     add = "reg.line",conf.int = TRUE, 
                     cor.coef = TRUE, cor.method = "pearson",
                     xlab = "log(Genome Size)", ylab = "EVE Count") + scale_shape_manual(values = c(1,19)) +  scale_color_manual(values = c("red","#0066FF","#33CC33","purple","orange","gold","#993200","pink"), guide="none")  +  scale_fill_manual(values = c("red","#0066FF","#33CC33","purple","orange","gold","#993200","pink"), guide="none") +
  theme_classic() + theme(legend.position = 'bottom',axis.text=element_text(size=12),
                          axis.title=element_text(size=14,face="bold")) + facet_wrap(~ factor(Phylum, c("Microsporidiomycota","Neocallimastigomycota","Chytridiomycota","Zoopagomycota","Glomeromycota","Mucoromycota","Ascomycota","Basidiomycota")), scales = "free", ncol=4) 
Figure3b

## Let's do the same for GC content ## 
EVE_GC <- read.table("EVE_GC.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)
FUNG_GC <- read.table("Fungal_GC.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)

df <- as.data.frame(EVE_GC)
df <- df %>% 
  group_by(ACC) %>% 
  summarise(SD = sd(GC, na.rm=TRUE))

df$SD

to_drop <- setdiff(EVE_GC$ACC, FUNG_GC$ACC)
to_drop

GC <- inner_join(FUNG_GC,EVE_GC, by="ACC")



Figure3a <- ggscatter(GC, x = "Fungal_GC", color="Phylum.x", y = "GC", 
                     add = "reg.line",conf.int = TRUE,  
                     cor.coef = TRUE, cor.method = "pearson",
                     xlab = "Fungal GC Content", ylab = "EVE GC Content") +  scale_color_brewer(palette = "Set1")  +  scale_fill_brewer(palette = "Set1") +
  theme_classic() + theme(legend.position = 'bottom') #+ facet_wrap(~ factor(Phylum.x, c("Microsporidiomycota","Neocallimastigomycota","Chytridiomycota","Zoopagomycota","Glomeromycota","Mucoromycota","Ascomycota","Basidiomycota")), scales = "fixed", ncol=4)
Figure3a

library(ggpmisc)

Figure3a <- ggplot(GC, aes(y=GC, x=Fungal_GC)) +
  geom_point(aes(color=factor(Phylum.x))) +
  stat_correlation(use_label(c("R", "P"))) +
  stat_poly_line(color="black") + theme_bw() + theme(legend.position = "bottom",legend.title=element_blank()) +
  xlab('Fungal GC Content') + ylab('EVE GC Content') + 
  scale_color_manual(values = c("red","#0066FF","#33CC33","purple","orange","gold","#993200","pink")) + theme(legend.position = "none", axis.text=element_text(size=12),
                                                                                                              axis.title=element_text(size=14,face="bold"))

Figure3a

library(cowplot)


Figure3 <- plot_grid(
  Figure3b, Figure3a,
  labels = "AUTO", ncol = 2, rel_widths = c(2,1), rel_heights = c(2,2)
)
Figure3

