import pandas as pd 
from Bio import SeqIO
from Bio import SeqFeature

df = pd.read_csv('27SEPTtest.txt', sep='\t', names=['Cluster', 'Start', 'Stop'])
start_gene = df["Start"].tolist()
end_gene = df["Stop"].tolist()
cluster_name = df["Cluster"].tolist()

gbk = "antiSMASH.gbk"
record = next(SeqIO.parse("antiSMASH.gbk", "genbank"))

for x, y, z in zip(start_gene, end_gene, cluster_name):
    for seq_record in SeqIO.parse(gbk, "genbank"):
        for feat in seq_record.features:
            if feat.type == "CDS":
                if x in feat.qualifiers["gene_id"]:

                    cluster_start = feat.location.start

                else:

                    if y in feat.qualifiers["gene_id"]:

                        cluster_end = feat.location.end

                        subrecord = record[cluster_start:cluster_end]

                        filename = "%s.gbk" % z

                        SeqIO.write(subrecord, filename, "gb")
