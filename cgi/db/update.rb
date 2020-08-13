#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【update】
#
#  usage: update.rb -d <db>
#                   -i <input>
#
require "bundler/setup"
require 'logger'
require 'sqlite3'
require 'optparse'

class DB
  def initialize(logger, input, db)
    @logger = logger
    @db = SQLite3::Database.new(db)
    @input = input
  end
  
  def update()
    f = open(@input, "r")
    while line = f.gets
      begin
        # domain, unix_time, display_time, title, link, body
        domain, unix_time, display_time, title, link, body = line.chomp.split("\t",-1)
        # db にlink のデータがあるか確認する 
        sql = "select link from pr_table where link = '#{link}'"
        ret = @db.execute(sql)
        
        # 重複データがあるのでスキップ
        next if ret.size != 0
        # データの登録
        sql = "insert into pr_table (domain, unix_time, display_time, title, link, body) values ('#{domain}', '#{unix_time}', '#{display_time}', '#{title}', '#{link}', '#{body}')"
        @db.execute(sql)
      rescue Exception => e
        @logger.error("DB操作時にエラーが発生しました: #{e.backtrace.join("\n")}")
        next
      end
    end
  end
end

def main(argv)
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  param = argv.getopts("d:i:")
  if param["i"].nil? || param["d"].nil?
    $stderr.puts "usage: update.rb -d <db> -i <input>"
    exit
  end
  logger.info("*** start update ***")
  DB.new(logger, param["i"], param["d"]).update()
  logger.info("*** end update ***")
end

if __FILE__ == $0
  main(ARGV)
end
