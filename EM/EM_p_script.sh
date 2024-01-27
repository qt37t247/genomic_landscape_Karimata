#!/bin/bash
#PBS -N T2_EM_pca
#PBS -l select=1:ncpus=20:mem=180G:mpiprocs=20:ompthreads=20
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o out-run.txt
#PBS -q normal

module load miniforge3
conda activate pixy

cd /scratch/users/nus/dbstq/T2_EM/results/GCA_035046505/

plink --vcf T2_EM_raw.vcf.gz --threads 120 --allow-extra-chr --allow-no-sex --remove remove.txt --out EM --recode vcf

awk '{gsub(/CM068524.1/, "1"); gsub(/CM068525.1/, "2"); gsub(/CM068526.1/, "3"); gsub(/CM068527.1/, "4"); gsub(/CM068528.1/, "5"); gsub(/CM068529.1/, "6"); gsub(/CM068530.1/, "7"); gsub(/CM068531.1/, "8"); gsub(/CM068532.1/, "9"); gsub(/CM068533.1/, "10"); gsub(/CM068534.1/, "11"); gsub(/CM068535.1/, "12"); gsub(/CM068536.1/, "13"); gsub(/CM068537.1/, "14"); gsub(/CM068538.1/, "15"); gsub(/CM068539.1/, "16"); print;}' EM.vcf > EM_renamed.vcf

rm EM.vcf

vcftools --vcf EM_renamed.vcf --max-maf 0 --recode --stdout | bgzip -c > EM_invariant.vcf.gz

vcftools --vcf EM_renamed.vcf --mac 1 --recode --stdout | bgzip -c > EM_variant.vcf.gz

rm EM_renamed.vcf

plink --vcf EM_variant.vcf.gz --threads 20 --allow-extra-chr --allow-no-sex --geno 0.2 --out EM_g2 --recode vcf bgz

tabix EM_invariant.vcf.gz

tabix EM_g2.vcf.gz

bcftools concat --threads 20 --allow-overlaps EM_g2.vcf.gz EM_invariant.vcf.gz -O z -o EM_filtered.vcf.gz

tabix EM_filtered.vcf.gz

pixy --stats pi fst dxy --vcf EM_filtered.vcf.gz --populations EM_popfile.txt --window_size 10000 --n_cores 20

plink2 --vcf EM_g2.vcf.gz --threads 20 --allow-extra-chr --allow-no-sex --set-all-var-ids @:# --out EM_g2 --recode vcf

plink --vcf EM_g2.vcf --threads 20 --allow-extra-chr --allow-no-sex --geno 0 --out EM_g0 --recode vcf

plink --vcf EM_g2.vcf --threads 20 --allow-extra-chr --allow-no-sex --maf 0.05 --out EM_g2m5 --recode vcf

plink --vcf EM_g0.vcf --threads 20 --allow-extra-chr --allow-no-sex --maf 0.05 --out EM_g0m5 --recode vcf

plink2 --vcf EM_g2.vcf --threads 20 --allow-extra-chr --allow-no-sex --indep-pairwise 50 10 0.01 --bad-ld

plink --vcf EM_g2.vcf --extract plink2.prune.in --allow-extra-chr --allow-no-sex --out EM_g2L --recode vcf

plink2 --vcf EM_g0.vcf --threads 20 --allow-extra-chr --allow-no-sex --indep-pairwise 50 10 0.01 --bad-ld

plink --vcf EM_g0.vcf --extract plink2.prune.in --allow-extra-chr --allow-no-sex --out EM_g0L --recode vcf

plink2 --vcf EM_g2m5.vcf --threads 20 --allow-extra-chr --allow-no-sex --indep-pairwise 50 10 0.01 --bad-ld

plink --vcf EM_g2m5.vcf --extract plink2.prune.in --allow-extra-chr --allow-no-sex --out EM_g2m5L --recode vcf

plink2 --vcf EM_g0m5.vcf --threads 20 --allow-extra-chr --allow-no-sex --indep-pairwise 50 10 0.01 --bad-ld

plink --vcf EM_g0m5.vcf --extract plink2.prune.in --allow-extra-chr --allow-no-sex --out EM_g0m5L --recode vcf

for i in *.vcf
do
plink --vcf $i --threads 20 --allow-extra-chr --allow-no-sex --pca --out ${i}_pca
done

plink --vcf EM_g2m5L.vcf --threads 20 --allow-extra-chr --allow-no-sex --out EM_adm --recode12

for K in 1 2 3 4 5
do
/scratch/users/nus/dbstq/admixture -j20 --cv EM_adm.ped $K | tee log${K}.out
done

