# Workflow details for the _Candida albicans_ RNAseq analysis 
The general outline for this project is Sequence Quality Control --> Mapping to a Reference --> Couting the Reads per Gene Model --> Differential Expression Analysis --> Gene Ontology Enrichment Analysis

## Overview of Experimental Treatment
SEE SLIDES FROM FIRST CLASS***

## Data Accession
DNA sequence data was obtained from the Rolfes Lab at the Georgetown University Department of Biology.
Raw reads are not accessible to the public at the moment, as they have yet to be published.

## Preprocessing and Quality Control
FASTQC quality analysis was performed on the raw forward and reverse reads for biological isolate A [(script)](https://github.com/emb340/RNAseq_Project/blob/main/fastqc1.SBATCH)

The initial FASTQC processing indicated that both the [forward](https://github.com/emb340/RNAseq_Project/blob/main/WTA1_1_preclean_fastqc.html) and [reverse](https://github.com/emb340/RNAseq_Project/blob/main/WTA1_2_preclean_fastqc.html) sequence reads had significant quality issues, chiefly problematic per base sequence content and duplication levels.

As a result, 
