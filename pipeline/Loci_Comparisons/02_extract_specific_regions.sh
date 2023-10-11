#!/bin/bash
#SBATCH -p short -N 1 -n 16 --mem 16gb --out logs/extract_specific_regions.log

# We're going to pick a couple of representatives from the major EDF phyla and plot their CAP/REP positions + flanking fungal genes #
# This will be helpful when we plot the GC content 

OUTDIR=Viral_int_regions

mkdir -p $OUTDIR

# Chytridiomycota (REP)

grep -B2 -A 2 "SeMB42_g06644" ncbi_dataset/data/GCA_006535955.1/GCA_006535955.1.Synchytrium.endobioticum.genes.bed > $OUTDIR/GCA_006535955.1.Synchytrium.endobioticum.REP.Integration_locus.bed

# Chytridiomycota (CAP)

# Neocallimastigomycota (REP)

grep "BCR36DRAFT_371905" ncbi_dataset/data/GCA_002104945.1/GCA_002104945.1.Piromyces.finnis.genes.bed -B 1 -A 1 > $OUTDIR/GCA_002104945.1.Piromyces.finnis.REP.Integration_locus.bed

grep "LY90DRAFT_518794" ncbi_dataset/data/GCA_002104975.1/GCA_002104975.1.Neocallimastix.californiae.genes.bed -B 1 -A 1 > $OUTDIR/GCA_002104975.1.Neocallimastix.californiae.REP.Integration_locus.bed

# Neocallimastigomycota (CAP)

grep "BCR36DRAFT_369444" ncbi_dataset/data/GCA_002104945.1/GCA_002104945.1.Piromyces.finnis.genes.bed -B 1 -A 1 > $OUTDIR/GCA_002104945.1.Piromyces.finnis.CAP.Integration_locus.bed

grep "LY90DRAFT_502034" ncbi_dataset/data/GCA_002104975.1/GCA_002104975.1.Neocallimastix.californiae.genes.bed -B 1 -A 1 > $OUTDIR/GCA_002104975.1.Neocallimastix.californiae.CAP.Integration_locus.bed

# Microsporidia (REP)

grep "DI09_296p10" ncbi_dataset/data/GCA_000760515.2/GCA_000760515.2.Mitosporidium.daphniae.genes.bed -A 1 > $OUTDIR/GCA_000760515.2.Mitosporidium.daphniae.REP.Integration_locus.bed

grep "NGRA_0299" ncbi_dataset/data/GCA_015832245.1/GCA_015832245.1.Nosema.granulosis.genes.bed -B 2 -A 2 > $OUTDIR/GCA_015832245.1.Nosema.granulosis.REP.Integration_locus.bed

# Glomeromycota (REP)

grep "C2G38_2240992" ncbi_dataset/data/GCA_003550325.1/GCA_003550325.1.Gigaspora.rosea.genes.bed -B 1 -A 1 > $OUTDIR/GCA_003550325.1.Gigaspora.rosea.REP.Integration_locus.bed

# Glomeromycota (CAP)

grep "C2G38_2038331" ncbi_dataset/data/GCA_003550325.1/GCA_003550325.1.Gigaspora.rosea.genes.bed -B 1 -A 1 > $OUTDIR/GCA_003550325.1.Gigaspora.rosea.CAP.Integration_locus.bed

# Mucoromycota (REP)

grep "DFQ29_003725" ncbi_dataset/data/GCA_016097735.1/GCA_016097735.1.Apophysomyces.sp..genes.bed -B 1 -A 1 > $OUTDIR/GCA_016097735.1/GCA_016097735.1.Apophysomyces.sp.REP.Integration_locus.bed

# Zoopagomycota (REP)
grep "THASP1DRAFT_31536" ncbi_dataset/data/GCA_003614735.1/GCA_003614735.1.Thamnocephalis.sphaerospora.genes.bed -B 1 -A 1 > $OUTDIR/GCA_003614735.1.Thamnocephalis.sphaerospora.REP.Integration_locus.bed


