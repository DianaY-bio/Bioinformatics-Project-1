#!/bin/bash
#$ -N gatk_job                      # Name your job (can be anything)
#$ -cwd                             # Run in your current folder
#$ -o output.log                    # Save output messages in this file
#$ -e error.log                     # Save error messages in this file
#$ -l h_rt=02:00:00                 # Max run time: 2 hours
#$ -l h_data=6G                     # Memory: reserve 6 GB (you need 4 GB)
#$ -pe shared 1                     # Use 1 CPU core


# Example (only if your cluster uses modules):
# module load gatk/4.2.0.0

# Your actual GATK command:
gatk --java-options "-Xmx4G" HaplotypeCaller \
-R UU_Cfam_GSD_1.0_ROSY.fa \
-I dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted_with_RG.bam \
-O dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted_with_RG.g.vcf.gz \
-bamout dedup_DOGS-Gen-9-L2_S237_L008_R2_001_sorted_with_RG.out.bam \
-ERC GVCF
