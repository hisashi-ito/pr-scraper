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
#          2020.07.24 Scraper にBaidu,Rakutenを追加
#          2020.07.26 Scraper にDocomo,メルカリ,DMMを追加
#          2020.07.27 Scraper にLINE,CyberAgentを追加
#          2020.07.28 Scraper にAppleを追加
#          2020.07.29 Scraper にYahoo を追加
#          2020.08.08 Scraper にAlibaba,Microsoft を追加
#
$: << File.join(File.dirname(__FILE__), '../lib')
require 'logger'
require 'optparse'
require 'time'
require 'softbank_scraper'
require 'baidu_scraper'
require 'rakuten_scraper'
require 'docomo_scraper'
require 'mercari_scraper'
require 'dmm_scraper'
require 'line_scraper'
require 'apple_scraper'
require 'yahoo_scraper'
require 'alibaba_scraper'
require 'microsoft_scraper'

class PrScraper
  def initialize(logger, site, output, from, to)
    @logger = logger
    @site = site
    @output = output
    @from = Time::parse(from).to_i
    @to = Time::parse(to).to_i
    # Scraper の設定
    @scraper = nil
    if @site == "softbank"
      @scraper = SoftBankScraper.new(@logger, {}, @from, @to)
    elsif @site == "baidu"
      @scraper = BaiduScraper.new(@logger, {}, @from, @to)
    elsif @site == "rakuten"
      @scraper = RakutenScraper.new(@logger, {}, @from, @to)
    elsif @site == "docomo"
      @scraper = DocomoScraper.new(@logger, {}, @from, @to)
    elsif @site == "mercari"
      @scraper = MercariScraper.new(@logger, {}, @from, @to)
    elsif @site == "dmm"
      @scraper = DmmScraper.new(@logger, {}, @from, @to)
    elsif @site == "line"
      @scraper = LineScraper.new(@logger, {}, @from, @to)
    elsif @site == "cyberagent"
      @scraper = CyberagentScraper.new(@logger, {}, @from, @to)
    elsif @site == "apple"
      @scraper = AppleScraper.new(@logger, {}, @from, @to)
    elsif @site == "Yahoo"
      @scraper = YahooScraper.new(@logger, {}, @from, @to)
    elsif @site == "alibaba"
      @scraper = AlibanaScraper.new(@logger, {}, @from, @to)
    elsif @site == "microsoft"
      @scraper = MicrosoftScraper.new(@logger, {}, @from, @to)
    end
  end # initialize
  
  def perform()
    ret = @scraper.scrape()
    # 出力
    o = open(@output, "w")
    ret.each do |ary|
      o.puts(ary.join("\t"))
    end
    o.close()
  end
end # pr scraper


def main(argv)
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  param = argv.getopts("s:o:f:t:")
  if param["o"].nil? || param["s"].nil? || param["f"].nil? || param["t"].nil?
    $stderr.puts "usage: pr_scraper -s <site> -o <output> -f <from YYYYMMDD> -t <to YYYYMMDD>"
  end
  logger.info("*** start pr_scraper ***")
  PrScraper.new(logger, param["s"], param["o"], param["f"], param["t"]).perform()
  logger.info("*** stop pr_scraper ***")
end


if __FILE__ == $0
  main(ARGV)
end
