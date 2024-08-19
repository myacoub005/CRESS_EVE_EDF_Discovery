tree <- read.tree("KAZ_Fungi_constrain_tree.txt")
#tip_metadata <- read.table("Chytrid_REP_metadata.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)
tip_metadata <- read.table("EVE_REP_metadata.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)
tip_metadata

tree
tipnames <- tree$tip.label
tipnames
to_drop <- setdiff(tree$tip.label, tip_metadata$ID)
to_drop

straintree <- drop.tip(tree, to_drop)
tipnames <- straintree$tip.label
tipnames

p1 <- ggtree(straintree, layout="circular", branch.length = 'none') %<+% tip_metadata  +
  geom_text2(aes(subset=!isTip, label=node)) +
  geom_tiplab(size=2, color="black") + geom_tippoint(aes(color=Classification), size=2) + 
  scale_color_manual(values = c("#F0A3FF","#003380","#005C33","purple","orange","gold","#993200","#FFCC99","chartreuse","darkorchid1","#808080", "#00998F", "#E0FF66","#0075D0","#9DCC00","#2BCE48","#FF0010","lightgray","#5EF1F2"))

p1 

#Cladogram

p1 <- ggtree(straintree, layout="circular", branch.length = 'none',size=1, aes(color=as.numeric(label))) +
  scale_color_gradient("Bootstrap", low = "green", high = "black", limits=c(0,100))+ guides(color = guide_legend(override.aes = list(size=50))) + theme(legend.position = "bottom") + theme(legend.text=element_text(size=80)) + new_scale_color() + 
  #geom_nodelab(size=2) +
  #geom_tiplab(size=4, color="black", offset=.25) + 
  #geom_text2(aes(subset=!isTip, label=node)) +
  geom_cladelab(node=2081, label="CRESSV6", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=1944, label="CRESS-Rec1", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=1609, label="CRESS-Rec2", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=2121, label="Geminiviridae", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=2412, label="Genomoviridae", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=1646, label="CRESSV5", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=1662, label="CRESSV4", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=1774, label="Nenyaviridae", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=1748, label="CRESSV2", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=1807, label="Naryaviridae", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=1811, label="Redondoviridae", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=1833, label="CRESSV3", fontsize=16, align=T, offset=2, offset.text=5) + 
  geom_cladelab(node=1854, label="Cicroviridae", fontsize=16, align=T, offset=2, offset.text=5) + 
  geom_cladelab(node=1929, label="CRESSV1", fontsize=16, align=T, offset=2, offset.text=5) + 
  geom_cladelab(node=1919, label="Bacilladnaviridae", fontsize=16, align=T, offset=2, offset.text=5) + 
  geom_cladelab(node=1980, label="Vilyaviridae", fontsize=16, align=T, offset=2, offset.text=5) + 
  geom_cladelab(node=1670, label="Nanoviridae", fontsize=16, align=T, offset=2, offset.text=5) +
  geom_cladelab(node=1689, label="Smacoviridae", fontsize=16, align=T, offset=2, offset.text=5) #+
  geom_cladelab(node=2627, label="Basidiomycota EVE Clade (n=513)", fontsize=8, align=T, offset=2, offset.text=5) + 
  geom_cladelab(node=2459, label="Ascomycota EVE Clade (n=265)", fontsize=16, align=T, offset=2, offset.text=5) 
p1

p2 <- p1 %>% ggtree::collapse(2627,'min', fill="#0066FF") %>% ggtree::collapse(2459,'min', fill="red") %<+% tip_metadata + geom_tiplab(aes(color=Host), size=2) + geom_tiplab(aes(color=Host), size=2) + theme(legend.position = "bottom") +
  scale_color_manual(values = c("red","#0066FF","#33CC33","purple","orange","gold","#993200","NA","pink")) + theme_tree(legend.position='bottom') + xlim_expand(0,1000) + 
  guides(color = guide_legend(override.aes = list(size=50))) + theme(legend.position = "bottom") 

p2

p2 <- p1 %<+% tip_metadata + geom_tippoint(aes(color=Host), size=2) + geom_tiplab(aes(color=Host), size=2) + theme(legend.position = "bottom") +
  scale_color_manual(values = c("red","#0066FF","#33CC33","purple","orange","gold","#993200","NA","pink")) + theme_tree(legend.position='bottom') + xlim_expand(0,1000) + 
  guides(color = guide_legend(override.aes = list(size=50))) + theme(legend.position = "bottom") + theme(legend.text=element_text(size=80))

p2
