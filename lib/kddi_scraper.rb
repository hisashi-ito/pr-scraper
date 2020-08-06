#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# 【kddi_scraper】
#
#  概要: KDDI プレスリリース
#        https://www.kddi.com/corporate/newsrelease/2020/
#        のニュースリリース情報を抽出する
#
#  更新履歴:
#           2020.07.25 新規作成
#
$: << File.join(File.dirname(__FILE__), '.')
require "bundler/setup"
require 'base_scraper'
require 'logger'
require 'time'
require 'cgi'
require 'nokogiri'
SLEEP = 0.25

class KddiScraper < BaseScraper
  URL_TOP = 'https://www.kddi.com/corporate/newsrelease/2020/'

 #= 初期化
  def initialize(logger, params, from, to)
    super(logger, params)
    # 解析対象時間(UNIX TIME)で指定するようにする
    @from = from
    @to = to
  end # initialize
  
  def _scrape(url)
    link_info = []
    html = request(url)
    doc = parse(html)
    doc.xpath("//div[@class='pbNested pbNestedWrapper']").each do |x|
      p trim(x.text)
    end
  end # _scrape

  def scrape()
    _scrape(URL_TOP)
  end # scrape
end # kddi scraper


if __FILE__ == $0
  logger = Logger.new(STDERR)
  logger.level = Logger::INFO
  params = {}
  from = Time::parse("2020/04/01").to_i
  to = Time::parse("2020/6/30").to_i
  kddi = KddiScraper.new(logger, params, from, to)
  kddi.scrape()
end
