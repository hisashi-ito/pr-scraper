#! /bin/bash
cmd="/usr/bin/ruby ./update.rb"
db="./pr_table.sqlite3"
input="/tmp/pr.tsv"
main_cmd="${cmd} -i ${input} -d ${db}"
echo ${main_cmd}

