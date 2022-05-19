#! /bin/bash
#
# 【crawl】
#
#  留意点:
#　　　　　cron から実行時に chromedriver がないと言われる場合は
#          sudo cp /usr/local/bin/chromedriver /usr/bin へコピー
#          https://qiita.com/nwtgck/items/cfb5052135b8e64af01c
#
cmd="/usr/bin/ruby ../bin/pr_scraper.rb"
from=`date +%Y%m%d --date '300 day ago'`
to=`date '+%Y%m%d'`
for site in alibaba softbank baidu rakuten docomo mercari dmm line cyberagent apple yahoo alibaba microsoft amazon google kddi facebook microsoft
do
    output="../data/${site}_pr_${to}.tsv"
    main_cmd="${cmd} -s ${site} -o ${output} -f ${from} -t ${to}"
    echo ${main_cmd}
    eval ${main_cmd}
done
# pr.tsv を作成
./tsv2input.sh ${to}
# DBを更新
../cgi/db/update.rb -d ../cgi/db/pr_table.sqlite3 -i /tmp/pr.tsv
