## 🔬 Overview

This repository provides a pipeline for analyzing MMRF single-cell sequencing data. The workflow begins with raw FASTQ files and proceeds through preprocessing to generate aligned BAM files.

The code is organized into three main modules:

- `01pre_folder/`: Generates a data tracking table for managing metadata and file paths.
- `02process/`: Processes 5' gene expression, BCR, and TCR libraries.
- `03analysis/`: Produces QC bar plots for visualizing the number of cells, genes, and reads across samples.

Each folder is numbered to reflect the recommended execution order.
