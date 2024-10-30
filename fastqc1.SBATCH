#!/bin/bash
#SBATCH --job-name=fastqc_intro_job --output=z01.%x
#SBATCH --mail-type=END,FAIL --mail-user=emb340@georgetown.edu
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=1 --time=72:00:00
#SBATCH --mem=4G

#this script runs fastqc on two input files

module load fastqc

fastqc /home/emb340/RNAseq/WTA1_1.fq /home/emb340/RNAseq/WTA1_2.fq

module unload fastqc
