#!/bin/bash

## run
cat data_tracking.tsv data_tracking_new.tsv >tmp
cut tmp -f 1 | awk '!x[$0]++' | while read id; do
    grep $id tmp | grep "5PscRNA" >>tmp.txt
    grep $id tmp | grep "BCR" >>tmp.txt
    grep $id tmp | grep "TCR" >>tmp.txt
done

rm -rf tmp
mv tmp.txt data_tracking.tsv
