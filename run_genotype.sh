#!/bin/bash
#$ -N GenotypeGVCFs
#$ -cwd
#$ -o GenotypeGVCFs.out
#$ -e GenotypeGVCFs.err
#$ -l h_rt=5:00:00
#$ -l h_vmem=32G
#$ -pe shared 2
#$ -M dianayenokyan@g.ucla.edu
#$ -m bea

# 🔧 Load module system (this path works for most UCLA clusters)
source /u/local/Modules/default/init/modules.sh

# ✅ Load Java 17
module load java/jdk-17.0.12

# Set path to GATK
GATK_PATH="/u/local/apps/gatk/4.6.0.0/gatk"

# Run GenotypeGVCFs
$GATK_PATH GenotypeGVCFs \
   -R /u/home/y/yenokyan/Bioinformatics-Project-1/UU_Cfam_GSD_1.0_ROSY.fa \
   -V gendb:///u/home/y/yenokyan/Bioinformatics-Project-1/dogs_db \
   -O /u/home/y/yenokyan/Bioinformatics-Project-1/chr1_sample.vcf.gz


