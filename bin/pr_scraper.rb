#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
#【pr_scraper】
#
# 概要:
#      特定の企業のプレスリリースを期間指定で
#      スクレイピングしtsvファイルに出力する機能を提供する
#
#      出力フォーマットは以下のとおり
#      --
#      URL<TAB>日付<TAB>PRタイトル<TAB>本文
#      --
#
# usage: pr_scraper.rb -s <サイト名>
#                      -o <出力ファイル名>
#                      -f <収集開始日付> (YYYYMMDD)
#                      -t <収集終了日付> (YYYYMMDD)
#
# 更新履歴:
#          2020.07.13 新規作成
#
$: << File.join(File.dirname(__FILE__), '../lib')
require 'softbank_analyzer'
require 'logger'
require 'optparse'
require 'time'
 
class PrScraper
  def initialize(logger, site, output, from, to)
    @logger = logger
    @site = site
    @output = output
    @from = Time::parse(from)
    @to = Time::parse(to)
    @scraper = nil
    if @site == "softbank"
      # ソフトバンクのPR
      @scraper = SoftBankAnalyzer.new(logger)
    end
    
    
    
  end # initialize

  

  
end # pr scraper


def main(argv)
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  param = argv.getopts("s:o:f:t:")
  if param["o"].nil? || param["s"].nil? || param["f"].nil? || param["t"].nil?
    $stderr.puts "usage: pr_scraper -s <site> -o <output> -f <from YYYYMMDD> -t <to YYYYMMDD>"
  end

  
  
end

if __FILE__ == $0
  main(ARGV)
end