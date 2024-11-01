#!/bin/bash
#SBATCH --job-name=example
#SBATCH --output=z01.%x
#SBATCH --mail-type=END,FAIL --mail-user=emb340@georgetown.edu
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=1 --time=72:00:00
#SBATCH --mem=4G
#SBATCH --chdir=/home/emb340/RNAseq/step_two_trimming

#setting the environment and loading the module
shopt -s expand_aliases
module load trimmomatic

#running trimmomatic on two input fasta files

trimmomatic PE \
/home/emb340/RNAseq/step_one_fastqc_preclean/WTA1_1.fq \
/home/emb340/RNAseq/step_one_fastqc_preclean/WTA1_2.fq \
/home/emb340/RNAseq/step_two_trimming/WTA1_1.trPE.fq.gz /home/emb340/RNAseq/step_two_trimming/WTA1_1.trSE.fq.gz \
/home/emb340/RNAseq/step_two_trimming/WTA1_2.trPE.fq.gz /home/emb340/RNAseq/step_two_trimming/WTA1_2.trSE.fq.gz \
ILLUMINACLIP:/home/emb340/RNAseq/step_two_trimming/TruSeq3-PE.fa:2:30:10 \
HEADCROP:15 \
TRAILING:20 \
SLIDINGWINDOW:4:15 \
MINLEN:75

#unloading trimmomatic
module unload trimmomatic
