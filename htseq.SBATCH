#!/bin/bash
#SBATCH --job-name=htseq --output=z01.%x
#SBATCH --mail-type=END,FAIL --mail-user=emb340@georgetown.edu
#SBATCH --nodes=1 --ntasks=1 --cpus-per-task=1 --time=72:00:00
#SBATCH --mem=4G

#this script employs htseq to count and assign reads to genes#

source activate htseq

#setting variables#

htseq=/home/emb340/.conda/envs/htseq/bin/htseq-count
bam=/home/emb340/RNAseq/step_three_referenceSeq/WTA1.srt.bam
anno=/home/emb340/RNAseq/step_three_referenceSeq/GCF_000182965.3_ASM18296v3_genomic.gtf
output=/home/emb340/RNAseq/step_four_HTSeq/htseq_output

#running htseq-count#

$htseq \
-f bam \
-r pos \
-s no \
-t exon \
-i gene_id \
$bam \
$anno \
> $output



