#!/bin/bash
#PBS -N T2_EM_pca
#PBS -l select=1:ncpus=20:mem=180G:mpiprocs=20:ompthreads=20
#PBS -l walltime=24:00:00
#PBS -j oe
#PBS -o out-run.txt
#PBS -q normal

module load miniforge3
conda activate snparcher

cd /scratch/users/nus/dbstq/T2_EM/results/GCA_035046505/

plink --vcf T2_EM_raw.vcf.gz --threads 20 --allow-extra-chr --allow-no-sex --remove remove.txt --out EM --recode vcf

plink --vcf EM.vcf --threads 20 --allow-extra-chr --allow-no-sex --geno 0.1 --out EM_g1 --recode vcf

plink --vcf EM.vcf --threads 20 --allow-extra-chr --allow-no-sex --geno 0 --out EM_g0 --recode vcf

plink --vcf EM_g1.vcf --threads 20 --allow-extra-chr --allow-no-sex --out EM_g1_adm --recode12

plink --vcf EM_g0.vcf --threads 20 --allow-extra-chr --allow-no-sex --out EM_g0_adm --recode12

plink --vcf EM_g1.vcf --threads 20 --allow-extra-chr --allow-no-sex --pca --out EM_g1_pca

plink --vcf EM_g0.vcf --threads 20 --allow-extra-chr --allow-no-sex --pca --out EM_g0_pca

for i in *_adm.ped
 do 
 for K in 1 2 3 4 5 6 7 8 9 10
  do 
    /scratch/users/nus/dbstq/T2_EM/results/GCA_035046505/admixture/dist/admixture_linux-1.3.0/admixture -j20 --cv $i $K | tee log${K}.out 
  done
 grep -h CV log*.out > ${i}_cv.txt
done

 