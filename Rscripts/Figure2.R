library(ggplot2)
library(gggenes)
library(ggtree)
library(viridis)
library(treeio)
library(RColorBrewer)
library(rvcheck)
library(devtools)
library(phytools)
library(cowplot)

#### Read in EVE_Domains file ####
Domains <- read.table("EVE_domains.txt", sep="\t", header=TRUE,check.names=FALSE, stringsAsFactor=F)

# lock in the order of the dataset

df <- as.data.frame(Domains)

df

df$Genome <- factor(df$Genome, levels = df$Genome)

Fig2B <- ggplot(df, aes(xmin = start, xmax = end, y = Genome)) +
  facet_wrap(~ Gene, scales = "fixed", ncol = 1) +
  geom_gene_arrow(fill = "white", aes(forward=orientation)) +
  geom_subgene_arrow(data = df,
                     aes(xmin = start, xmax = end, y = Genome, fill = Domain,
                         xsubmin = from, xsubmax = to, forward=orientation), color="black", alpha=.7) +
  scale_fill_manual(values = c("firebrick2","steelblue2")) +
  theme_genes() + ggtitle("EVE Domain Positions")

### Let's plot the relative lengths of Exogenous vs. Endogenous CRESS Virs ###

LEN <- read.csv("CRESS_EVE_LENGTHS.csv", header = TRUE)
LEN

## first make sure plyr is unloaded ##

detach("package:plyr") 
library(dplyr)

## subset the lengths of the Vertebrate EVEs and the Exogenous and calculate the averages ##

Non_Fung <- subset(LEN, Exognous.vs..Endogenous==c("Exogenous"),
                   select=c(Exognous.vs..Endogenous,length,Function))

Non_Fung_REP <- subset(Non_Fung, Function==c("Rep"),
                       select=c(Exognous.vs..Endogenous,length,Function))
Non_Fung_REP

# Calculate average length for cap and rep in other EVES/viruses ##
library(plyr)

mu_REP <- ddply(Non_Fung_REP, "Exognous.vs..Endogenous", summarise, grp.mean=mean(length))
head(mu_REP)

## Subset the Fungal EVE Lengths ##

Fung <- subset(LEN, Exognous.vs..Endogenous==c("Endogenous"),
               select=c(Exognous.vs..Endogenous,length,Function,Phylum))

Fung_REP <- subset(Fung, Function==c("Rep"),
                   select=c(Exognous.vs..Endogenous,length,Function,Phylum))
Fung_REP

## Plot the fungal EVE Cap and Rep lengths ##

Fig2A <- ggplot(Fung_REP, aes(x=length,fill=Phylum)) +
  #geom_histogram(aes(y=..density..), position="identity", alpha=0.5) + 
  scale_fill_brewer(palette = "Set1")+
  geom_density(alpha=.6) +
  geom_vline(data=mu_REP, aes(xintercept=grp.mean, color=Exognous.vs..Endogenous),linewidth=1.5,linetype="dashed") +
  scale_color_manual(values = c("purple1")) +
  theme_classic() + theme(legend.position = 'right') + facet_wrap(~Phylum, scales = "fixed", ncol=4)
Fig2A

