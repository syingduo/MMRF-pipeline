#!/bin/bash

wk=/diskmnt/Projects/Users/s.yingduo/06MMRF/Cellranger
logs=/diskmnt/Projects/Users/s.yingduo/06MMRF/Cellranger/logs
fastq=/diskmnt/Projects/Users/s.yingduo/06MMRF/Fastq
chemistry=SC5P-PE

ls $fastq | grep "_5P" | tail -23 | while read id; do
    cd $wk
    nohup /diskmnt/Software/cellranger-6.0.1/cellranger count \
        --id=$id \
        --fastqs=$fastq/$id \
        --transcriptome=/diskmnt/Software/cellranger-6.0.1/References/refdata-gex-GRCh38-2020-A \
        --chemistry=$chemistry \
        --jobmode=local \
        --localcores=20 \
        --localmem=32 >${logs}/${id}.worklog &
done
