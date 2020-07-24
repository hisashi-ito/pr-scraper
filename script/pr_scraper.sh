#! /bin/bash
cmd="ruby ../bin/pr_scraper.rb"
site="softbank"
from="20200401"
to="20200630"
output="softbank_pr.tsv"
main_cmd="${cmd} -s ${site} -o ${output} -f ${from} -t ${to}"
echo ${main_cmd}
eval ${main_cmd}

site="baidu"
output="baidu_pr.tsv"
main_cmd="${cmd} -s ${site} -o ${output} -f ${from} -t ${to}"
echo ${main_cmd}
eval ${main_cmd}
