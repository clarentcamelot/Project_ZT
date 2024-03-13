#!/bin/bash

#SBATCH --cpus-per-task=8
#SBATCH --ntasks=8
#SBATCH -J GVCF_tan
#SBATCH -o GVCF_tan.out
#SBATCH -e GVCF_tan.err
#SBATCH --nodelist=node[36-37]

Ref="/data/proj2/home/students/h.tan/plantPathogenData/Ztritici/ZT_ref/GCF_000219625.1_MYCGR_v2.0_genomic_headerChange.fna"

conda activate gatk4
cd /data/proj2/home/students/h.tan/plantPathogenData/Ztritici
cd ZT_GVCF_Retry
for bam_file in ../ZT_bams/ZT_*.bam; do
    filename=$(basename "$bam_file".bam)
    gatk  HaplotypeCaller \
	  -R Ref\
	  -I "$bam_file" \
	  -O "${filename}.g.vcf.gz" \
	  -ERC GVCF --output-mode EMIT_ALL_SITES 
done
