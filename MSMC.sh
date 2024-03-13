#!/bin/bash

#SBATCH --cpus-per-task=8
#SBATCH --ntasks=8
#SBATCH -J MSMC_tan
#SBATCH -o MSMC.out
#SBATCH -e MSMC.err
#SBATCH --nodelist=node[36-37]

Ref="/data/proj2/home/students/h.tan/plantPathogenData/Ztritici/ZT_ref/GCF_000219625.1_MYCGR_v2.0_genomic_headerChange.fna"

cd /data/proj2/home/students/h.tan/plantPathogenData/Ztritici
cd ZT_VCF_fin
for i in $(seq -w 1 20); do
  indv = $(printf "ZT_0" $i)
  echo "Extracting sample $indv..."
  bcftools view --samples $indv ZT_final.filtered.vcf.gz --output-type z --output-file $indv.vcf.gz
done

for input in  ZT_final.0*.vcf.gz; do
    python vcf_split.py -i $input
done


for i in $(seq 1 21); do
   python3 generate_multihetsep.py --mask=ZT_final.mask.sorted.bed.gz \
  ZT_final.001.vcf.$i.vcf.gz \
  ZT_final.002.vcf.$i.vcf.gz \
  ZT_final.003.vcf.$i.vcf.gz \
  ZT_final.004.vcf.$i.vcf.gz \
  ZT_final.005.vcf.$i.vcf.gz \
  ZT_final.006.vcf.$i.vcf.gz \
  ZT_final.007.vcf.$i.vcf.gz \
  ZT_final.008.vcf.$i.vcf.gz \
  ZT_final.009.vcf.$i.vcf.gz \
  ZT_final.010.vcf.$i.vcf.gz \
  ZT_final.011.vcf.$i.vcf.gz \
  ZT_final.012.vcf.$i.vcf.gz \
  ZT_final.013.vcf.$i.vcf.gz \
  ZT_final.014.vcf.$i.vcf.gz \
  ZT_final.015.vcf.$i.vcf.gz \
  ZT_final.016.vcf.$i.vcf.gz \
  ZT_final.017.vcf.$i.vcf.gz \
  ZT_final.018.vcf.$i.vcf.gz \
  ZT_final.019.vcf.$i.vcf.gz \
  ZT_final.020.vcf.$i.vcf.gz  > ZT_final.$i.msmc
done




      