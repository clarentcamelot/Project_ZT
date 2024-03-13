#!/bin/bash

#SBATCH --cpus-per-task=8
#SBATCH --ntasks=8
#SBATCH -J GVCF_tan
#SBATCH -o fin.out
#SBATCH -e fin.err
#SBATCH --nodelist=node[36-37]

Ref="/data/proj2/home/students/h.tan/plantPathogenData/Ztritici/ZT_ref/GCF_000219625.1_MYCGR_v2.0_genomic_headerChange.fna"


cd /data/proj2/home/students/h.tan/plantPathogenData/Ztritici
cd ZT_VCF_fin
gatk CombineGVCFs \
   -R Ref \
   --variant ../ZT_GVCF/ZT_001.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_001.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_002.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_003.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_004.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_005.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_006.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_007.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_008.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_009.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_010.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_011.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_012.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_013.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_014.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_015.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_016.g.vcf.gz \   
   --variant ../ZT_GVCF/ZT_017.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_018.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_019.g.vcf.gz \
   --variant ../ZT_GVCF/ZT_020.g.vcf.gz \
   -O ZT_cohort.g.vcf.gz

gatk --java-options "-Xmx4g" GenotypeGVCFs \
   -R Ref \
   -V ZT_cohort.g.vcf.gz \
   -O ZT_final.vcf.gz

gatk --java-options "-Xmx4g" GenotypeGVCFs \
   -R Ref \
   -V ZT_cohort.g.vcf.gz \
   --include-non-variant-sites \
   --sites-only-vcf-output \
   -O ZT_final.allsites.nogeno.vcf.gz  

bcftools view --apply-filters .,PASS ZT_final.vcf.gz --genotype ^miss --include 'TYPE="snp"' --output-type z --output-file ZT_final.filtered.vcf.gz

bcftools view --apply-filters .,PASS ZT_final.allsites.nogeno.vcf.gz --genotype ^miss --include 'TYPE="snp"' --output-type z --output-file ZT_final.allsites.nogeno.filtered.vcf.gz
    

zcat ZT_final.allsites.nogeno.filtered.vcf.gz | vcf2bed > ZT_final.allsites.nogeno.filtered.bed

bedtools merge -i ZT_final.allsites.nogeno.filtered.bed > ZT_final.mask.bed

rm ZT_final.allsites.nogeno.filtered.bed
gzip ZT_final.mask.bed
