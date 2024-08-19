FG <- read.table("EVE_Funguild.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)
FGA

FGplt <- ggplot(FGA, aes(fill=`Trophic Mode`, y=Percent, x=EVE_Presence)) + 
  geom_bar(position="fill", stat="identity")+ scale_fill_manual(values = c("dodgerblue2", "#E31A1C", "green4", "#6A3D9A", "#FF7F00", "black", "gold1", "skyblue2", "palegreen2", "#FDBF6F", "gray70", "maroon", "orchid1", "darkturquoise", "darkorange4", "brown")) + theme_bw() + facet_wrap(~Phylum, scales = "free", ncol=4)

FGplt


FGplt <- ggplot(FG, aes(fill=`Trophic Mode`, y=Count, x=EVE_Presence)) + 
  geom_bar(position="stack", stat="identity")+ scale_fill_manual(values = c("dodgerblue2", "#E31A1C", "green4", "#6A3D9A", "#FF7F00", "black", "gold1", "skyblue2", "palegreen2", "#FDBF6F", "gray70", "maroon", "orchid1", "darkturquoise", "darkorange4", "brown")) + facet_wrap(~Phylum, scales = "free", ncol=4)

FGplt

#Let's subset the FG file by fungal phyla so we can make a contingency table
FGA <- FG[FG$Phylum=="Ascomycota", c("Phylum","EVE_Presence","Count","Trophic Mode","Percent")]
FGAS <- FGA[order(FGA$`Trophic Mode`),]
pdf("Asco_FGtable.pdf", height=20, width=20)

grid.table(FGAS)

FGAF <- ftable(FGAS$EVE_Presence, FGAS$Count, FGAS$`Trophic Mode`)
FGAS
grid.table(FGAS)

FGB<- FG[FG$Phylum=="Basidiomycota", c("Phylum","EVE_Presence","Count","Trophic Mode")]
FGB
FGBS <- FGB[order(FGB$`Trophic Mode`),]
pdf("Basid_FGtable.pdf", height=6, width=4)
grid.table(FGBS)
dev.off()

ggplot(FGAS) +
  aes(x = FGAS$`Trophic Mode`, y = Count, color = EVE_Presence) +
  geom_jitter() +
  theme(legend.position = "none")


#Let's try this with a pivot and Chi test

FGA <- read.table("Asco_FG_pivot2.csv", sep=",", row.names = 1, header = TRUE)
FGA
library("vcd")
assoc(head(FGA, 5), shade = TRUE, las=3)

chisq <- chisq.test(FGA)
chisq
chisq$observed
chisq$residuals
round(chisq$expected,2)
round(chisq$residuals, 3)
library(corrplot)

dev.new()

M <- as.matrix(chisq$residuals)
png(filename = "Asco_corrplot.png", res=400, width = 8500, height = 4500)
corrplot(M, method = 'number', is.corr = FALSE, cl.pos = "b", cl.align='c', insig = "blank",number.cex = 2, tl.cex = 2, cl.cex = 1,cl.ratio=1)


contrib <- 100*chisq$residuals^2/chisq$statistic
round(contrib, 3)
corrplot(contrib, is.cor = FALSE)

##Let's break down Ascomycota by Subphy and Family##

ASUBPHY <- read.table("Ascomycota_EVE_subphy.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)
ASUBPHY
ASUBPHYPLT <- ggplot(ASUBPHY, aes(fill=Subphylum, y=Count, x=ASUBPHY$`EVE Presence`)) + 
  geom_bar(position="stack", stat="identity") + scale_fill_brewer(palette = "Set2") + theme_bw() + labs(x="EVE Presence") 
ASUBPHYPLT

ASUBPHYPLT <- ggplot(ASUBPHY, aes(fill=Subphylum, y=Count, x=ASUBPHY$`EVE Presence`)) + 
  geom_bar(position="fill", stat="identity") + scale_fill_brewer(palette = "Set2") + theme_bw() + labs(x="EVE Presence") 
ASUBPHYPLT

# Let's try the same thing with the families #

AFAM <- read.table("Ascomycota_families.csv", sep=",", header=TRUE,check.names=FALSE, stringsAsFactor=F)
AFAM
AFAMPLT <- ggplot(AFAM, aes(fill=Family, y=Count, x=AFAM$`EVE Presence`)) + 
  geom_bar(position="stack", stat="identity") + scale_fill_carto_d(palette = "Safe") + theme_bw() + labs(x="EVE Presence") 
AFAMPLT

famcolors <- carto_pal(9,"Safe")


AFAMPLT <- ggplot(AFAM, aes(fill=Family, y=Count, x=AFAM$`EVE Presence`)) + 
  geom_bar(position="fill", stat="identity") + scale_fill_carto_d(palette = "Safe") + theme_bw() + labs(x="EVE Presence") 
AFAMPLT


## Let's check for correlation between subphyla and EVE presence ##
FGA <- read.table("EVE_Asco_Sybphy_pivot.csv", sep=",", row.names = 1, header = TRUE)
FGA
library("vcd")
assoc(head(FGA, 5), shade = TRUE, las=3)

chisq <- chisq.test(FGA)
chisq
chisq$observed
chisq$residuals
round(chisq$expected,2)
round(chisq$residuals, 3)
library(corrplot)

dev.new()

M <- as.matrix(chisq$residuals)
png(filename = "Asco_corrplot.png", res=400, width = 8500, height = 4500)
corrplot(M, is.corr = FALSE, cl.pos = "b", cl.align='c', insig = "blank",number.cex = 2, tl.cex = 2, cl.cex = 1,cl.ratio=1)



