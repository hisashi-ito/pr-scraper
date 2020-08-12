#! /bin/bash
day=$1

# ファイルが存在したら削除する
if [ -e ./pr.tsv ]; then
    rm ./pr.tsv
fi

for site in alibaba amazon apple baidu cyberagent dmm docomo facebook google kddi line mercari microsoft rakuten softbank yahoo
do
    input="${site}_pr_${day}.tsv"
    cat ../data/${input} | /usr/bin/ruby ./tsv2input.rb ${site} >> ./pr.tsv
done
# tmp へcopy しておく
cp ./pr.tsv /tmp
