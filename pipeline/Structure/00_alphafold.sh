#!/bin/bash
#SBATCH -p gpu --gres=gpu:p100:1 --mem 48gb -N 1 -n 1 -c 16  --time 4:00:00 --out logs/alphafold.log

mkdir AlphaFold

module unload singularity
module load singularity


module load alphafold
singularity shell --nv $ALPHAFOLD_SING

alphafold --db_preset=reduced_dbs \
--use_gpu_relax=True \
--data_dir=$DATABASES_DIR/alphafold/2.3.0 \
--uniref90_database_path=$DATABASES_DIR/alphafold/2.3.0/uniref90/uniref90.fasta \
--mgnify_database_path=$DATABASES_DIR/alphafold/2.3.0/mgnify/mgy_clusters_2022_05.fa \
--template_mmcif_dir=$DATABASES_DIR/alphafold/2.3.0/pdb_mmcif/mmcif_files \
--max_template_date=2020-05-14 \
--obsolete_pdbs_path=$DATABASES_DIR/alphafold/2.3.0/pdb_mmcif/obsolete.dat \
--small_bfd_database_path=$DATABASES_DIR/alphafold/2.3.0/small_bfd/bfd-first_non_consensus_sequences.fasta \
--pdb70_database_path=$DATABASES_DIR/alphafold/2.3.0/pdb70/pdb70 \
--fasta_paths=AlphaFold/BdDV1_ORF3.fasta \
--output_dir=AlphaFold
