#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【rakuten_scraper】
#
#  概要: NTTドコモ プレスリリース
#        https://www.nttdocomo.co.jp/info/news_release/year.html?year=2020
#        のニュースリリース情報を抽出する
#
#  更新履歴:
#           2020.07.26 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require "bundler/setup"
require 'base_scraper'
require 'logger'
require 'time'
require 'cgi'
require 'nokogiri'
require 'extractcontent'
SLEEP = 0.25

class DocomoScraper < BaseScraper
  #= 初期化
  def initialize(logger, params, from, to)
    super(logger, params)
    # 解析対象時間(UNIX TIME)で指定するようにする
    @from = from
    @to = to
  end # initialize

  def _scrape(url)
    ret = []
    link_info = []
    html = request(url) # URLは固定
    doc = parse(html)
    date = nil; link = nil; title = nil
    doc.xpath("//ul[@class='list-cmn-info']/li").each do |x|
      time_str = x.xpath("p[@class='time']")[0].text
      utime = Time.strptime(time_str, "%Y年%m月%d日").to_i
      link = x.xpath("div/p/a")[0].attribute("href").value
      link = 'https://www.nttdocomo.co.jp' + link if link !~ (/^http/)
      title =  x.xpath("div/p/a")[0].text
      link_info.push([utime, link, time_str, title])
    end # doc
    
    # リンクを回して本文情報を取得
    link_info.sort!
    link_info.each do |elems|
      sleep SLEEP
      utime, link, time_str, title = elems
      # 時間が指定の範囲にあるかどう
      if @from <= utime and utime <= @to
        ary = link_body(link)
        if ary == nil
          ret.push([time_str, title ,link, ""])
        else
          body = trim(ary[1])
          ret.push([time_str, title ,link, body])
        end
      end
    end
    return ret
  end # _scrape
  
  def scrape()
    return _scrape("https://www.nttdocomo.co.jp/info/news_release/year.html?year=2020")
  end
end # docomo scraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  docomo = DocomoScraper.new(logger, params, from, to)
  p docomo.scrape()
end
