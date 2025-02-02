suppressMessages(library(tidyverse))

flagstat_path = "output/multiqc_data/multiqc_samtools_flagstat.txt"
depth_path = "output/depth_concat.txt"

flagstat <- read.table(flagstat_path,header=T,sep='\t')
flagstat <- flagstat %>% 
    mutate(total_passed = total_passed/1e+06, properly.paired_passed = properly.paired_passed/1e+06, flagstat_total = flagstat_total/1e+06,
    mapped_passed = mapped_passed/1e+06, singletons_passed = singletons_passed/1e+06, duplicates_passed = duplicates_passed/1e+06)

depth <- read.table(depth_path,header=T,sep='\t')

flagstat %>% select(flagstat_total,mapped_passed,properly.paired_passed) %>% summary()

### Flagstat
p1 <- flagstat %>% ggplot(aes(x=flagstat_total)) + geom_boxplot() +
    xlab('Total reads (millions)') + theme_minimal() + xlim(c(600,1200)) + 
    theme(axis.text.y = element_blank())
p2 <- flagstat %>% ggplot(aes(x=mapped_passed)) + geom_boxplot() +
    xlab('Mapped (millions)') + theme_minimal()+ xlim(c(600,1200)) +
    theme(axis.text.y = element_blank())
p3 <- flagstat %>% ggplot(aes(x=properly.paired_passed)) + geom_boxplot() + 
    xlab('Properly paired (millions)') + theme_minimal()+ xlim(c(600,1200)) +
    theme(axis.text.y = element_blank())
# p4 <- flagstat %>% ggplot(aes(x=duplicates_passed)) + geom_boxplot() + 
#     ylab('Duplicates (millions)') + theme_minimal()
# p5 <- flagstat %>% ggplot(aes(x=singletons_passed)) + geom_boxplot() + 
#     ylab('Singletons (millions)') + theme_minimal()

library(gridExtra)
grid.arrange(p1, p2, p3,ncol = 1)

### Average depth
summary(depth)

depth_intervals <- depth %>% select(-average_depth) %>% pivot_longer(cols = -sample,
                                      names_to = 'group', 
                                      values_to = 'depth'
                                      )
avg_depth_plot <- depth %>% ggplot(aes(y=average_depth)) + geom_boxplot()
avg_depth_plot

depth_percent <- depth_intervals %>% ggplot(aes(y= group, x=depth)) + 
    geom_boxplot() + 
    theme_minimal() +
    scale_y_discrete(labels=c("percentage_above_30" = "30x", "percentage_above_20" = "20x",
                                "percentage_above_10" = "10x")) +
    ylab('') +
    xlab('% coverage')
depth_percent


### PSC

psc <- read.table('output/total_psc.stats', sep='\t')
colnames(psc) <- c('PSC','id', 'sample', 'nRefHom', 'nNonRefHom', 'nHets', 
                   'nTransitions', 'nTransversions', 'nIndels', 'average_depth',
                   'nSingletons', 'nHapRef', 'nHapAlt', 'nMissing'
)






