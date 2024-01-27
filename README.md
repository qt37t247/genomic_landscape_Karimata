# genomic_landscape_Karimata
Tier 2 project discovering genomic patterns of introgression across the Karimata Strait  

## Programs used 

Variant calling: SNPArcher (https://github.com/harvardinformatics/snpArcher)

Data filtering and PCA: PLINK (https://www.cog-genomics.org/plink/1.9/), PLINK2 (https://www.cog-genomics.org/plink/2.0/), vcftools (https://vcftools.sourceforge.net/), and bcftools (https://samtools.github.io/bcftools/bcftools.html).

Population genetic clustring: ADMIXTURE (https://dalexander.github.io/admixture/download.html)

Nucleotide diversity, Fst and Pixy: Pixy (https://pixy.readthedocs.io/en/latest/installation.html)


As Pixy requires python between 3.6 and 3.7, whereas SNPArcher uses 3.11, we need to create two conda environments for the program installations.

## Workflow used

In this project, we sampled multiple small vertebrate species (abbreviations used across the analyses):

Hose's frog, _Odorrana hosii_ (OH)

Genus _Chalcorana_ (CH)

Whitehead's spiny rat, _Maxomys whiteheadi_ (MW)

Many-lined sun skink, _Eutropis multifasciata_ (EM)

......


For each species, we:

1. called genomic variants (SNPArcher, configuration folder as "config" and script to proceed as "XX.sh").
   
2. filtered SNP, scanned genomic landscape, and ran PCA and ADMIXTURE ("XX_p_script.sh", "remove.txt", "XX_popfile.txt").

3. plotted pi, Fst, and Dxy across the genomic landscape ("vis.R")
