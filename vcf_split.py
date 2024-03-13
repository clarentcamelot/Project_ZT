import os
import argparse
import gzip

def split_vcf_by_chrom(input_vcf):
    chrom_files = {}

    filename = os.path.splitext(os.path.basename(input_vcf))[0]

    with gzip.open(input_vcf, "rt") as vcf_file:
        for line in vcf_file:
            if line.startswith("#"):
                for chrom_file in chrom_files.values():
                    chrom_file.write(line)
            else:
                chrom = line.split("\t")[0]
                if chrom not in chrom_files:
                    chrom_files[chrom] = gzip.open(f"{filename}.{chrom}.vcf.gz", "wt")
                chrom_files[chrom].write(line)

    for chrom_file in chrom_files.values():
        chrom_file.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Split VCF file by chromosome")
    parser.add_argument("-i", "--input", required=True, help="Input VCF.gz file path")
    args = parser.parse_args()

    input_vcf = args.input

    if not os.path.exists(input_vcf):
        print("Error: Input VCF file not found.")
        exit(1)

    split_vcf_by_chrom(input_vcf)
    print("VCF file has been split by chromosome.")
