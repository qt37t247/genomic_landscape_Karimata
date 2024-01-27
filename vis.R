library(tidyverse)
library(ggplot2)

pixy_to_long <- function(pixy_files){
  
  pixy_df <- list()
  
  for(i in 1:length(pixy_files)){
    
    stat_file_type <- gsub(".*_|.txt", "", pixy_files[i])
    
    if(stat_file_type == "pi"){
      
      df <- read_delim(pixy_files[i], delim = "\t")
      df <- df %>%
        gather(-pop, -window_pos_1, -window_pos_2, -chromosome,
               key = "statistic", value = "value") %>%
        rename(pop1 = pop) %>%
        mutate(pop2 = NA)
      
      pixy_df[[i]] <- df
      
      
    } else{
      
      df <- read_delim(pixy_files[i], delim = "\t")
      df <- df %>%
        gather(-pop1, -pop2, -window_pos_1, -window_pos_2, -chromosome,
               key = "statistic", value = "value")
      pixy_df[[i]] <- df
      
    }
    
  }
  
  bind_rows(pixy_df) %>%
    arrange(pop1, pop2, chromosome, window_pos_1, statistic)
  
}

pixy_files <- list.files(full.names = TRUE)
pixy_df <- pixy_to_long(pixy_files[-4])

#Filter non-chromosome sites
pixy_df <- subset(pixy_df, chromosome %in% c('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16'))

#Pi
pixy_pi <- subset(pixy_df, statistic == 'avg_pi')
pixy_pi[,"pos"] <- (pixy_pi$window_pos_1 +pixy_pi$window_pos_2)/2
pixy_pi$chromosome <- as.numeric(pixy_pi$chromosome)


pi_sumatra <- subset(pixy_pi, pop1 == 'Sumatera')
pi_bangka <- subset(pixy_pi, pop1 == 'Bangka')
pi_belitung <- subset(pixy_pi, pop1 == 'Belitung')
pi_jemaja <- subset(pixy_pi, pop1 == 'Jemaja')
pi_borneo <- subset(pixy_pi, pop1 == 'Borneo')
pi_serasan <- subset(pixy_pi, pop1 == 'Serasan')
pi_siantan <- subset(pixy_pi, pop1 == 'Siantan')

library(qqman)
pdf("pi_sumatra.pdf")
manhattan(pi_sumatra,chr="chromosome",bp="pos", p="value", snp="pop1",col=c("black","gray54"), logp=F,  suggestiveline=F, genomewideline=F, ylab="pi", ylim=c(0,0.1)) 
dev.off()

pdf("pi_bangka.pdf")
manhattan(pi_bangka,chr="chromosome",bp="pos", p="value", snp="pop1",col=c("black","gray54"), logp=F,  suggestiveline=F, genomewideline=F, ylab="pi", ylim=c(0,0.1)) 
dev.off()

pdf("pi_belitung.pdf")
manhattan(pi_belitung,chr="chromosome",bp="pos", p="value", snp="pop1",col=c("black","gray54"), logp=F,  suggestiveline=F, genomewideline=F, ylab="pi", ylim=c(0,0.1)) 
dev.off()

pdf("pi_jemaja.pdf")
manhattan(pi_jemaja,chr="chromosome",bp="pos", p="value", snp="pop1",col=c("black","gray54"), logp=F,  suggestiveline=F, genomewideline=F, ylab="pi", ylim=c(0,0.1)) 
dev.off()

pdf("pi_borneo.pdf")
manhattan(pi_borneo,chr="chromosome",bp="pos", p="value", snp="pop1",col=c("black","gray54"), logp=F,  suggestiveline=F, genomewideline=F, ylab="pi", ylim=c(0,0.1)) 
dev.off()

pdf("pi_serasan.pdf")
manhattan(pi_serasan,chr="chromosome",bp="pos", p="value", snp="pop1",col=c("black","gray54"), logp=F,  suggestiveline=F, genomewideline=F, ylab="pi", ylim=c(0,0.1)) 
dev.off()

pdf("pi_siantan.pdf")
manhattan(pi_siantan,chr="chromosome",bp="pos", p="value", snp="pop1",col=c("black","gray54"), logp=F,  suggestiveline=F, genomewideline=F, ylab="pi", ylim=c(0,0.1)) 
dev.off()

#Subset to pairwise
pixy_dxy <- subset(pixy_df, statistic == c('avg_dxy'))
pixy_dxy[,"pos"] <- (pixy_dxy$window_pos_1 + pixy_dxy$window_pos_2)/2
pixy_dxy$chromosome <- as.numeric(pixy_dxy$chromosome)

dxy_sumatra_borneo <- subset(pixy_dxy, pop1 == 'Sumatera' & pop2 == 'Borneo')
dxy_sumatra_bangka <- subset(pixy_dxy, pop1 == 'Bangka' & pop2 == 'Sumatera')
dxy_sumatra_belitung <- subset(pixy_dxy, pop1 == 'Belitung' & pop2 == 'Sumatera')
dxy_sumatra_jemaja <- subset(pixy_dxy, pop1 == 'Jemaja' & pop2 == 'Sumatera')

pdf("dxy_sumatra_jemaja.pdf")
manhattan(dxy_sumatra_jemaja,chr="chromosome",bp="pos", p="value", snp="pop1",col=c("black","gray54"), logp=F,  suggestiveline=F, genomewideline=F, ylab="pi", ylim=c(0,0.2)) 
dev.off()

pdf("dxy_sumatra_bangka.pdf")
manhattan(dxy_sumatra_bangka,chr="chromosome",bp="pos", p="value", snp="pop1",col=c("black","gray54"), logp=F,  suggestiveline=F, genomewideline=F, ylab="pi", ylim=c(0,0.2)) 
dev.off()

pdf("dxy_sumatra_belitung.pdf")
manhattan(dxy_sumatra_belitung,chr="chromosome",bp="pos", p="value", snp="pop1",col=c("black","gray54"), logp=F,  suggestiveline=F, genomewideline=F, ylab="pi", ylim=c(0,0.2)) 
dev.off()



