#! /bin/bash
cmd="ruby ../bin/pr_scraper.rb"
site="softbank"
from="20200401"
to="20200731"

#for site in softbank baidu rakuten docomo mercari dmm line cyberagent apple Yahoo alibaba microsoft amazon google kddi facebook microsoft
for site in amazon google kddi facebook microsoft
do
    output="./${site}_pr.tsv"
    main_cmd="${cmd} -s ${site} -o ${output} -f ${from} -t ${to}"
    eval ${main_cmd}
done
