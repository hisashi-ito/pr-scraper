#! /bin/bash
for site in alibaba amazon apple baidu dmm docomo facebook google kddi line mercari microsoft rakuten softbank yahoo
do
    input="${site}_pr.tsv"
    cat ${input} | ./tsv2input.rb ${site} >> ./pr.tsv
done
