#!/bin/bash

## run
path=/diskmnt/Projects/MMRF_primary_4/SR003597

rm -rf data_tracking_new.tsv
## make file
cat $path/Samplemap.csv | sed '1d' | while read id; do
    r1=$(echo $id | cut -d , -f 1)
    r2=$(echo $id | cut -d , -f 2)
    check1=$(grep $r1 $path/Match.ID.table.tsv | cut -f 1)
    check2=$(grep $r2 $path/Match.ID.table.tsv | cut -f 1)
    ## determine assay
    if [[ $check1 == $check2 ]]; then
        sample_id=$(echo $check1 | cut -d _ -f 1)
        name_length=$(echo $sample_id | wc -L)
        if [[ $name_length -eq 8 ]]; then
            sample_id=$(echo $check1 | cut -d _ -f 1,2)
        fi

        if [[ $check1 =~ "DC1G1Zf1_1Bc1_1" ]]; then
            assay="5PscRNA"
        elif [[ $check1 =~ "1Zft1" ]]; then
            assay="TCR"
        elif [[ $check1 =~ "1Zfb1" ]]; then
            assay="BCR"
        fi

        echo -e "${sample_id}\t${check1}\tCID-005\t$assay\t$r1\t$r2\t$path" >>data_tracking_new.tsv
    fi
done

## sort data_tracking.tsv
cut data_tracking_new.tsv -f 1 | awk '!x[$0]++' | while read id; do
    grep $id data_tracking_new.tsv | grep "5PscRNA" >>tmp.txt
    grep $id data_tracking_new.tsv | grep "BCR" >>tmp.txt
    grep $id data_tracking_new.tsv | grep "TCR" >>tmp.txt
done

mv tmp.txt data_tracking_new.tsv
