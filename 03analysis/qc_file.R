#!/usr/bin/env Rscript

library(optparse)
library(stringr)

# Define command-line options
option_list <- list(
    make_option(c("-o", "--outdir"), type = "character", help = "Output directory", metavar = "character"),
    make_option(c("-c", "--cellranger"), type = "character", help = "Path to Cellranger data", metavar = "character")
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

if (is.null(opt$outdir) || is.null(opt$cellranger)) {
    print_help(opt_parser)
    stop("Both -o and -c arguments must be provided.", call. = FALSE)
}

outdir <- opt$outdir
cellranger_path <- opt$cellranger
setwd(outdir)

## 5P QC
p5 <- list()
for (i in list.files(cellranger_path)[str_detect(list.files(cellranger_path), "5P")]) {
    file <- file.path(cellranger_path, i, "outs", "metrics_summary.csv")
    tmp <- read.csv(file, header = TRUE)
    tmp <- tmp[, c("Estimated.Number.of.Cells", "Mean.Reads.per.Cell", "Median.Genes.per.Cell")]
    tmp <- apply(tmp, 2, function(x) as.numeric(gsub(",", "", x)))
    tmp <- as.data.frame(tmp)
    tmp$sample_id <- i
    p5 <- rbind(p5, tmp)
}
p5 <- as.data.frame(p5)

## BCR QC
bcr <- list()
for (i in list.files(cellranger_path)[str_detect(list.files(cellranger_path), "BCR")]) {
    file <- file.path(cellranger_path, i, "outs", "metrics_summary.csv")
    tmp <- read.csv(file, header = TRUE)
    tmp <- tmp[, c("Estimated.Number.of.Cells", "Mean.Read.Pairs.per.Cell", "Number.of.Cells.With.Productive.V.J.Spanning.Pair")]
    tmp <- apply(tmp, 2, function(x) as.numeric(gsub(",", "", x)))
    tmp <- as.data.frame(tmp)
    tmp$sample_id <- i
    bcr <- rbind(bcr, tmp)
}
bcr <- as.data.frame(bcr)

## TCR QC
tcr <- list()
for (i in list.files(cellranger_path)[str_detect(list.files(cellranger_path), "TCR")]) {
    file <- file.path(cellranger_path, i, "outs", "metrics_summary.csv")
    tmp <- read.csv(file, header = TRUE)
    tmp <- tmp[, c("Estimated.Number.of.Cells", "Mean.Read.Pairs.per.Cell", "Number.of.Cells.With.Productive.V.J.Spanning.Pair")]
    tmp <- apply(tmp, 2, function(x) as.numeric(gsub(",", "", x)))
    tmp <- as.data.frame(tmp)
    tmp$sample_id <- i
    tcr <- rbind(tcr, tmp)
}
tcr <- as.data.frame(tcr)

## Combine
dat <- rbind(
    p5[, c("sample_id", "Estimated.Number.of.Cells")],
    bcr[, c("sample_id", "Estimated.Number.of.Cells")],
    tcr[, c("sample_id", "Estimated.Number.of.Cells")]
)

sample_name <- character()
assay <- character()
for (i in dat$sample_id) {
    parts <- strsplit(i, "_")[[1]]
    if (nchar(parts[1]) != 8) {
        sample_name <- c(sample_name, parts[1])
        assay <- c(assay, parts[2])
    } else {
        sample_name <- c(sample_name, paste(parts[1], parts[2], sep = "_"))
        assay <- c(assay, parts[3])
    }
}
dat$sample_name <- sample_name
dat$assay <- assay

## Output
write.table(p5, "qc_5p.txt", sep = "\t", row.names = FALSE, quote = FALSE)
write.table(bcr, "qc_bcr.txt", sep = "\t", row.names = FALSE, quote = FALSE)
write.table(tcr, "qc_tcr.txt", sep = "\t", row.names = FALSE, quote = FALSE)
write.table(dat, "cell_number.txt", sep = "\t", row.names = FALSE, quote = FALSE)
