#!/bin/bash

## run
mkdir -p Fastq/

cut data_tracking.tsv -f 1 | awk '!x[$0]++' | while read id; do
    echo -e "5P\nBCR\nTCR" | while read assay; do
        tmp=$(grep $id data_tracking.tsv | grep $assay)
        N=$(echo $?)
        if [[ $N -eq 0 ]]; then
            sample=${id}_$assay
            mkdir Fastq/$sample
            grep $id data_tracking.tsv | grep $assay | cut -f 5-7 | while read line; do
                r1=$(echo $line | cut -d " " -f 1)
                r2=$(echo $line | cut -d " " -f 2)
                dir=$(echo $line | cut -d " " -f 3)
                ln -s $dir/$r1 Fastq/$sample
                ln -s $dir/$r2 Fastq/$sample
            done

            n=$(ls Fastq/$sample | awk -F "_S" '{print $1}' | sort | uniq | wc -l)
            if [[ $n -ne 1 ]]; then
                new=$(ls Fastq/$sample | awk -F "_S" '{print $1}' | sort | uniq | head -1)
                ls Fastq/$sample >name1
                ls Fastq/$sample >name2
                mv name1 name2 Fastq/$sample
                cat Fastq/$sample/name2 | awk -F "_S" '{print $1}' | sort | uniq | while read old; do
                    sed -i s/$old/$new/ Fastq/$sample/name2
                done

                paste Fastq/$sample/name1 Fastq/$sample/name2 >Fastq/$sample/name
                cat Fastq/$sample/name | while read name; do
                    old=$(echo $name | cut -d " " -f 1 | cut -d . -f 1)
                    new=$(echo $name | cut -d " " -f 2 | cut -d . -f 1)
                    if [[ $old != $new ]]; then
                        old=$(echo $name | cut -d " " -f 1)
                        new=$(echo $name | cut -d " " -f 2)
                        mv Fastq/$sample/$old Fastq/$sample/$new
                    fi
                done
                rm -rf Fastq/$sample/name*
            fi
        fi

    done
done
