# genomic_landscape_Karimata
Tier 2 project discovering genomic patterns of introgression across the Karimata Strait  

## Programs used 

Variant calling: SNPArcher (https://github.com/harvardinformatics/snpArcher)

Data filtering and PCA: PLINK (https://www.cog-genomics.org/plink/1.9/)

Population genetic clustring: ADMIXTURE (https://dalexander.github.io/admixture/download.html)

Nucleotide diversity, Fst and Pixy: Pixy (https://pixy.readthedocs.io/en/latest/installation.html)


As Pixy requires python between 3.6 and 3.7, need to create two conda environments for the program installations.

## Workflow used

In this project, we sampled multiple small vertebrate species (abbreviations used across the analyses):

Hose's frog, _Odorrana hosii_ (OH)

Genus _Chalcorana_ (CH)

Whitehead's spiny rat, _Maxomys whiteheadi_ (MW)

Many-lined sun skink, _Eutropis multifasciata_ (EM)

......


For each species, we:

1. called genomic variants (SNPArcher, configuration folder as "config" and script to proceed as "XX.sh").
   
2. SNP filtering (PLINK, script in "XX_p_script.sh").
   
3. inspected individuals' differentiation (PCA in PLINK) and ancestries (ADMIXTURE) (see "XX_p_script.sh").

4. scanned nucleotide diversity, Fst and Pixy across the genomic landscape (under construction...). 
