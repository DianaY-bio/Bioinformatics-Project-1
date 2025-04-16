🧬 Bioinformatics Variant Calling Pipeline

This repository contains an end-to-end variant calling pipeline using BWA, SAMtools, Picard, and GATK. The pipeline processes raw sequencing data from FASTQ files to VCF files, identifying genomic variants (SNPs and indels) and utilizing advanced GATK functionalities, including GenomicsDB for multi-sample and multi-interval processing.

🧪 Objective

This project aims to demonstrate proficiency in bioinformatics workflows by performing variant calling on raw sequencing data, with a focus on accuracy, reproducibility, and optimization. This pipeline is structured for scalability, allowing it to handle data from multiple samples and chromosomes, facilitating high-quality genomic research.

🔧 Tools and Technologies

BWA – For sequence alignment from FASTQ to BAM files
SAMtools – For BAM file manipulation, indexing, and sorting
Picard – For handling duplicate reads and read group annotation
GATK (v4.x) – For variant calling in GVCF mode and genotyping using GenomicsDB
Java – Required for running Picard tools
Unix Shell Scripting – For workflow automation

📁 Input Files

The input data consists of raw sequencing files in FASTQ format, and includes reference genome files:

FASTQ files: DOGS-Gen-9-L2_S237_L008_R2_001.fastq.gz
Reference Genome Files: UU_Cfam_GSD_1.0_ROSY.fa
Sample Data Files: BAM files like DOGS-Gen-9-L2_S237_L008_R2_001_sorted.bam
The sequence data used in this example pertains to DOGS-Gen sequencing data. The pipeline is compatible with any organism, provided that the correct reference genome is available.

🧬 Pipeline Overview

Step 1: Indexing and Preparing Reference Files
bwa index UU_Cfam_GSD_1.0_ROSY.fa
samtools faidx UU_Cfam_GSD_1.0_ROSY.fa
gatk CreateSequenceDictionary -R UU_Cfam_GSD_1.0_ROSY.fa

Step 2: Aligning Sequences and Sorting BAM Files
bwa mem -t 4 UU_Cfam_GSD_1.0_ROSY.fa DOGS-Gen-9-L2_S237_L008_R2_001.fastq.gz | \
samtools view -S -b | \
samtools sort -o DOGS-Gen-9-L2_S237_L008_R2_001_sorted.bam

Step 3: Removing Duplicates
java -jar $PICARD MarkDuplicates \
    INPUT=DOGS-Gen-9-L2_S237_L008_R2_001_sorted.bam \
    OUTPUT=dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted.bam \
    M=dedup_metrics.txt
    
Step 4: Adding Read Group Information
java -jar $PICARD AddOrReplaceReadGroups \
    I=dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted.bam \
    O=dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted_with_RG.bam \
    RGID=group1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=sample
    
Step 5: Variant Calling in GVCF Mode
gatk --java-options -Xmx4G HaplotypeCaller \
    -R UU_Cfam_GSD_1.0_ROSY.fa \
    -I dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted_with_RG.bam \
    -O dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted_with_RG.g.vcf.gz \
    -bamout dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted_with_RG.out.bam \
    -ERC GVCF
    
Step 6: Creating GenomicsDB and Genotyping
Create GenomicsDB:
gatk --java-options -Xmx4G GenomicsDBImport \
    -R UU_Cfam_GSD_1.0_ROSY.fa \
    -V dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted_with_RG.g.vcf.gz \
    --genomicsdb-workspace-path dogs_db \
    --intervals chr
Genotype the Variants:
gatk --java-options -Xmx4G GenotypeGVCFs \
    -R UU_Cfam_GSD_1.0_ROSY.fa \
    -V gendb://dogs_db \
    -O sample.vcf
    
🧠 Additional Notes on Indel Comparison

When analyzing insertions and deletions (indels), it’s important to consider their left-alignment, as different indel representations may result in the same sequence. Variants may need to be normalized using tools such as bcftools norm to ensure consistent representation across datasets.

📊 Files Produced

The pipeline generates several outputs, including but not limited to:

BAM Files: dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted.bam
VCF Files: dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted_with_RG.g.vcf.gz
Logs: GenomicsDBImport.out, GenotypeGVCFs.out
Metrics: dedup_metrics.txt

📄 Batch Processing with Shell Scripts

This repository includes preconfigured shell scripts for running GATK jobs. These scripts allow users to easily set up and execute the steps in parallel, optimizing large datasets:

run_gatk.sh
run_genotype.sh

🧑‍🔬 Why This Project Is Significant

Data Handling: Processed raw sequence data, ensuring clean and high-quality results.
Variant Calling Expertise: Applied GATK best practices to call and genotype variants, ensuring results align with industry standards.
Scalability: The pipeline scales to handle multiple samples and genomic intervals, useful for large-scale studies.
Automation: Used shell scripts for automation, ensuring repeatability and efficiency across different environments.

🔭 Future Work & Next Steps

This project is ongoing. I am actively working and planning to work on the following improvements and extensions:

Quality Control Analysis: Integrating FastQC and MultiQC for pre- and post-alignment quality checks.
Variant Filtering & Annotation: Using GATK VariantFiltration and ANNOVAR or SnpEff to prioritize biologically relevant variants.
Workflow Management: Transitioning from manual scripting to a workflow management system like Snakemake or Nextflow for reproducibility and scalability.
Parallelization & Optimization: Enhancing compute efficiency using GNU Parallel and optimizing memory and thread usage.
Visualization: Generating plots for variant distribution using vcftools, bcftools stats, and custom Python notebooks for exploratory data analysis.
Multi-Sample Comparison: Incorporating additional samples to explore population-level variant trends and perform comparative genomics.
