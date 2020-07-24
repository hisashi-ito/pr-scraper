#! /bin/bash
cmd="ruby ../bin/pr_scraper.rb"
site="softbank"
from="20200401"
to="20200630"

# ソフトバンク
output="softbank_pr.tsv"
main_cmd="${cmd} -s ${site} -o ${output} -f ${from} -t ${to}"
echo ${main_cmd}
eval ${main_cmd}

# 百度
site="baidu"
output="baidu_pr.tsv"
main_cmd="${cmd} -s ${site} -o ${output} -f ${from} -t ${to}"
echo ${main_cmd}
eval ${main_cmd}

# 楽天
site="rakuten"
output="rakuten_pr.tsv"
main_cmd="${cmd} -s ${site} -o ${output} -f ${from} -t ${to}"
echo ${main_cmd}
eval ${main_cmd}
