#!/bin/bash
#SBATCH --job-name=bowtie2
#SBATCH --output=z01.%x
#SBATCH --mail-type=END,FAIL --mail-user=emb340@georgetown.edu
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=1 --time=72:00:00
#SBATCH --mem=4G
#SBATCH --chdir=/home/emb340/RNAseq/step_three_referenceSeq

#This script runs bowtie2 on two input trimmed PE reads to align them against a reference genome

#loading bowtie2
module load bowtie2/2.5.3

#input forward reads path
forward_input=/home/emb340/RNAseq/step_two_trimming/WTA1_1.trPE.fq

#input reverse reads path
reverse_input=/home/emb340/RNAseq/step_two_trimming/WTA1_2.trPE.fq

#running bowtie2
bowtie2 -x alignment_index \
-1 $forward_input \
-2 $reverse_input \
-S WTA1.sam

#unloading bowtie2
module unload bowtie2
