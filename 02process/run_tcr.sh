#!/bin/bash

wk=/diskmnt/Projects/Users/s.yingduo/06MMRF/Cellranger
logs=/diskmnt/Projects/Users/s.yingduo/06MMRF/Cellranger/logs
fastq=/diskmnt/Projects/Users/s.yingduo/06MMRF/Fastq
chemistry=TR

ls $fastq | grep "_TCR" | tail -15 | while read id; do
    #cat not.txt | grep "_TCR" | while read id; do
    cd $wk
    rm -rf $id
    nohup /diskmnt/Projects/Users/rliu/Software/cellranger-7.1.0/cellranger vdj \
        --id $id \
        --reference /diskmnt/Datasets_public/Reference/Cellranger-VDJ/refdata-cellranger-vdj-GRCh38-alts-ensembl-5.0.0 \
        --fastqs $fastq/$id \
        --localcores 20 \
        --localmem 32 \
        --chain $chemistry >${logs}/${id}.worklog &
done
