# Workflow details for the _Candida albicans_ RNAseq analysis 
The general outline for this project is Sequence Quality Control --> Mapping to a Reference --> Counting the Reads per Gene Model --> Differential Expression Analysis --> Gene Ontology Enrichment Analysis

## Overview of Experimental Treatment
_Candida albicans_ is a human commensal fungus and opportunistic pathogen that can cause several diseases, including urinary tract and blood infections. To evaluate the role of thiamine (vitamin B1) in _C. albicans_ proliferation, cultures of this species were grown in the presence or absence of thiamine and then their mRNA transcripts were collected and sequenced for evaluation. This experimental procedure gave rise to a collection of 12 data files: forward and reverse reads (_1 and _2) for three biological replicates (WTA, WTB, and WTC) grown in the presence or absence of thiamine (WTX1 or WTX2). 

<img width="402" alt="Screenshot 2024-11-15 at 11 38 36 AM" src="https://github.com/user-attachments/assets/34f09c4f-acdf-4366-9d5b-de94492e1b1c">

This analysis will specifically investigate the population of biological isolate A that was grown in the presence of thiamine (WTA1). 

## Data Accession
RNA sequence data was obtained from the Rolfes Lab at the Georgetown University Department of Biology.
Raw reads are not accessible to the public currently, as they have yet to be published.


## Preprocessing and Quality Control
FASTQC quality analysis was performed on the raw forward and reverse reads for biological isolate A [(script)](https://github.com/emb340/RNAseq_Project/blob/main/fastqc1.SBATCH).

The initial FASTQC processing indicated that both the [forward](https://github.com/emb340/RNAseq_Project/blob/main/WTA1_1_preclean_fastqc.html) and [reverse](https://github.com/emb340/RNAseq_Project/blob/main/WTA1_2_preclean_fastqc.html) sequence reads had significant quality issues, chiefly problematic per base sequence content near the beginning of the reads and duplication levels.

As a result, Trimmomatic was employed to trim the sequence reads and increase their quality [(script)](https://github.com/emb340/RNAseq_Project/blob/main/trimmomatic_attempt_one.SBATCH). Specifically, a headcrop 15 parameter was utilized to resolve the concerning per base sequence content visible at the start of the sequence reads. The Trimmomatic script also removed the [adapter sequences](https://github.com/emb340/RNAseq_Project/blob/main/TruSeq3-PE.fa) used in the Illumina sequencing of the RNA reads to prevent any adapter contamination.

A second iteration of FASTQ analysis illustrated that positive changes in quality had taken place, with both the [trimmed forward](https://github.com/emb340/RNAseq_Project/blob/main/WTA1_1.trPE_fastqc.html) and [trimmed reverse](https://github.com/emb340/RNAseq_Project/blob/main/WTA1_2.trPE_fastqc.html) reads showing a significant improvement in per base sequence content. Although duplication levels were not modified by this trimming, it is likely that these flags will not impair our analysis and may in fact be biologically relevant. A more extensive evaluation of the pre and post-cleaned reads for all experimental data is provided [here](https://docs.google.com/spreadsheets/d/1AOa-XaTzR_PKMIRQDmu8oDTmawXXnkIwEjKOQkNC7Vs/edit?gid=0#gid=0).

## Mapping Reads to a Reference

Mapping was done using the _Candida albicans_ reference genome [(GCF_000182965.3)](https://github.com/emb340/RNAseq_Project/blob/main/GCF_000182965.3_ASM18296v3_genomic.fna) obtained from the NCBI genome database. This haploid assembly was selected to streamline the alignment process and take advantage of NCBI's curated [annotation file](https://github.com/emb340/RNAseq_Project/blob/main/GCF_000182965.3_ASM18296v3_genomic.gtf).

The genome was indexed with bowtie2/2.5.3, creating several new index files with the base name alignment_index based on the NCBI reference genome and using the following Bash command: 

bowtie2-build /home/emb340/RNAseq/step_three_referenceSeq/GCF_000182965.3_ASM18296v3_genomic.fna alignment_index

After the creation of these indices, bowtie2 was employed to align the trimmed, paired-end sequence reads against them [(script)](https://github.com/emb340/RNAseq_Project/blob/main/calbicans_bowtie2_alignment.SBATCH).

This read alignment is depicted in the WTA1.sam file, and summarized in the [z01 file](https://github.com/emb340/RNAseq_Project/blob/main/z01.bowtie2) derived from the above bowtie2 script. Overall, the alignment was broadly successful, with an overall alignment rate of trimmed reads to the reference transcriptome of 98.07%. Additionally, 95.24% of these reads aligned concordantly at least once. Further analysis of the alignment success for all experimental data can be accessed [here](https://docs.google.com/spreadsheets/d/1fa-FXVMlCXOZkbHSx_mMg0OXLMy9BeBJg8uWrEMpKGo/edit?gid=0#gid=0).

To best facilitate the next step of the workflow, the samtools package was utilized to convert the .sam file containing the alignment data to a .bam file (WTA1.bam) using the following Bash command: samtools view -S -b WTA1.sam > WTA1.bam. Then, an index bam file (WTA1.bam.bai) was also generated utilizing the command "samtools index WTA1.bam." 


## Counting Reads per Gene Model with HTSeq
Within the context of a Conda environment--utilized to ensure compatibility while integrating multiple pieces of software--HTSeq was implemented to count reads per gene for the reference-mapped reads obtained previously [(script)](https://github.com/emb340/RNAseq_Project/blob/main/htseq.SBATCH). 

This analysis incorporated the sorted .bam files containing the read alignment data for all experimental isolates and the .gtf annotation file referenced previously to list the number of observed read counts per annotated _C. albicans_gene, outlined in the following HTSeq_count files: [WTA1](https://github.com/emb340/RNAseq_Project/blob/main/TH_WTA1_htseqCount), [WTB1](https://github.com/emb340/RNAseq_Project/blob/main/TH_WTB1_htseqCount), [WTC1](https://github.com/emb340/RNAseq_Project/blob/main/TH_WTC1_htseqCount), [WTA2](https://github.com/emb340/RNAseq_Project/blob/main/NTH_WTA2_htseqCount), [WTB2](https://github.com/emb340/RNAseq_Project/blob/main/NTH_WTB2_htseqCount), and [WTC2](https://github.com/emb340/RNAseq_Project/blob/main/NTH_WTC2_htseqCount).

## Differential Expression Analysis with DESeq2
To identify genes expressed differentially in the presence or absence of thiamine, the above HTSeq_count files were entered into RStudio for analysis with the DESeq2 package (see R script [here](https://github.com/emb340/RNAseq_Project/blob/main/calb_DESeq_script_FINAL.R)). 

This DESeq2 script was employed to manipulate and investigate the input data: 
1) The HTSeq_count files were loaded into a directory and each was labeled with the experimental condition and a sample name (lines 38-56). The output of this step is given below.
<img width="362" alt="Screenshot 2024-11-26 at 2 28 23 PM" src="https://github.com/user-attachments/assets/2180cdde-6677-4fe1-ad9e-7860807357e7">

2) Once properly formatted, the HTSeq files were input into a new DESeq2 dataset titled **dds** (lines 57-64).
3) Following some quality filtration procedures, a Principal Component Analysis was performed to illustrate the variation between the expression level of all evaluated genes as the product of only two principal components: PC1 and PC2 (lines 78-106). The PCA plot is given below.
<img width="820" alt="image" src="https://github.com/user-attachments/assets/4ced2236-f57f-4f9b-9df4-04c98c1e4462">

As can be seen in the PCA plot, the two experimental conditions (THI+/THI-) do not meaningfully differ regarding PC1, which accounts for 88% of the variance in gene expression. However, these treatments differ about PC2, which accounts for only 9% of the variance in gene expression, indicating that we expect to see local rather than global differences in expression levels between the two.

4) Following this, a differential gene analysis was run, and a volcano plot was generated to depict the significance, magnitude, and direction of the differences in gene expression levels between the two experimental conditions (lines 107-146). The volcano plot is given below. As illustrated by this figure, the most significantly expressed genes (seen in red) were upregulated in THI- conditions relative to THI+ ones.
<img width="734" alt="image" src="https://github.com/user-attachments/assets/70a5b534-a8c0-4d53-bbc5-45d3f03bab78">



5) Next, the most significant differentially expressed genes were identified by pruning the data based on the parameters of a p-value of < 0.05 and an absolute log2FoldChange of > 1 (line 152). From this, 13 critical differentially expressed genes (DEGs) with positive log2FoldChanges were isolated, reaffirming that these genes are upregulated in the absence of thiamine (lines 148-154). This information is depicted in the table below.
<img width="667" alt="image" src="https://github.com/user-attachments/assets/e1e4b73b-c2e4-4d52-97e8-0f41838c01d5">

6) Gene names were then pulled from NCBI and attached to the previously identified DEGs (lines 157-174). The NCBI geneID and Candida Genome Database gene name from the .gtf annotation file--utilized earlier in the analysis when mapping reads to a reference genome--were then collected by the following Bash command: $ grep -wFf signif_geneIDs GCF_000182965.3_ASM18296v3_genomic.gtf|grep "protein_coding"|cut -f9|cut -d ";" -f1,3,5 > signif_gene_annot_info.

7) Finally, descriptions of the biological function of these genes were obtained from the [Candida genome page](http://www.candidagenome.org/). The final DEG characterizations, several of which are related to thiamine biosynthesis or transport, can be found in this [sheet](https://github.com/emb340/RNAseq_Project/blob/main/signif_TH-vTH%2B.xlsx).


## Gene Ontology (GO) Analysis
To identify GO terms that were meaningfully enriched for the previously identified DEGs, the NCBI GeneIDs of the 13 DEGs were input into the PANTHER knowledgebase, and a statistical enrichment test was conducted. Some of the most significantly enriched GO tags and their associated statistical values are given in the table below.
<img width="833" alt="image" src="https://github.com/user-attachments/assets/b81ebe22-1be4-45ec-8755-382fcc15a9e1">



From the above table, it is evident that the genes upregulated in _Candida albicans_ grown in the absence of thiamine are involved in the synthesis of thiamine and its derivatives. This conclusion aligns with the results of the DESeq2 analysis, reaffirming this function for the majority of the 13 identified DEGs. Such a function for these genes makes biological sense, as when _C. albicans_ is cultivated in conditions where it is starved for thiamine, to enable survival and proliferation, the organism would opt to produce its thiamine rather than fail to obtain it from the extracellular environment. 

However, it is important to note that a number of the DEGs possessed functions unrelated to the biosynthesis of thiamine. As inferred from the Candida genome database and PANTHER evaluation, these include pyridoxine (a derivative of vitamin B6) synthesis and transport, sterol synthesis, and chromosomal segregation during mitosis. Speculatively, the differential expression of genes with these additional functions in _C. albicans_ cultured in a thiamine-absent environment suggests these processes may be involved in a broader stress response to conditions of nutrient limitation.

