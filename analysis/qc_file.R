#!bin/Rscript

## set up diretory and library
setwd("/diskmnt/Projects/Users/s.yingduo/06MMRF/analysis/new")
library(stringr)
path <- "/diskmnt/Projects/MMRF_analysis_2/CID005/Cellranger"

## make qc_5p.txt
p5 <- list()
for (i in list.files(path)[str_detect(list.files(path), "5P")]) {
    file <- paste0(path, "/", i, "/outs/metrics_summary.csv")
    tmp <- read.csv(file, header = T)
    tmp <- tmp[, c("Estimated.Number.of.Cells", "Mean.Reads.per.Cell", "Median.Genes.per.Cell")]
    for (j in 1:ncol(tmp)) {
        tmp[, j] <- as.numeric(gsub(",", "", tmp[, j]))
    }
    sample_id <- i
    tmp <- cbind(sample_id, tmp)
    p5 <- rbind(p5, tmp)
}
dim(p5)

## make qc_bcr.txt
bcr <- list()
for (i in list.files(path)[str_detect(list.files(path), "BCR")]) {
    file <- paste0(path, "/", i, "/outs/metrics_summary.csv")
    tmp <- read.csv(file, header = T)
    tmp <- tmp[, c("Estimated.Number.of.Cells", "Mean.Read.Pairs.per.Cell", "Number.of.Cells.With.Productive.V.J.Spanning.Pair")]
    for (j in 1:ncol(tmp)) {
        tmp[, j] <- as.numeric(gsub(",", "", tmp[, j]))
    }
    sample_id <- i
    tmp <- cbind(sample_id, tmp)
    bcr <- rbind(bcr, tmp)
}
dim(bcr)

## make qc_tcr.txt
tcr <- list()
for (i in list.files(path)[str_detect(list.files(path), "TCR")]) {
    file <- paste0(path, "/", i, "/outs/metrics_summary.csv")
    tmp <- read.csv(file, header = T)
    tmp <- tmp[, c("Estimated.Number.of.Cells", "Mean.Read.Pairs.per.Cell", "Number.of.Cells.With.Productive.V.J.Spanning.Pair")]
    for (j in 1:ncol(tmp)) {
        tmp[, j] <- as.numeric(gsub(",", "", tmp[, j]))
    }
    sample_id <- i
    tmp <- cbind(sample_id, tmp)
    tcr <- rbind(tcr, tmp)
}
dim(tcr)


## cell number in 3 assays
dat <- rbind(p5[, 1:2], bcr[, 1:2], tcr[, 1:2])
sample_name <- character()
assay <- character()
for (i in dat$sample_id) {
    if (nchar(word(i, sep = fixed("_"), 1)) != 8) {
        sample_name <- c(sample_name, word(i, sep = fixed("_"), 1))
        assay <- c(assay, word(i, sep = fixed("_"), 2))
    } else {
        sample_name <- c(sample_name, word(i, sep = fixed("_"), 1, 2))
        assay <- c(assay, word(i, sep = fixed("_"), 3))
    }
}

dat <- cbind(dat, sample_name, assay)
which(table(sample_name) != 3)


## output files
write.table(p5, "qc_5p.txt", sep = "\t", row.names = F, quote = F)
write.table(bcr, "qc_bcr.txt", sep = "\t", row.names = F, quote = F)
write.table(tcr, "qc_tcr.txt", sep = "\t", row.names = F, quote = F)
write.table(dat, "cell_number.txt", sep = "\t", row.names = F, quote = F)
