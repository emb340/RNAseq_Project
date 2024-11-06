# Workflow details for the _Candida albicans_ RNAseq analysis 
The general outline for this project is Sequence Quality Control --> Mapping to a Reference --> Couting the Reads per Gene Model --> Differential Expression Analysis --> Gene Ontology Enrichment Analysis

## Overview of Experimental Treatment
_Candida albicans_ is a human commensal fungus and opportunistic pathogen that can cause several diseases, including urinary tract and blood infections. To evaluate its role in _C. albicans_ proliferation, cultures of this species were grown in the presence or absence of thiamine (Vitamin B1) and then their mRNA transcripts were collected and sequenced for evaluation. 

## Data Accession
RNA sequence data was obtained from the Rolfes Lab at the Georgetown University Department of Biology.
Raw reads are not accessible to the public at the moment, as they have yet to be published.


## Preprocessing and Quality Control
FASTQC quality analysis was performed on the raw forward and reverse reads for biological isolate A [(script)](https://github.com/emb340/RNAseq_Project/blob/main/fastqc1.SBATCH)

The initial FASTQC processing indicated that both the [forward](https://github.com/emb340/RNAseq_Project/blob/main/WTA1_1_preclean_fastqc.html) and [reverse](https://github.com/emb340/RNAseq_Project/blob/main/WTA1_2_preclean_fastqc.html) sequence reads had significant quality issues, chiefly problematic per base sequence content near the beginning of the reads and duplication levels.

As a result, Trimmomatic was employed to trim the sequence reads and increase their quality [(script)](https://github.com/emb340/RNAseq_Project/blob/main/trimmomatic_attempt_one.SBATCH). Specifically, a headcrop 15 parameter was utilized to resolve the concerning per base sequence content visible at the start of the sequence reads. The Trimmomatic script also removed the [adapter sequences](https://github.com/emb340/RNAseq_Project/blob/main/TruSeq3-PE.fa) used in the Illumina sequencing of the RNA reads to prevent any adapter contamination.

The second iteration of FASTQ analysis illustrated that positive changes in quality had taken place, with both the [trimmed forward](https://github.com/emb340/RNAseq_Project/blob/main/WTA1_1.trPE_fastqc.html) and [trimmed reverse](https://github.com/emb340/RNAseq_Project/blob/main/WTA1_2.trPE_fastqc.html) reads showing a significant improvement in per base sequence content. Although duplication levels were not modified by this trimming, it is likely that these flags will not impair our analysis and may in fact be biologically relevant. 

## Mapping Reads to a Reference

